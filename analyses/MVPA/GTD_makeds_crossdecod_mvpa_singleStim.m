function [ds]=GTD_makeds_crossdecod_mvpa(subList,iSub,nRuns,maskID,maskType)
%Define paths
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses';
%mask='PERvsREST_group_ROI_Mul_Thr2.3.nii.gz';%'V1_BA17_Thr.nii.gz';%'V1_BA17_Thr_Reg.nii.gz';%
for iRun=1:nRuns
    %BLOCK ANALYSIS - t-stat images aligned MNI
    %Load PERCEPTION t-stats first and then IMAGERY - chunks: 1=PERCEPTION,
    %2 = IMAGERY
    pathtosub=fullfile(pathtodata,'MVPA','singleStim_linearReg_Bet','Single_stim',sprintf('SUB%02d',subList(iSub)));
    %Create temporary variables for PERCEPTION CONDITION
    condition='PERCEPTION';
    sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subList(iSub), iRun, condition)
    PER_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    PER_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
%     PER_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     PER_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));

    %Create temporary variables for IMAGERY CONDITION
    condition='IMAGERY';
    sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subList(iSub), iRun, condition)
    IMG_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    IMG_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
%     IMG_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     IMG_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
    %cosmo_disp(ds)
    genvarname('ds',num2str(iRun));
    %Stack them toghether for each RUN
    eval(['ds' num2str(iRun) '=cosmo_stack({PER_temp_e1,PER_temp_e2,PER_temp_n1,PER_temp_n2,PER_temp_pen1,PER_temp_pen2,PER_temp_watch1,PER_temp_watch2,PER_temp_circle1,PER_temp_circle2,PER_temp_triangle1,PER_temp_triangle2,IMG_temp_e1,IMG_temp_e2,IMG_temp_n1,IMG_temp_n2,IMG_temp_pen1,IMG_temp_pen2,IMG_temp_watch1,IMG_temp_watch2,IMG_temp_circle1,IMG_temp_circle2,IMG_temp_triangle1,IMG_temp_triangle2})'])
    PER_temp_e1=[];PER_temp_e2=[];PER_temp_n1=[];PER_temp_n2=[];PER_temp_pen1=[];PER_temp_pen2=[];PER_temp_watch1=[];PER_temp_watch2=[];PER_temp_circle1=[];PER_temp_circle2=[];PER_temp_triangle1=[];PER_temp_triangle2=[];
    IMG_temp_e1=[];IMG_temp_e2=[];IMG_temp_n1=[];IMG_temp_n2=[];IMG_temp_pen1=[];IMG_temp_pen2=[];IMG_temp_watch1=[];IMG_temp_watch2=[];IMG_temp_circle1=[];IMG_temp_circle2=[];IMG_temp_triangle1=[];IMG_temp_triangle2=[];
end
%Stack toghether ALL 5 RUNS
ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
%Remove useless data in ds
ds=cosmo_remove_useless_data(ds);
%Define tatgets, chunks and label for ds
%Define targets and chunks for BLOCK ANALYSIS (6 observations x run) - BOTH FOR BETA AND TSTATS
    targets=repmat((1:6)',1,2)';
    targets=targets(:);
    targets=repmat(targets,10,1);
    chunks=zeros(120,1);
    chunks=[repmat(1,1,24),repmat(2,1,24),repmat(3,1,24),repmat(4,1,24),repmat(5,1,24)]';
    %Use lines below if you want to discriminate between modalities with
    %chunks
%     chunks=zeros(60,1);
%     chunks=[repmat(1,1,6),repmat(2,1,6)];
%     chunks=repmat(chunks,1,5)';
    %Set modality for crossdecoding: 1=PER,2=IMG.
    modality=zeros(120,1);
    modality=[repmat(1,1,12),repmat(2,1,12)];
    modality=repmat(modality,1,5)';
    labels=repmat({'e'; 'n'; 'pen'; 'watch'; 'circle'; 'triangle'},1,2)';
    labels=labels(:);
    labels=repmat(labels,10,1);
    ds.sa.targets=targets;
    ds.sa.chunks=chunks;
    ds.sa.labels=labels;
    ds.sa.modality=modality;
%Clear temporary dataset variables
ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];
