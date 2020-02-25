%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
%pathtodata='E:\guessTheDot\Data\fsl_output\';
%output_path='E:\guessTheDot\Analysis\Searchlight';
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Searchlight\singleStim_linear_bet\Single_Stim_LDA\';
output_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Searchlight\singleStim_linear_bet\Single_Stim_LDA\FDR_Matlab\';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];%[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];%[7,8,9,11,12,13,14,16,17,18,20,22,23,25,26,27,28,29,30,31,33,34,35];%
chance=1/6;
condition='IMAGERY';%'CROSS';%'PERCEPTION';%
accuracyGroup=[];
ds_cell=[];
 %% Subtract chance level from Searchlights
 for iSub=1:length(subList)
     %Load searchlight
     ds=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_searchlight_singleStim_100_%s.nii.gz',subList(iSub), condition)))
%      if strmatch(condition,'CROSS')
%          targets=repmat((1:3)',1,2)';
%          targets=targets(:);
%          targets=repmat(targets,10,1);
%          ds.sa.targets=targets;
%          %Change from predictions to accuracy
%          acc_ds=cosmo_slice(ds,1);  % take single slice
%          acc_ds.sa=struct();             % reset sample attributes
%          acc_ds.samples=nanmean(bsxfun(@eq,ds.samples,ds.sa.targets));
%          %Subtract chance-level
%          acc_ds.samples=(acc_ds.samples-chance);
%          %Switch from prediction to accuracy
%          %Save corrected searchlight
%          cosmo_map2fmri(acc_ds,fullfile(pathtodata,sprintf('SUB%02d_searchlight_LDA_100_%s_corrected.nii',subList(iSub), condition)));
%          %cosmo_plot_slices(ds);
%      else
         %Subtract chance-level
         ds.samples=(ds.samples-chance);
         %Switch from prediction to accuracy
         %Save corrected searchlight
         cosmo_map2fmri(ds,fullfile(output_path,sprintf('SUB%02d_searchlight_singleStim_100_%s_corrected.nii',subList(iSub), condition)));
         %cosmo_plot_slices(ds);
%      end
 end
%% Create group DS
 for iSub=1:length(subList)
     %Load searchlight
     ds=cosmo_fmri_dataset(fullfile(output_path,sprintf('SUB%02d_searchlight_singleStim_100_%s_corrected.nii',subList(iSub), condition)))
     %Create a cell structure with one field for each subject
     ds_cell{iSub}=ds;
 end
%Compute intersection between participants
[idxs,ds_intersect_cell]=cosmo_mask_dim_intersect(ds_cell);
%For (second level) group analysis, in general, it is a good idea to assign chunks (if not done already) and targets. 
%The general approach to setting chunks is by indicating that data from different participants is assumed to be independent; 
%for setting targets, see the help of cosmo stat:

n_subjects=numel(ds_intersect_cell);
for subject_i=1:n_subjects
    % get dataset
    ds=ds_intersect_cell{subject_i};

    % assign chunks
    n_samples=size(ds.samples,1);
    ds.sa.chunks=ones(n_samples,1)*subject_i;

    % assign targets
    ds.sa.targets=1;
    
    % store results
    ds_intersect_cell{subject_i}=ds;
end
%Stack all subjects toghether
ds_all=cosmo_stack(ds_intersect_cell,1);

% SAVE MAP
%cosmo_map2fmri(ds_all,[fullfile(output_path,sprintf('group_searchlight_%s_N=%d_corrected.mat', condition, length(subList)))]); % questa mappa è la media dei dati di group_ds (17 celle) per ciascun voxel across subjects. Output = 1 cella x nr voxels
cosmo_map2fmri(ds_all,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_corrected.vmp', condition, length(subList)))]);
cosmo_map2fmri(ds_all,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_corrected.nii.gz', condition, length(subList)))]);

% COMPUTE ONE SAMPLE T-TEST 
% fa un one sample t test 1tail di ogni voxel contro chance level (in questo caso 33%)
one_sample_ds =ds_all;
stat_ds=cosmo_stat(one_sample_ds, 't');
stat_ds_p=cosmo_stat(one_sample_ds,'t','p');
%Correct t-test to be p=0.001. So, I assign to each p>0.001 value =1 so
%that it is not considered
% for i = 1:length(stat_ds_p.samples)
%     if stat_ds_p.samples(i)>0.001
%         stat_ds.samples(i)=0;
%     end
% end
% SAVE ONE SAMPLE T TEST FIGURE IN MNI SPACE!!!!!!
cosmo_map2fmri(stat_ds,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_corrected_one_sample_t.vmp', condition, length(subList)))]); % questa mappa è il t-test sui dati non corretti di group-ds
cosmo_map2fmri(stat_ds,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_corrected_one_sample_t.nii', condition, length(subList)))]);
cosmo_map2fmri(stat_ds,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_corrected_one_sample_t.nii.gz', condition, length(subList)))]);

%Per correggere FDR chiama funzione FDR_bh e dai come input il p del t-test
%a group level (stat_ds_p.samples)
[result_fdr, result_crit_p, adj_ci_cvrg, adj_p]=fdr_bh(stat_ds_p.samples,0.05,'pdep','yes');
%In result_fdr you have a binary mask with voxels that survives FDR
%correction. Now select in stat_ds only the voxels that survived with their
%t value and set others to 0
stat_ds_fdr=stat_ds;
for k=1:length(result_fdr)
    if result_fdr(k)==0
        stat_ds_fdr.samples(k)=0;
    end
end       
%Salva stat_ds_fdr come nifti file. E' la tua mappa corretta FDR per la
%searchlight
cosmo_map2fmri(stat_ds_fdr,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_0.05_FDR_corrected.nii.gz', condition, length(subList)))]);
cosmo_map2fmri(stat_ds_fdr,[fullfile(output_path,sprintf('group_searchlight_singleStim_%s_N=%d_0.05_FDR_corrected.vmp', condition, length(subList)))]);

%%% giro questo (statistica non parametrica) sul CLUSTER perchè ci mette un sacco.
% % COMPUTE COSMO STATS FOR FMRI 
% nbrhood=cosmo_cluster_neighborhood(group_ds,'progress',false);
% ds_z=cosmo_montecarlo_cluster_stat(group_ds,nbrhood,'niter',10000,  'h0_mean', 0.5,'progress',10 );
% %ds_z=cosmo_montecarlo_cluster_stat(group_ds,nbrhood,'niter',10,  'h0_mean', 0.5, 'progress',10 );
% 
% % SAVE ACCURACY FILE 
% save([comp_folder filesep 'ds_z'],'ds_z'); 
% % SAVE MAP
% cosmo_map2fmri(ds_z,[comp_folder filesep filename '_cosmo.vmp']);
% cosmo_map2fmri(ds_z,[comp_folder filesep filename '_cosmo.nii']);
