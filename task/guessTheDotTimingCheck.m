clear all
% pathToRes=fullfile('C:\Users\utente\Dropbox\fMRI Study\Scripts\res');
pathToRes=fullfile('D:\Experiments\Angelika\Flavio\guessTheDot\res');
iSub=99;
condition='PERCEPTION';%'IMAGERY'; %'PERCEPTION';
iRun=4;
%load(fullfile('C:\Users\flavio.ragni\Dropbox\guessTheDot\Scripts\res\', sprintf('guessTheDot_S%02d_R%02d_%s.mat',iSub, iRun, condition)));
load(fullfile('D:\Experiments\Angelika\Flavio\guessTheDot\res', sprintf('guessTheDot_S%02d_R%02d_%s.mat',iSub, iRun, condition)));
for k=1:length(ExpInfo.TrialInfo)
    check(k,1)=ExpInfo.TrialInfo(k).tStart
    check(k,2)=ExpInfo.TrialInfo(k).trial.tOnset
    check(k,3)=check(k,1)-check(k,2)
end

for j=2:length(ExpInfo.TrialInfo)
    check(j,4)=check(j,3)-check((j-1),3)
end