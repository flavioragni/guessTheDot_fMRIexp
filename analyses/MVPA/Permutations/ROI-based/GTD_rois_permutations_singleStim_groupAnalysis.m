clear all;
pathtodata='C:\Users\flavio.ragni\Google Drive\guessTheDot\Analisys\MVPA\';
outputpath='C:\Users\flavio.ragni\Google Drive\guessTheDot\Analisys\MVPA\permutations_rois\leftright\';
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
ROIs_high={'V1_BA17_real_3mm.nii.gz','V2_BA18_real_3mm.nii.gz','ventral_striatum_real_3mm.nii.gz'};
chance=1/6;
accuracyGroup=[];
%% STEP 1: LOAD REAL DATASET
%Load group accuracy for group data
group_img = load(fullfile(pathtodata,'accuracyGroup_IMAGERY_Single_stim_N=21_leftright250.mat'));
group_per = load(fullfile(pathtodata,'accuracyGroup_PERCEPTION_Single_stim_N=21_leftright250.mat'));
group_cross = load(fullfile(pathtodata,'accuracyGroup_CROSS_Single_stim_N=21_leftright250.mat'));
%Organize data: V1 (PER, IMG, CROSS), V2 (PER, IMG, CROSS), striatum (PER,
%IMG, CROSS)
acc_group_real = [];
for k = 1:length(ROIs_high)
    acc_group_per = group_per.accuracyGroup(:,1,k);
    acc_group_img = group_img.accuracyGroup(:,1,k);
    acc_group_cross = group_cross.accuracyGroup(:,1,k);
    acc_group_real = [acc_group_real, acc_group_per, acc_group_img, acc_group_cross];
end
%Prepare dataset for permutations; assign chunks and targets
ds_all_real=struct();
ds_all_real.samples=acc_group_real;
n_samples=size(ds_all_real.samples,1);
ds_all_real.sa.chunks=(1:n_samples)';     % all subjects are independent
ds_all_real.sa.targets=ones(n_samples,1); % one-sample t-test
ds_all_real.a=struct;
ds_all_real.fa=struct;

%% STEP 2: LOAD PERMUTED DATASET
niter = 100;
%n_sub=length(Cfg.subList);
%Create a null matrix having 100 cells, corresponding to 100 group premuted 
%maps. Each group map should be created by the kth permuted accuracy value for each
%participant in variable a. No intersection needed since dimensionality is
%the same (one accuracy value for each participant).
for k = 1: niter
    a = [];
    for iSub = 1: length(subList)
        %load file
        perm_img = load(fullfile(outputpath,sprintf('sub%02d_IMAGERY_LDA_permuted_rois_leftright250.mat', subList(iSub))));
        perm_per = load(fullfile(outputpath,sprintf('sub%02d_PERCEPTION_LDA_permuted_rois_leftright250.mat', subList(iSub))));
        perm_cross = load(fullfile(outputpath,sprintf('sub%02d_CROSS_LDA_permuted_rois_leftright250.mat', subList(iSub))));
        a_per=[];a_img=[];a_cross=[];
        for h = 1:length(ROIs_high)
            a_per = [a_per, perm_per.perm_result{k,h}.samples];
            a_img = [a_img, perm_img.perm_result{k,h}.samples];
            a_cross = [a_cross, perm_cross.perm_result{k,h}.samples];
        end
        a = [a;a_per, a_img, a_cross];    
    end
    permuted_group_ds{k}.samples = a;
    n_samples=size(permuted_group_ds{k}.samples,1);
    permuted_group_ds{k}.sa.chunks=(1:n_samples)';     
    permuted_group_ds{k}.sa.targets=ones(n_samples,1); 
    permuted_group_ds{k}.a=struct;
    permuted_group_ds{k}.fa=struct;
end
%% COMPUTE COSMO STATS WITH PERMUTED DATA    
nbrhood=cosmo_singleton_neighborhood(ds_all_real);
%load ds(group_ds) and ds_permuted (null_data) 
ds_z_permuted=cosmo_montecarlo_cluster_stat(ds_all_real,nbrhood,'niter',10000, 'h0_mean', chance,'progress',10, 'null', permuted_group_ds);
% % SAVE ACCURACY FILE 
save([outputpath filesep 'ds_z_permuted_high250'],'ds_z_permuted');
%Transform values in p-values
ds_p_permuted = normcdf(ds_z_permuted.samples)
% Save p_values 
save([outputpath filesep 'ds_p_permuted_high250'],'ds_p_permuted');
