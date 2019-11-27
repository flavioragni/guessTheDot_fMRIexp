function ExpInfo = guessTheDot_run(subNum, runlist, condition, isdebug)
% Example call ExpInfo = guessTheDot_run(99, 1, 'PERCEPTION', 1) % with debug
% Example call ExpInfo = guessTheDot_run(99, 2, 'IMAGERY', 0) % no debug
  
clear Screen

pathToHere='D:\Experiments\Angelika\Flavio\guessTheDot';
pathToThisProject=fullfile(pathToHere);
pathToAudioCues =fullfile(pathToThisProject, 'Audio');

Cfg.environment = 'MR'; %'RT';
%addpath(genpath(fullfile('D:\Experiments\Angelika\ASFv50')));
addpath(genpath(fullfile('D:\Experiments\Angelika\ASFv52'))); 

if strcmp(which('Screen'), '');
    addpath(genpath(fullfile(pathToPsychtoolbox, 'Psychtoolbox')));
    addpath(fullfile(pathToPsyc1htoolbox, 'Psychtoolbox', 'PsychBasic', 'MatlabWindowsFilesR2007a'))
end

Cfg.userDefinedSTMcolumns       = 4;
Cfg.userSuppliedTrialFunction   = @guessTheDot_showTrial;
Cfg.responseTerminatesTrial     = 0; %1; %Con 0 trial non termina con button press

Cfg.Sound.soundMethod           = 'psychportaudio';
Cfg.Sound.nPlaybackDevices      = 3;
Cfg.Sound.iDevice               = 2;
Cfg.Sound.cueNames              = {'Left.wav', 'Right.wav'};%{'Left.wav', 'Right.wav'}; %Cue added for control
for i=1:2
    Cfg.Sound.wavedata{i}          = audioread(fullfile(pathToAudioCues, Cfg.Sound.cueNames{i}));
    Cfg.Sound.wavedata{i}          = Cfg.Sound.wavedata{i}';
end

Cfg.Screen.color                = [125 125 125]; %use grey background
Cfg.expName                     = 'guessTheDot';
if isdebug
    PsychDebugWindowConfiguration;  % to desable: clear Screen
end
STDfile                         = 'guessTheDot.std';

switch Cfg.environment
    case 'RT'
        Cfg.Screen.skipSyncTests = 1;
        Cfg.Screen.Resolution.width = 1920;%1336;%1024;%1920;
        Cfg.Screen.Resolution.height = 1080;%798;%768;%1080;
        Cfg.Screen.Resolution.pixelSize = 32;
        Cfg.Screen.Resolution.hz = 60;
        Cfg.responseDevice = 'KEYBOARD';
        
    case 'MR'
        Cfg.useTrialOnsetTimes = 1;
        %----------------------------------------------------
        % %FOR MR EXPERIMENT
        Cfg.Screen.Resolution.width = 1280;
        Cfg.Screen.Resolution.height = 1024;
        Cfg.Screen.Resolution.pixelSize = 32;
        Cfg.Screen.refreshRateHz = 60;
        Cfg.Screen.distanceCm = 135;
        Cfg.Screen.xDimCm = 44.7;
        Cfg.Screen.yDimCm = 33.6;
        Cfg.synchToScanner = 0;
        Cfg.synchToScannerPort = 'SERIAL';
        Cfg.responseDevice = 'LUMINASERIAL';
        Cfg.responseType = 'buttonDown';
        %----------------------------------------------------
end

% Run ASF
for iRun=1:length(runlist)
    % Name of experiment for output filename
    EXPfile = fullfile('.','res', sprintf('%s_S%02d_R%02d_%s', Cfg.expName ,subNum, runlist(iRun), condition));
    TRDfile = fullfile('.','trd', sprintf('%s_S%02d_R%02d_%s.trd', Cfg.expName ,subNum, runlist(iRun), condition));
    tic;
    ExpInfo = ASF(STDfile, TRDfile, EXPfile, Cfg);
    t=toc;    
    display(t)
    if iRun < length(runlist)
        fprintf('You have just done run %d (out of %d\n)', iRun, length(runlist));
        fprintf('To start the next run, press a button\n');
        pause
    end
end
end
