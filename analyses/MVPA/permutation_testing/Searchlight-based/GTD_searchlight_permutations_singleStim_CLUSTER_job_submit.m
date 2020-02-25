%% A Sort of preamble
clear all;
matlab_version = sscanf(version('-release'),'%d%s');
addpath(genpath('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\LnifClusterFunctions'));
lnif_cluster = getLnifCluster('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\matlab_pe','/home/flavio.ragni/matlab_pe');
job = lnif_cluster.createJob('Name','cosmo_searchlight');
job.AttachedFiles = {'GTD_runpermutations_singleStim_CLUSTER.m'};
%% Assign tasks using your function
subList=[7,9,12,14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,31,33,34];
condition={'PERCEPTION','IMAGERY','CROSS'};
for iCond=1:length(condition)
    for iSub=1:length(subList)
        job.createTask(@GTD_searchlight_runpermutations_singleStim_CLUSTER, 0,{subList(iSub), condition{iCond}});
    end
end
%% Run the analysis
job.Tasks
job.submit();
%job.wait();
%job.delete();
