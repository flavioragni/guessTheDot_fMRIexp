%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\singleStim_linearReg_Bet\Single_stim';
outputpath='C:\Users\flavio.ragni\Google Drive\guessTheDot\Analisys\MVPA\permutations_rois\leftright';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
nRuns=5;
condition='IMAGERY';%'PERCEPTION';%
ROIs_high={'250_V1_BA17_real_3mm.nii.gz','250_V2_BA18_real_3mm.nii.gz'};
ROIs_control={'ventral_striatum_real_3mm.nii.gz'};
chance=1/6;
niter=100;
accuracyGroup=[];
 %% N-fold cross-validation
 for iSub=1:length(subList)
     for iROI=1:length(ROIs_high)
         maskID=char(ROIs_high(iROI));
         [ds]=GTD_makeds_mvpa_singleStim(subList,iSub,nRuns,condition,maskID);
         %Define which classifiers you want to use
         classifiers={@cosmo_classify_lda};
         %Print which classifiers are used
         nclassifiers=numel(classifiers);
         classifiers_names=cellfun(@func2str,classifiers,'UniformOutput',false);
         fprintf('\nUsing %d classifiers: %s in mask %s\n', nclassifiers,cosmo_strjoin(classifiers_names,','),maskID);
         %Create partitions
         p=cosmo_nfold_partitioner(ds);
         %Make a copy of original dataset
         ds0=ds;
         %For niter iterations, reshuffle the labels and run the
         %classification analysis
         for k=1:niter
             for x = 1: length(p.test_indices)
                 data = ds0.sa.targets(p.test_indices{x});
                 ds0.sa.targets(p.test_indices{x}) = data(randperm(size(data,1)),:);
             end
             args=struct();
             args.classifier = @cosmo_classify_lda;
             args.partitions = p;
             args.output='accuracy';
             measure=@cosmo_crossvalidation_measure;
             warning off
             %Store accuracy
             perm_result{k,iROI} = measure(ds0,args);
             desc=sprintf('SUB%02d - LDA: accuracy %.1f%%', subList(iSub), perm_result{k,iROI}.samples*100)
         end
     end
     save(fullfile(outputpath, sprintf('sub%02d_%s_LDA_permuted_rois_high250.mat', subList(iSub), condition)),'perm_result')
 end