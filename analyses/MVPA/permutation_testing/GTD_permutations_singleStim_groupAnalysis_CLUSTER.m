function GTD_permutations_singleStim_groupAnalysis_CLUSTER(cond)
%% MVPA test script
%Goal: import dataset from a single run, assign chunks, targets and labels.
Cfg=struct;
addpath(genpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa'));
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/NIfTI_20140122');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/NeuroElf_v11_7101');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/surfing-master');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/afni_matlab');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/NIFTI_tools');
Cfg.pathtodata='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/guessTheDot/Data/Analyses/MVPA/Searchlight/singleStim_linear_bet/Single_Stim_LDA/';
Cfg.output_path='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/guessTheDot/Data/Analyses/MVPA/Searchlight/singleStim_linear_bet/Single_Stim_LDA/Permutations/';
Cfg.perm_path='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/guessTheDot/Data/Analyses/MVPA/Searchlight/singleStim_linear_bet/Single_Stim_LDA/Permutations/individual_perm/';
% Cfg.pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Searchlight\singleStim_linear_bet\Single_Stim_LDA\';
% Cfg.output_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Searchlight\singleStim_linear_bet\Single_Stim_LDA\Permutations\';
% Cfg.perm_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\guessTheDot\Data\Analyses\MVPA\Searchlight\singleStim_linear_bet\Single_Stim_LDA\Permutations\individual_perm\';
Cfg.subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
Cfg.nRuns=5;
Cfg.condition=cond;
chance=1/6;
accuracyGroup=[];
a=path;
save('/home/flavio.ragni/mat_path.mat','a');
%% STEP 1: LOAD REAL DATASET
 for iSub=1:length(Cfg.subList)
     %Load searchlight
     ds=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_searchlight_singleStim_100_%s.nii.gz',Cfg.subList(iSub), Cfg.condition)))
     %Remove useless data
     ds=cosmo_remove_useless_data(ds);
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
    ds.sa.chunks=subject_i;
    % assign targets
    ds.sa.targets=1;
    % store results
    ds_intersect_cell{subject_i}=ds;
end
%Stack all subjects toghether
ds_all_real=cosmo_stack(ds_intersect_cell,1,'drop_nonunique');

%% STEP 2: CREATE GROUP DATASETS WITH PERMUTED DATA
niter = 100;
n_sub=length(Cfg.subList);
%Create a null matrix having 100 cells, corresponding to 100 group premuted 
%maps. Each group map should be created by the kth permuted map for each
%participant in variable a. Add also the original dataset, make the 
%intersection to keep only common voxels and then save intersecated
%permuted files in ds_intersect_cell_perm.
for k = 1: niter   
    a = [];
    for iSub = 1: length(Cfg.subList)
        ds_perm=[];
        %load file
        filename_perm = sprintf('sub%02d_%s_LDA_100_permuted_searchlight.mat',Cfg.subList(iSub),Cfg.condition);
        %Load perm_result for each subject. perm_result is a cellarray
        %size 1 x n_iter with permuted searchlight maps for subject iSub
        load([Cfg.output_path filesep filename_perm]);
        %Save permuted dataset as nifti
        cosmo_map2fmri(perm_result{k},fullfile(Cfg.perm_path, sprintf('sub%02d_%s_perm%d.nii.gz', Cfg.subList(iSub),Cfg.condition, k)));
        %And then reload it
        ds_perm = cosmo_fmri_dataset(fullfile(Cfg.perm_path, sprintf('sub%02d_%s_perm%d.nii.gz', Cfg.subList(iSub),Cfg.condition, k)));
        a{iSub}.samples = ds_perm.samples;
        a{iSub}.a = ds_perm.a;
        a{iSub}.sa = ds_perm.sa;
        a{iSub}.fa = ds_perm.fa;
    end
    % % permuted ds need to be the same size as real ds
    % LOAD REAL DS
    a{iSub+1}.samples = ds_all_real.samples;
    a{iSub+1}.a = ds_all_real.a;
    a{iSub+1}.sa = ds_all_real.sa;
    a{iSub+1}.fa = ds_all_real.fa;
    %trova i voxel che sono comuni in ogni soggetto ed elimina quelli che non sono comuni (una cella per soggetto)
    [idxs,permuted_group_ds{k}]=cosmo_mask_dim_intersect(a); % http://cosmomvpa.org/faq.html#make-an-intersection-mask-across-participants
    % delate real ds from permuted datasets
    permuted_group_ds{k}=permuted_group_ds{k}(1:n_sub,:);
    %Stack toghether all cells in ds_intersect_cell_perm and assign chunks
    %and targets
    permuted_group_ds{k} = cosmo_stack(permuted_group_ds{k},1,'drop_nonunique'); 
    %Assign chunks and targets
    permuted_group_ds{k}.sa.targets = repmat(1,n_sub,1);
    permuted_group_ds{k}.sa.chunks = repmat(1:n_sub,1,1)';
end
%% COMPUTE COSMO STATS WITH PERMUTED DATA    
nbrhood=cosmo_cluster_neighborhood(ds_all_real,'progress',false);
%load ds(group_ds) and ds_permuted (null_data) 
ds_z_permuted=cosmo_montecarlo_cluster_stat(ds_all_real,nbrhood,'niter',10000,  'h0_mean', chance,'progress',10, 'null', permuted_group_ds);

% % SAVE ACCURACY FILE 
save([Cfg.output_path filesep 'ds_z_permuted'],'ds_z_permuted'); 
% SAVE MAP
cosmo_map2fmri(ds_z_permuted,[fullfile(Cfg.output_path,sprintf('group_searchlight_singleStim_%s_N=%d_permutation_corrected.vmp', Cfg.condition, length(Cfg.subList)))]);
cosmo_map2fmri(ds_z_permuted,[fullfile(Cfg.output_path,sprintf('group_searchlight_singleStim_%s_N=%d_permutation_corrected.nii.gz', Cfg.condition, length(Cfg.subList)))]);

end