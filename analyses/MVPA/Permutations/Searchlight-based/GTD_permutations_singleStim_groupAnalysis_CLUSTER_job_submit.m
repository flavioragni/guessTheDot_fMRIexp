%% A Sort of preamble
clear all;
matlab_version = sscanf(version('-release'),'%d%s');
addpath(genpath('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\LnifClusterFunctions'));
lnif_cluster = getLnifCluster('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\matlab_pe','/home/flavio.ragni/matlab_pe');
job = lnif_cluster.createJob('Name','cosmo_searchlight');
job.AttachedFiles = {'GTD_permutations_singleStim_groupAnalysis_CLUSTER.m'};
%% Assign tasks using your function
condition={'IMAGERY', 'PERCEPTION', 'CROSS'};
for iCond=1:length(condition)
    job.createTask(@GTD_permutations_singleStim_groupAnalysis_CLUSTER, 0,{condition{iCond}});
end
%% Run the analysis
job.Tasks
job.submit();
%job.wait();
%job.delete();
