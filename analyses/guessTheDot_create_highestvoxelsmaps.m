%% guessTheDot_create_highestvoxelsmaps.m - Script used for the selection of voxels showing the highest activation 
%  within a condition (either imagery or perception - case 1) or in both imagery and perception conditions
%  (implemented using feature scaling - case2).

clear all

pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];%[11,12,13,14,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35];%
nRuns=5;
condition='IMAGERY';%'PERCEPTION';%
maskLabel={'juleich','PERvsREST'};
criteria=2;%1;% 1=Single condition; 2=Combined
ROIs_standard= {'V1_BA17_real_3mm.nii.gz','V2_BA18_real_3mm.nii.gz','ventral_striatum_real_3mm.nii.gz'};
count=[];
voxelsTemp=[];
voxels=[];
%% Load t-maps with cosmomvpa
for iSub=1:length(subList)
    figure()
    switch criteria
        case 1
            %STANDARD ROIs
            pathtosub=fullfile(pathtodata,'MVPA','Single_stim',sprintf('SUB%02d',subList(iSub)));
            sprintf('Processing tstat for SUB%02d %s',subList(iSub),char(ROIs_standard(iROI)))
            %Create temporary variables for each cope image of interest
            maskID=char(ROIs_standard(iROI));
            ds1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN01_%s_MVPA_singleStim__tstat1_alignedMNI.nii.gz',subList(iSub),condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
            ds2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN02_%s_MVPA_tstat1_alignedMNI.nii.gz',subList(iSub),condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
            ds3=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN03_%s_MVPA_tstat1_alignedMNI.nii.gz',subList(iSub),condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
            ds4=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN04_%s_MVPA_tstat1_alignedMNI.nii.gz',subList(iSub),condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
            ds5=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN05_%s_MVPA_tstat1_alignedMNI.nii.gz',subList(iSub),condition)),'mask', fullfile(pathtodata,'rois','standard',maskID));
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
            %Take the mean t value of each voxel across the 5 runs
            ds.samples=mean(ds.samples,1);
            %Sort voxels based on their absolute value
            ds.samples=abs(ds.samples);
            mask=ds;
            mask.samples(:)=0;
            for i=1:250
                [M,I]=max(ds.samples);
                mask.samples(I)=1;
                ds.samples(I)=NaN;
            end
            cosmo_map2fmri(mask,fullfile(pathtodata,'rois','rois_high',sprintf('SUB%02d_%s_%s',subList(iSub),condition,maskID)));
            
        case 2
            %STANDARD ROIs
            pathtosub=fullfile(pathtodata,'MVPA','Single_stim',sprintf('SUB%02d',subList(iSub)));
            %Create temporary variables for each cope image -
            %PERCEPTION
            condition='PERCEPTION';
            for iRun=1:nRuns
                ds_per_temp1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp3=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp4=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp5=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp6=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp7=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp8=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp9=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp10=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp11=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_per_temp12=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                genvarname('ds',num2str(iRun));
                %Stack them toghether for each RUN
                eval(['ds_per' num2str(iRun) '=cosmo_stack({ds_per_temp1,ds_per_temp2,ds_per_temp3,ds_per_temp4,ds_per_temp5,ds_per_temp6,ds_per_temp7,ds_per_temp8,ds_per_temp9,ds_per_temp10,ds_per_temp11,ds_per_temp12})']);
                ds_per_temp1=[];ds_per_temp2=[];ds_per_temp3=[];ds_per_temp4=[];ds_per_temp5=[];ds_per_temp6=[];ds_per_temp7=[];ds_per_temp8=[];ds_per_temp9=[];ds_per_temp10=[];ds_per_temp11=[];ds_per_temp12=[];
            end
            ds_per=cosmo_stack({ds_per1,ds_per2,ds_per3,ds_per4,ds_per5});
            %Average t-values across PER runs
            ds_per.samples=mean(ds_per.samples,1);
            %Create temporary variables for each cope image -
            %IMAGERY
            condition='IMAGERY';
            for iRun=1:nRuns
                ds_img_temp1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp3=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp4=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp5=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp6=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp7=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp8=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp9=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp10=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp11=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                ds_img_temp12=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subList(iSub),iRun,condition)));
                genvarname('ds',num2str(iRun));
                %Stack them toghether for each RUN
                eval(['ds_img' num2str(iRun) '=cosmo_stack({ds_img_temp1,ds_img_temp2,ds_img_temp3,ds_img_temp4,ds_img_temp5,ds_img_temp6,ds_img_temp7,ds_img_temp8,ds_img_temp9,ds_img_temp10,ds_img_temp11,ds_img_temp12})']);
                ds_img_temp1=[];ds_img_temp2=[];ds_img_temp3=[];ds_img_temp4=[];ds_img_temp5=[];ds_img_temp6=[];ds_img_temp7=[];ds_img_temp8=[];ds_img_temp9=[];ds_img_temp10=[];ds_img_temp11=[];ds_img_temp12=[];
            end
            ds_img=cosmo_stack({ds_img1,ds_img2,ds_img3,ds_img4,ds_img5});
            %Average t-values across IMG runs
            ds_img.samples=mean(ds_img.samples,1);
            %Start voxels selection
            for iROI=1:length(ROIs_standard)
                sprintf('Processing tstat for SUB%02d %s',subList(iSub),char(ROIs_standard(iROI)))
                maskID=char(ROIs_standard(iROI));
                ds_per_ROI=cosmo_fmri_dataset(ds_per,'mask', fullfile(pathtodata,'rois','standard',maskID));
                ds_img_ROI=cosmo_fmri_dataset(ds_img,'mask', fullfile(pathtodata,'rois','standard',maskID));
                %Stack toghether PER and IMG
                ds=cosmo_stack({ds_per_ROI,ds_img_ROI});
                %Normalize the data transforming their value between 0 & 1
                maxPer=max(ds.samples(1,:));
                minPer=min(ds.samples(1,:));
                maxImg=max(ds.samples(2,:));
                minImg=min(ds.samples(2,:));
                for n=1:length(ds.samples(1,:))
                    ds.samples(1,n)=(ds.samples(1,n)-minPer)/(maxPer-minPer);
                    ds.samples(2,n)=(ds.samples(2,n)-minImg)/(maxImg-minImg);
                end
                %Apply feature scaling for each voxel
                for l=1:length(ds.samples(1,:))
                    ds.samples(3,l)=(ds.samples(1,l)*max(ds.samples(1,:)))+(ds.samples(2,l)*max(ds.samples(2,:)));
                end
                mask=ds;
                mask.samples(:)=0;
                mask.samples(2:end,:)=[];
                %Sort ds.samples(3,:) and take first 250 voxels
                [B,I] = sort(ds.samples(3,:),'descend');
                %Make plot with data
                subplot(3,3,iROI)
                scatter(ds.samples(1,:),ds.samples(2,:))
                title(ROIs_standard{iROI});
                hold on
                %Set mask size
                for i=1:250
                    mask.samples(I(i))=1;
                    scatter(ds.samples(1,I(i)),ds.samples(2,I(i)),'r')
                end
                hold off
                cosmo_map2fmri(mask,fullfile(pathtodata,'rois','rois_singleStim','Real',sprintf('SUB%02d_singleStim_%s',subList(iSub),maskID)));
                mask=[];
                ds=[];
                ds_per_ROI=[];
                ds_img_ROI=[];
            end
            print(gcf,fullfile(pathtodata,'rois','rois_singleStim','Real',sprintf('SUB%02d_voxel_selection',subList(iSub))),'-dpng');
            close(gcf)
    end
    ds_per=[];
    ds_img=[];
end
