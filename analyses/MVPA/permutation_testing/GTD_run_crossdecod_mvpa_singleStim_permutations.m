%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Single_stim';
outputpath='C:\Users\flavio.ragni\Google Drive\guessTheDot\Analisys\MVPA\permutations_rois\';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
nRuns=5;
maskType=6;%5;%4;%3;%1;%2%  %1='common' - 2='individual for each run' - 3='individual for each subject' - 4='BLOCK ANALYSIS' - 5='BLOCK ANALYSIS T-STAT'
% ROIs_high={'V1_BA17_Thr_3mm.nii.gz','V1_BA17_Left_Thr_3mm.nii.gz','V1_BA17_Right_Thr_3mm.nii.gz','V2_BA18_Thr_3mm.nii.gz','V2_BA18_Left_Thr_3mm.nii.gz','V2_BA18_Right_Thr_3mm.nii.gz'};
ROIs_high={'V1_BA17_real_3mm.nii.gz','V2_BA18_real_3mm.nii.gz','ventral_striatum_real_3mm.nii.gz'};%{'ventral_striatum_3mm.nii.gz'};%
ROIs_control={'ventral_striatum_real_3mm.nii.gz'};
chance=1/6;
niter=100;
accuracyGroup=[];
 %% N-fold cross-validation
 for iSub=1:length(subList)
         ROIs=ROIs_high;
     for iROI=1:length(ROIs_high)
         maskID=char(ROIs_high(iROI));
         [ds]=GTD_makeds_crossdecod_mvpa_singleStim(subList,iSub,nRuns,maskID,maskType);
         %Function GTD_makeds_mvpa retun ds for currentSub already cleaned and
         %masked
         %Samples from a single chunk are used as test set, other chunks as
         %training set. Procedure repeated for all chunks.
         %Using measuers
         %Define which classifiers you want to use
         classifiers={@cosmo_classify_lda};
         %Print which classifiers are used
         nclassifiers=numel(classifiers);
         classifiers_names=cellfun(@func2str,classifiers,'UniformOutput',false);
         fprintf('\nUsing %d classifiers: %s in mask %s\n', nclassifiers,cosmo_strjoin(classifiers_names,','),maskID);
         %Create partitions
         p=cosmo_nchoosek_partitioner(ds,1,'modality',[]);
         %Make a copy of original dataset
         ds0=ds;
         %For niter iterations, reshuffle the labels and run the searchlight
         for k=1:niter
             % per ogni p.test_indices
             for x = 1: length(p.test_indices)
                 data = ds0.sa.targets(p.test_indices{x});
                 ds0.sa.targets(p.test_indices{x}) = data(randperm(size(data,1)),:);
             end
             
             % define measure and its arguments; here crossvalidation with LDA
             % classifier to compute classification accuracies
             args=struct();
             args.classifier = @cosmo_classify_lda;
             args.partitions = p;
             args.output='accuracy';
             measure=@cosmo_crossvalidation_measure;
             warning off
             %Run searchlight (without showing progress bar)
             perm_result{k,iROI} = measure(ds0,args);
             desc=sprintf('SUB%02d - LDA: accuracy %.1f%%', subList(iSub), perm_result{k,iROI}.samples*100)
             % save for every K (= nr iteration) a dataset result{k} with .sa .samples .fa .a of a
             % null distribution
             % save this, in every cell[100] a dataset
         end
     end
     save(fullfile(outputpath, sprintf('sub%02d_CROSS_LDA_permuted_rois.mat', subList(iSub))),'perm_result')
 end