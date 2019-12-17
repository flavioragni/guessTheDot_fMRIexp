function [ds]=GTD_makeds_mvpa_singleStim(subList,iSub,nRuns,condition,maskID)
%Define paths
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses';
%mask='PERvsREST_group_ROI_Mul_Thr2.3.nii.gz';%'V1_BA17_Thr.nii.gz';%'V1_BA17_Thr_Reg.nii.gz';%
for iRun=1:nRuns
    %BLOCK ANALYSIS - t-stat images aligned MNI - 250 highest voxels for each ROI
    pathtosub=fullfile(pathtodata,'MVPA','singleStim_linearReg_Bet','Single_stim',sprintf('SUB%02d',subList(iSub)));
    sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subList(iSub), iRun, condition)
    %Create temporary variables for each cope image of interest
    temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
    temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','rois_singleStim','real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
%     temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
%     temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun, condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
    %cosmo_disp(ds)
    genvarname('ds',num2str(iRun));
    %Stack them toghether for each RUN
    eval(['ds' num2str(iRun) '=cosmo_stack({temp_e1,temp_e2,temp_n1,temp_n2,temp_pen1,temp_pen2;temp_watch1,temp_watch2,temp_circle1,temp_circle2,temp_triangle1,temp_triangle2})'])
    temp_e1=[];temp_e2=[];temp_n1=[];temp_n2=[];temp_pen1=[];temp_pen2=[];temp_watch1=[];temp_watch2=[];temp_circle1=[];temp_circle2=[];temp_triangle1=[];temp_triangle2=[];
end
%Stack toghether ALL 5 RUNS
ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
%Remove useless data in ds
ds=cosmo_remove_useless_data(ds);
%Define tatgets, chunks and label for ds
%Define targets and chunks for BLOCK ANALYSIS (6 observations x run) - BOTH FOR BETA AND TSTATS
targets=repmat((1:6)',1,2)';
targets=targets(:);
targets=repmat(targets,5,1);
chunks=zeros(30,1);
for i=1:5
    idxs=(i-1)*12+(1:12);
    chunks(idxs)=i;
end
labels=repmat({'e'; 'n'; 'pen'; 'watch'; 'circle'; 'triangle'},1,2)';
labels=labels(:);
labels=repmat(labels,5,1);
ds.sa.targets=targets;
ds.sa.chunks=chunks;
ds.sa.labels=labels;
%Clear temporary dataset variables
ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];
end