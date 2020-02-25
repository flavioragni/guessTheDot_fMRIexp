function GTD_searchlight_runpermutations_singleStim_CLUSTER(subNum, cond)
%% MVPA test script
%Goal: import dataset from a single run, assign chunks, targets and labels.
Cfg=struct;
addpath(genpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa'));
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/NIfTI_20140122');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/NeuroElf_v11_7101');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/surfing-master');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/externals/afni_matlab');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/NIFTI_tools');
Cfg.pathtodata='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/guessTheDot/Data/Analyses/MVPA/singleStim_linearReg_Bet/Single_stim/';
Cfg.output_path='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/guessTheDot/Data/Analyses/MVPA/Searchlight/singleStim_linear_bet/Single_Stim_LDA/Permutations/';
Cfg.nRuns=5;
Cfg.condition=cond;
chance=1/6;
accuracyGroup=[];
a=path;
save('/home/flavio.ragni/mat_path.mat','a');
%% N-fold cross-validation
%[ds]=GTD_makeds_searchlight_CLUSTER(subNum,Cfg);
for iRun=1:Cfg.nRuns
    switch Cfg.condition
        case 'IMAGERY'
            %     pathtosub=fullfile(Cfg.pathtodata,'MVPA',sprintf('SUB%02d',subNum));
            pathtosub=fullfile(Cfg.pathtodata,sprintf('SUB%02d',subNum));
            sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subNum, iRun, Cfg.condition)
            %Create temporary variables for each cope image of interest
            temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subNum,iRun,Cfg.condition)));
            temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subNum,iRun,Cfg.condition)));
            temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({temp_e1,temp_e2,temp_n1,temp_n2,temp_pen1,temp_pen2;temp_watch1,temp_watch2,temp_circle1,temp_circle2,temp_triangle1,temp_triangle2})'])
            temp_e1=[];temp_e2=[];temp_n1=[];temp_n2=[];temp_pen1=[];temp_pen2=[];temp_watch1=[];temp_watch2=[];temp_circle1=[];temp_circle2=[];temp_triangle1=[];temp_triangle2=[];
            
        case 'PERCEPTION'
            %     pathtosub=fullfile(Cfg.pathtodata,'MVPA',sprintf('SUB%02d',subNum));
            pathtosub=fullfile(Cfg.pathtodata,sprintf('SUB%02d',subNum));
            sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subNum, iRun, Cfg.condition)
            %Create temporary variables for each cope image of interest
            temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subNum,iRun,Cfg.condition)));
            temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subNum,iRun,Cfg.condition)));
            temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subNum,iRun, Cfg.condition)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({temp_e1,temp_e2,temp_n1,temp_n2,temp_pen1,temp_pen2;temp_watch1,temp_watch2,temp_circle1,temp_circle2,temp_triangle1,temp_triangle2})'])
            temp_e1=[];temp_e2=[];temp_n1=[];temp_n2=[];temp_pen1=[];temp_pen2=[];temp_watch1=[];temp_watch2=[];temp_circle1=[];temp_circle2=[];temp_triangle1=[];temp_triangle2=[];
            
        case 'CROSS'
            %BLOCK ANALYSIS - t-stat images aligned MNI
            %Load PERCEPTION t-stats first and then IMAGERY - chunks: 1=PERCEPTION,
            %2 = IMAGERY
            pathtosub=fullfile(Cfg.pathtodata,sprintf('SUB%02d',subNum));
            %Create temporary variables for PERCEPTION CONDITION
            modality='PERCEPTION';
            sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subNum, iRun, modality)
            PER_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subNum,iRun,modality)));
            PER_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subNum,iRun,modality)));
            PER_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subNum,iRun, modality)));
            PER_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subNum,iRun, modality)));
            %Create temporary variables for IMAGERY CONDITION
            modality='IMAGERY';
            sprintf('Processing tstat for SUB%02d, RUN%02d, %s',subNum, iRun, modality)
            IMG_temp_e1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat1_alignedMNI.nii.gz',subNum,iRun,modality)));
            IMG_temp_e2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat2_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_n1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat3_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_n2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat4_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_pen1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat5_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_pen2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat6_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_watch1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat7_alignedMNI.nii.gz',subNum,iRun,modality)));
            IMG_temp_watch2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat8_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_circle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat9_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_circle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat10_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_triangle1=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat11_alignedMNI.nii.gz',subNum,iRun, modality)));
            IMG_temp_triangle2=cosmo_fmri_dataset(fullfile(pathtosub,sprintf('SUB%02d_RUN%02d_%s_MVPA_singleStim_tstat12_alignedMNI.nii.gz',subNum,iRun, modality)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({PER_temp_e1,PER_temp_e2,PER_temp_n1,PER_temp_n2,PER_temp_pen1,PER_temp_pen2,PER_temp_watch1,PER_temp_watch2,PER_temp_circle1,PER_temp_circle2,PER_temp_triangle1,PER_temp_triangle2,IMG_temp_e1,IMG_temp_e2,IMG_temp_n1,IMG_temp_n2,IMG_temp_pen1,IMG_temp_pen2,IMG_temp_watch1,IMG_temp_watch2,IMG_temp_circle1,IMG_temp_circle2,IMG_temp_triangle1,IMG_temp_triangle2})'])
            PER_temp_e1=[];PER_temp_e2=[];PER_temp_n1=[];PER_temp_n2=[];PER_temp_pen1=[];PER_temp_pen2=[];PER_temp_watch1=[];PER_temp_watch2=[];PER_temp_circle1=[];PER_temp_circle2=[];PER_temp_triangle1=[];PER_temp_triangle2=[];
            IMG_temp_e1=[];IMG_temp_e2=[];IMG_temp_n1=[];IMG_temp_n2=[];IMG_temp_pen1=[];IMG_temp_pen2=[];IMG_temp_watch1=[];IMG_temp_watch2=[];IMG_temp_circle1=[];IMG_temp_circle2=[];IMG_temp_triangle1=[];IMG_temp_triangle2=[];
    end
end

switch Cfg.condition
    case 'IMAGERY'
        %Stack toghether ALL 5 RUNS
        ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Define tatgets, chunks and labels
        targets=repmat((1:6)',1,2)';
        targets=targets(:);
        targets=repmat(targets,5,1);
        chunks=zeros(30,1);
        for i=1:5
            idxs=(i-1)*12+(1:12);
            chunks(idxs)=i;
        end
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;

    case 'PERCEPTION'
        %Stack toghether ALL 5 RUNS
        ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Define tatgets, chunks and labels
        targets=repmat((1:6)',1,2)';
        targets=targets(:);
        targets=repmat(targets,5,1);
        chunks=zeros(30,1);
        for i=1:5
            idxs=(i-1)*12+(1:12);
            chunks(idxs)=i;
        end
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        
    case 'CROSS'
        %Stack toghether ALL 5 RUNS
        ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5});
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Define tatgets, chunks and labels
        targets=repmat((1:6)',1,2)';
        targets=targets(:);
        targets=repmat(targets,10,1);
        chunks=zeros(120,1);
        chunks=[repmat(1,1,24),repmat(2,1,24),repmat(3,1,24),repmat(4,1,24),repmat(5,1,24)]';
        %Set modality for crossdecoding: 1=PER,2=IMG.
        modality=zeros(120,1);
        modality=[repmat(1,1,12),repmat(2,1,12)];
        modality=repmat(modality,1,5)';
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.modality=modality;
end
ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];

%% DEFINE CONDITIONS, TARGETS AND CHUNKS 

switch Cfg.condition
    case 'IMAGERY'
        % Set partition scheme
        p = cosmo_nfold_partitioner(ds);
        
    case 'PERCEPTION'
        % Set partition scheme
        p = cosmo_nfold_partitioner(ds);
        
    case 'CROSS'
        %Set partition scheme
        %test_modality=2; %Test on imagery, train on perception
        %test_modality=1; %Test on perception, train on imagery
        p = cosmo_nchoosek_partitioner(ds,1,'modality',[]);%Test in both directions
end
%% Permutations
%Define iterations
niter=100;
% BALANCE PARTITIONS
% make standard balancing
p=cosmo_balance_partitions(p,ds); 
% DEFINE nbrhood
nvoxels_per_searchlight=100;
nbrhood=cosmo_spherical_neighborhood(ds,'count', nvoxels_per_searchlight, 'progress',false); %  computes neighbors for a spherical searchlight   'radius',radius,

%Prepare for permutations
%Make a copy of original dataset
ds0=ds;
%For niter iterations, reshuffle the labels and run the searchlight
for k=1:niter
    for x = 1: length(p.test_indices)
        data = ds0.sa.targets(p.test_indices{x});
        ds0.sa.targets(p.test_indices{x}) = data(randperm(size(data,1)),:);
    end
    args=struct();
    args.classifier = @cosmo_classify_lda;
    args.partitions = p;
    measure=@cosmo_crossvalidation_measure;
    warning off
    %Run searchlight
    perm_result{k}=cosmo_searchlight(ds0,nbrhood,measure,args);
end
permuted_searchlight_name = [Cfg.output_path filesep sprintf('sub%02d_%s_LDA_%d_permuted_searchlight.mat',subNum,Cfg.condition,nvoxels_per_searchlight)];
save(permuted_searchlight_name,'perm_result');
