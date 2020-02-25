%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Single_stim';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
nRuns=5;
ROIs_high={'250_V1_BA17_real_3mm.nii.gz','250_V1_BA17_real_3mm.nii.gz'};
ROIs_control={'ventral_striatum_real_3mm.nii.gz'};
chance=1/6;
accuracyGroup=[];
 %% N-fold cross-validation
 for iSub=1:length(subList)
         ROIs=ROIs_high;
     for iROI=1:length(ROIs_high)
         maskID=char(ROIs_high(iROI));
         [ds]=GTD_makeds_crossdecod_mvpa_singleStim(subList,iSub,nRuns,maskID);
         %Function GTD_makeds_mvpa retun ds for currentSub already cleaned and
         %masked
         %Samples from a single chunk are used as test set, other chunks as
         %training set. Procedure repeated for all chunks.
         %Using measuers
         %Define which classifiers you want to use
         classifiers={@cosmo_classify_lda};
         %Print which classifier is used
         nclassifiers=numel(classifiers);
         classifiers_names=cellfun(@func2str,classifiers,'UniformOutput',false);
         fprintf('\nUsing %d classifiers: %s in mask %s\n', nclassifiers,cosmo_strjoin(classifiers_names,','),maskID);
         %Set measures
         measure=@cosmo_crossvalidation_measure;
         args=struct();
         %Number indicates test modality
         %test_modality=2; %Test on imagery, train on perception
         %test_modality=1; %Test on perception, train on imagery
         %args.partitions=cosmo_nchoosek_partitioner(ds,1,'modality',test_modality);
         args.partitions=cosmo_nchoosek_partitioner(ds,1,'modality',[]);%Test in both directions
         args.output='predictions';
         
         %RUN CLASSIFICATIONS - Compute accuracy predictions for each classifier
         for k=1:nclassifiers
             %Set the classifier
             args.classifier=classifiers{k};
             switch k
                 case 1
                     args.child_classifier=@cosmo_classify_lda;
             end
             %Compute prediction using the measure
             predicted_ds=measure(ds,args);
             %Compute confusion matrix
             confusion_matrix=cosmo_confusion_matrix(predicted_ds);
             %Compute accuracy and store it in variable accuracy
             sum_diag=sum(diag(confusion_matrix));
             sum_total=sum(confusion_matrix(:));
             accuracy=sum_diag/sum_total;
             
             %Store accuracy in a group variable - column 1 LDA, column 2 SVM
             accuracyGroup(iSub,k,iROI)=accuracy;
             %Print classification accuracy in terminal window
             classifier_name=strrep(classifiers_names{k},'_',' ');
             desc=sprintf('SUB%02d - %s: accuracy %.1f%%', subList(iSub), classifier_name, accuracy*100);            
             fprintf('%s\n',desc);
         end
     end
 end
 %Export accuracy in Excel
 for iROI=1:length(ROIs)
    xlswrite(sprintf('accuracyGroup_crossdecod_singleStim_N=%d_high250.xls',length(subList)), accuracyGroup(:,:,iROI),iROI);
 end
 save('accuracyGroup_CROSS_Single_stim_N=21_high250.mat','accuracyGroup');