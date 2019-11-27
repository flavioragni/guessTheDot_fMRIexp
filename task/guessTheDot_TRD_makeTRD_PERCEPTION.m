function guessTheDot_TRD_makeTRD_PERCEPTION(trdName, iSub, side, plotDesign)
%
% this function creates nRuns trd files for the subject iSub (scalar)
%
% Info struct used in subfunction makeTrialDefs(Info)
% trd userdefcol: action actor context perspective
%
% Example call
% - guessTheDot_TRD_makeTRD_PERCEPTION('guessTheDot', 99)
% NOTE: you can also simply use guessTheDot_TRD_makeTRD_PERCEPTION for testing
%
if strcmp(which('ASF'), ''); addpath(genpath('C:\Users\flavio.ragni\Documents\MATLAB\asf\code')); end
if nargin<3; plotDesign=0;end
if nargin==0; trdName='guessTheDot'; iSub=99; plotDesign=1;end

Cfg.Screen.Resolution.hz    = 60;
isfmri                      = 1;
isJitter                    = 0;
writeSeparatedBlocks        = 0;

% initial parameters (to be chosen)

% independent variables
Info.categories         = [1, 2, 3];                                                   % Lowercase Letters | Objects | Simple Shapes
Info.catNames           = {'Lowercase Letters', 'Objects', 'Simple Shapes'};
Info.exempNames         = {{'e','n'}, {'Pen','Watch'}, {'Circle','Triangle'}};
Info.stimuli            = 1:6;
Info.conditions         = [0, 1];                                                         % Dot position
Info.conditionsNames    = {'Match', 'NoMatch'};

% design info
Info.nExpemplarXCat     = 2;                                                                    % number of exemplars per category (checkerboard 1, checkerboard 2, ..., grating 1, etc)
Info.nExemplars         = 2;%numel(Info.categories)*Info.nExpemplarXCat; %2                        % *Info.nStimuli; total number of exemplars
Info.nCombinations      = numel(Info.categories)*numel(Info.conditions)*Info.nExpemplarXCat;    % *Info.nStimuli; total number of exemplars
Info.nExemplarRep       = 2;                                                                    % n repetition of a specific exemplar per session (?)
Info.nRuns              = 5; % per session
Info.nBlocks            = numel(Info.categories)*2; % per run -->6 blocks,4 trials each (2match,2nomatch)*6 runs
%if mod(Info.nBlocks,Info.nRuns)~=0; error('The number of blocks must be multiple of the number of runs!! Change the number of runs (row 37)');end
Info.nTrialsXexp        = Info.nExemplarRep*Info.nCombinations*Info.nRuns;
Info.nTrialsXblock      = Info.nTrialsXexp/(Info.nBlocks*Info.nRuns);
Info.factorialStructure = [numel(Info.stimuli), numel(Info.categories), numel(Info.conditions)];

% timing info
Info.stimDurSec         = 1.5;            % presented only at the beginning of a block (In sec)
Info.maskDurSec         = 1.5;            % presented only at the beginning of a block (In sec)
Info.placeHoldDurSec    = 4;              % presented only at the beginning of a block (In sec)
Info.preStim            = 1;              % event1 (In sec)
Info.cueDurSec          = 0.5; %1/60;     % event2 (In sec)
Info.perDurSec          = 1.5;            % event3 (In sec)
Info.maskTaskDurSec     = 1.5;
Info.respDurSec         = 2;              % event4 (In sec)
Cfg.WaitSecs            = 0.5;
Info.trialDurSec        = Info.stimDurSec+Info.maskDurSec+Info.preStim+Info.cueDurSec+Info.perDurSec+Info.maskTaskDurSec+Info.respDurSec;

% response info
Info.matchResponse      = 1;             % 32 (space): PC; 49: MRI
Info.noMatchResponse    = 2;

% std info
Info.placeHold          = 1;            % std file position: SIA CENTRAL CROSS CHE PLACEHOLDERS
Info.cross              = 133;
Info.maskSTD            = 2;
Info.maskTask           = 3;
Info.doubleplaceHold    = 4:6;          % Placeholder doppio con stimoli (stimulus presentation)
Info.doubleplaceHoldB   = 143:145;
Info.stimulusPics       = 7:12;         % std position of stimulus pictures
Info.stdPos             = 13:132;       % std experimental stimuli: tutti possibili dot ma devi dividerli per stimolo
Info.maskStim           = 134:139;
Info.maskPlacehold      = 140:142;
Info.maskPlacehold      = 140:142;
Info.maskPlaceholdB     = 146:148;
Info.cueSTD             = [1 1];

% create the design matrix [row: all possible factorial combinations; col:factors (categoryVec, positionVec)]
categoryVec=repmat(1:numel(Info.categories), Info.nExpemplarXCat*numel(Info.conditions), 1);categoryVec=categoryVec(:);
exemplarXcatVec=repmat(1:Info.nExpemplarXCat, numel(Info.conditions), numel(Info.categories));exemplarXcatVec=exemplarXcatVec(:);
conditionsVec=repmat(1:numel(Info.conditions), 1, numel(Info.categories)*Info.nExpemplarXCat);conditionsVec=conditionsVec(:);
Info.design=[categoryVec, exemplarXcatVec, conditionsVec]; Info.design=Info.design-1;         % NOTE: we remove 1 from Info.design because of the ASF_encode function

% create the experimental Structure
categoryVec=repmat(1:numel(Info.categories), Info.nExpemplarXCat*Info.nExemplars, 2);categoryVec=categoryVec(:);
exemplarVec=repmat(1:Info.nExemplars, Info.nExemplars, Info.nBlocks);exemplarVec=exemplarVec(:);
conditionsVec=repmat(1:numel(Info.conditions), 1, Info.nBlocks*Info.nExemplars);conditionsVec=conditionsVec(:);
Info.expStructure=[categoryVec,exemplarVec, conditionsVec];Info.expStructure=Info.expStructure-1;

if plotDesign
    imagesc(Info.design);set(gca, 'xTick', 1:size(Info.design, 2), 'xTickLabel', {'Category', 'ExemplarXcat', 'Conditions'});
    figure; imagesc(Info.expStructure);set(gca, 'xTick', 1:size(Info.expStructure, 2), 'xTickLabel', {'Category', 'Exemplar', 'Conditions'});
    set(gca, 'yTick', linspace(20,940,24), 'yTickLabel', 1:24);
end

% load the std information to choose the correct dot image (it depends on the condition)
Cfg.std = guessTheDot_STD_importSTD('guessTheDot.std');

% add a flag (put 0 when the image has been used)
Cfg.std(:,3)={1};

%MAKE TRIALS (TrialDefinitions to be passed to writeTRD)
% create the sessions and the runs and write in trd files
%Define the SIDE CONFIGURATION - 1=OLD; 2=FLIPPED;
if side == 'A'
    sideVector=[1,2,1,2,1,2];
elseif side == 'B'
    sideVector=[2,1,2,1,2,1];
end
% write the trd files
for iRun=1:Info.nRuns
    % now create the blocks
    for iBlock=1:Info.nBlocks
        Info_block=Info;
        index=[1:4;5:8;9:12;13:16;17:20;21:24];
        Info_block.expStructure=Info_block.expStructure(index(iBlock,:),:);
        
        % define trials
        currentSide=sideVector(iRun);
        [TrialDefinitions{iBlock}, Cfg] = makeTrialDefs(Info_block, Cfg, iRun, currentSide); %#ok<AGROW>
        
        % RANDOMIZE TRIALS
        TrialDefinitions{iBlock}    = shuffleTrials(TrialDefinitions{iBlock}); %#ok<AGROW>
        
        % JITTER: TRIAL ONSET OF TRIAL N is ONSET OF TRIAL N-1 + SOME JITTER
        if isJitter
            TrialDefinitions = addJitter(TrialDefinitions{iBlock}, Cfg); %#ok<UNRCH>
        end
        % ADD BLANK TRIALS TO START AND END
        if currentSide==1
            Info_block.pageEv1              = Info.doubleplaceHold(Info_block.expStructure(1,1)+1);
            Info_block.pageMask             = Info.maskPlacehold(Info_block.expStructure(1,1)+1);
            TrialDefinitions{iBlock}        = addFirstLastTrials(Info_block, TrialDefinitions{iBlock}, Cfg);  %#ok<AGROW>
        elseif currentSide==2
            Info_block.pageEv1              = Info.doubleplaceHoldB(Info_block.expStructure(1,1)+1);
            Info_block.pageMask             = Info.maskPlaceholdB(Info_block.expStructure(1,1)+1);
            TrialDefinitions{iBlock}        = addFirstLastTrials(Info_block, TrialDefinitions{iBlock}, Cfg);
        end
        % WRITE OUT TRD TO DISK: trdName gli arriva gi` dalla funzione
        if writeSeparatedBlocks
            writeTRD(TrialDefinitions{iBlock}, Info, fullfile('.','trd', sprintf('%s_S%02d_R%02d_PERCEPTION.trd', trdName, iSub, iBlock))) %#ok<UNRCH>
        end
        
    end
    
    curBlockIdx=randperm(6);curBlockIdx=curBlockIdx(randperm(length(curBlockIdx)));
    TrialDefinitionsRUN = mergeTrialDef(TrialDefinitions(curBlockIdx));
    TrialDefinitionsRUNBlank(1) = TrialDefinitionsRUN(end);
    for iTrial = 1:length(TrialDefinitionsRUN)
        TrialDefinitionsRUNBlank(iTrial+1) = TrialDefinitionsRUN(iTrial); %#ok<AGROW>
    end
    %Set last blank trials to 600 instead of 595 (no time recovery)
    TrialDefinitionsRUNBlank(1).durations=600-(Cfg.WaitSecs*Cfg.Screen.Resolution.hz);
    TrialDefinitionsRUNBlank(end).durations=600-((Cfg.WaitSecs*2)*Cfg.Screen.Resolution.hz);
    % ADD ONSET (mainly for fmri)
    if isfmri
        TrialDefinitionsRUNBlank = addOnset(TrialDefinitionsRUNBlank, Cfg); %#ok<UNRCH>
    end
    writeTRD(TrialDefinitionsRUNBlank, Info, fullfile('.','trd', sprintf('%s_S%02d_R%02d_PERCEPTION.trd', trdName, iSub, iRun))) %#ok<UNRCH>
end

end

function [TrialDefinitions, Cfg] = makeTrialDefs(Info, Cfg,iRun, currentSide)
%function TrialDefinitions = makeTrialDefs(Info)
%prepares all the parameters that will be used for making the trd file
% Begin looping through factors to build trials
for iTrial = 1:size(Info.expStructure,1)
    %basic configuration
    
    % CODE
    thisTrial.code = ASF_encode(Info.expStructure(iTrial,:), Info.factorialStructure);
    
    % TONSET
    thisTrial.tOnset = 0;           % for fMRI
    
    % USER DEFINED
    %     thisTrial.userDefined = Info.expStructure(iTrial,:);
    if currentSide==1
        cueUserDefined=Info.expStructure(iTrial,2);
        thisTrial.userDefined = [Info.expStructure(iTrial,:) cueUserDefined];
    elseif currentSide==2 %if currentSide==2 invert 0 and 1 in userdefined(4)
        cueUserDefined=(Info.expStructure(iTrial,2)*-1)+1; %Moltiplico valore per -1 e aggiungo 1, così inverto valori
        thisTrial.userDefined = [Info.expStructure(iTrial,:) cueUserDefined];
    end
    
    % get some names to look for the correct images in the std
    curcatname  = Info.catNames{thisTrial.userDefined(1)+1};        % category names
    exempname   = Info.exempNames{thisTrial.userDefined(1)+1};
    exempname   = exempname{thisTrial.userDefined(2)+1};            % exemplar names (of the current category)
    cond        = thisTrial.userDefined(3);
    condname    = Info.conditionsNames{cond+1};                     % condition names ('Match' and 'NoMatch')
    
    % define a template according to the condition (to look into the std strings)
    switch cond
        case 0
            condname_template='[^No]Match*';
        case 1
            condname_template='.NoMatch*';
    end
    
    % find the indeces for the current categories
    idx_cat=~cellfun(@isempty, regexp(Cfg.std(:,1), curcatname, 'once'));
    
    % create a variable to store position of pics for the current category
    stim_img_idx=find(idx_cat&1); % find elements in std pertaining to the category
    stim_img=stim_img_idx(stim_img_idx>6&stim_img_idx<13)'; % store their position in the .trd in this index
    
    % find the indeces for the current condition
    idx_cond=~cellfun(@isempty, regexp(Cfg.std(:,2), condname_template, 'once'));
    
    % find the indeces for the current exemplars
    idx_exemp=~cellfun(@isempty, regexp(Cfg.std(:,2), strcat('^', exempname, condname), 'once'));
    
    % get the flags (initially all ones)
    idx_flag=cell2mat(Cfg.std(:,3));
    
    % get the indeces of the current exemplars to be used
    idx=find(idx_cat&idx_cond&idx_exemp&idx_flag);
    
    % just get one of them
    idx=idx(randperm(length(idx)));dotImg=idx(1);
    
    % put flag to zero (so this image is not used again)
    Cfg.std(dotImg,3)={0};
    
    %Select correct mask for the current trial
    if strcmp(exempname,'e')
        thisMask=134;
    elseif strcmp(exempname,'n')
        thisMask=135;
    elseif strcmp(exempname,'Pen')
        thisMask=136;
    elseif strcmp(exempname,'Watch')
        thisMask=137;
    elseif strcmp(exempname,'Circle')
        thisMask=138;
    elseif strcmp(exempname,'Triangle')
        thisMask=139;
    end
    
    %--------------------------
    % PAGES AND DURATIONS:
    %the only variable thing is the content of page 4
    %--------------------------
    %thisTrial.page      = [Info.placeHold Info.cueSTD(thisTrial.userDefined(3)+1) dotImg Info.placeHold];
    thisTrial.page      = [Info.cueSTD(thisTrial.userDefined(4)+1) stim_img(thisTrial.userDefined(2)+1) thisMask Info.placeHold dotImg Info.placeHold];
    thisTrial.durations = [Info.cueDurSec Info.perDurSec Info.maskTaskDurSec Info.placeHoldDurSec Info.respDurSec (Info.preStim-Cfg.WaitSecs)]*Cfg.Screen.Resolution.hz;
    
    %if your bitmaps in the std are in a smart order, it is simple
    %     thisTrial.page(3) = Info.blankPic;
    
    %--------------------------
    % START RESPONSE PAGE
    %--------------------------
    thisTrial.startRTonPage = 5;
    
    %--------------------------
    % END RESPONSE PAGE
    %--------------------------
    thisTrial.endRTonPage = 5;
    
    %--------------------------
    % CORRECT RESPONSE is about the catch trial
    %--------------------------
    
    if thisTrial.userDefined(3)==1
        thisTrial.correctResponse = Info.noMatchResponse;
    elseif thisTrial.userDefined(3)==0
        thisTrial.correctResponse = Info.matchResponse;
    end
    
    
    %--------------------------
    % COPY INTO ARRAY OF TRIAL DEFINITIONS
    %--------------------------
    TrialDefinitions(iTrial) = thisTrial;
    
end


end

function shuffledTrialDefinitions = shuffleTrials(TrialDefinitions)
% function shuffledTrialDefinitions = shuffleTrials(TrialDefinitions)
% This subfunction randomizes the trials. They randomization process can be
% simple or very sophisticated
nTrials = length(TrialDefinitions);

% This is a simple randomization
fprintf('trying to randomize the trials according to your constraints...');
shuffledTrialDefinitions = TrialDefinitions(randperm(nTrials));
cueType=vertcat(shuffledTrialDefinitions.userDefined);cueType=cueType(:,2);%cueType=cueType(:,3);%QUI POTREBBE ESSERE cueType(:,2) per selezionare stim e non match/nomatch
while any(diff(find(diff(cueType)==0))==1)
    shuffledTrialDefinitions = TrialDefinitions(randperm(nTrials));
    cueType=vertcat(shuffledTrialDefinitions.userDefined);cueType=cueType(:,2);%cueType=cueType(:,3);
end
fprintf('OK!\n');

end

function TrialDefinitions = addJitter(TrialDefinitions, Cfg)
% function TrialDefinitions = addJitter(TrialDefinitions, Cfg)
% This subfunction fills in the trial onset times based on some desired
% intertrial interval. We will use 1-2 seconds, in steps of 0.5 second
%
% Onset of trial n is duration of trial n-1 + the jitter value

nTrials = length(TrialDefinitions);
% Maybe pass this ITI vector into the function, too
jitvec = 1:0.5:2;

% Define the first onset, since it is currently NaN;
TrialDefinitions(1).tOnset = 0;
for iTrial = 2:nTrials
    %CALCULATE ONSET AND DURATION OF PREVIOUS TRIAL
    onsetPrevious = TrialDefinitions(iTrial-1).tOnset;
    durationPreviousFrames = sum(TrialDefinitions(iTrial-1).durations)-1; %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
    durationPreviousSecs = (1/Cfg.Screen.Resolution.hz)*durationPreviousFrames;
    
    % SHUFFLE JITTER VECTOR
    jitvecTemp = jitvec(randperm(length(jitvec)));
    % PICK THE FIRST ELEMENT AS JITTER
    jitter = jitvecTemp(1);
    
    %ASSIGN NEW ONSET TIME
    TrialDefinitions(iTrial).tOnset = onsetPrevious + durationPreviousSecs + jitter;
end

end

function TrialDefinitionsRUNBlank = addOnset(TrialDefinitionsRUNBlank, Cfg)
% function TrialDefinitions = addOnset(TrialDefinitions, Cfg)
% function TrialDefinitions = addOnset(TrialDefinitions, Cfg)
% This subfunction fills in the trial onset times based on some desired
% intertrial interval. We will use 1-2 seconds, in steps of 0.5 second
%
% Onset of trial n is duration of trial n-1 + the jitter value

nTrials = length(TrialDefinitionsRUNBlank); %length(TrialDefinitions);
% Maybe pass this ITI vector into the function, too
jitvec = 0;%1:0.5:2;

% Define the first onset, since it is currently NaN;
TrialDefinitionsRUNBlank(1).tOnset = 0; %TrialDefinitions(1).tOnset = 0;
for iTrial = 2:nTrials
    %CALCULATE ONSET AND DURATION OF PREVIOUS TRIAL
    onsetPrevious = TrialDefinitionsRUNBlank(iTrial-1).tOnset;
    durationPreviousFrames = sum(TrialDefinitionsRUNBlank(iTrial-1).durations); %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
    durationPreviousSecs = (1/Cfg.Screen.Resolution.hz)*durationPreviousFrames;
    
    %ASSIGN NEW ONSET TIME
    %     TrialDefinitions(iTrial).tOnset = onsetPrevious + durationPreviousSecs + jitter;
    TrialDefinitionsRUNBlank(iTrial).tOnset = onsetPrevious + durationPreviousSecs + Cfg.WaitSecs;
end
end

function TrialDefinitionsNew = addFirstLastTrials(Info, TrialDefinitions, Cfg)
% function TrialDefinitionsNew = addBlankTrials(Info, TrialDefinitions, Cfg)
% This subfunction attaches blank trials to the beginning and end of the
% TrialDefinitions structure

%------------------------
%GENERIC BLANK TRIAL
%------------------------
% CODE
firstTrial                  = TrialDefinitions(1);
firstTrial.code             = 0;
firstTrial.tOnset           = 0;
firstTrial.userDefined      = zeros(1, length(firstTrial.userDefined));
firstTrial.page             = [Info.pageEv1 Info.pageMask Info.placeHold]; %[Info.placeHold Info.pageEv1 Info.maskSTD]; %Version without placeholder (pre-stimulus interval)
firstTrial.durations        = [Info.stimDurSec Info.maskDurSec (Info.placeHold-Cfg.WaitSecs)]*Cfg.Screen.Resolution.hz; %[1 Info.stimDurSec Info.maskDurSec]*Cfg.Screen.Resolution.hz;
firstTrial.startRTonPage    = 4;
firstTrial.endRTonPage      = 4;
firstTrial.correctResponse  = 0;
% CONDITION NAME
%blankTrial.condName = 'BLANK';
%------------------------

% SHIFT ALL TRIAL ONSETS BY 16s (pass this value into function, too)
nTrials = length(TrialDefinitions);
for iTrial = 1:nTrials
    TrialDefinitions(iTrial).tOnset = TrialDefinitions(iTrial).tOnset;
end

%ADD BLANK TRIALS TO START AND END
TrialDefinitionsNew(1) = firstTrial;
for iTrial = 1:nTrials
    TrialDefinitionsNew(iTrial+1) = TrialDefinitions(iTrial); %#ok<AGROW>
end
lastTrial                   = firstTrial;
lastTrial.code             = -1;
lastTrial.page             = Info.placeHold;
lastTrial.durations        = (600 - ((Cfg.WaitSecs*3)*Cfg.Screen.Resolution.hz));
TrialDefinitionsNew(end+1)  = lastTrial;


% % Calculate trial onset time for the last blank trial
% onsetPrevious = TrialDefinitionsNew(end-1).tOnset;
% durationPreviousFrames = sum(TrialDefinitionsNew(end-1).durations)-1; %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
% durationPreviousSecs = 1/Cfg.Screen.Resolution.hz*durationPreviousFrames;
% TrialDefinitionsNew(end).tOnset = onsetPrevious + durationPreviousSecs + 15;
end

function TrialDefinitionsNew = addBlankTrials(Info, TrialDefinitions, Cfg)
% function TrialDefinitionsNew = addBlankTrials(Info, TrialDefinitions, Cfg)
% This subfunction attaches blank trials to the beginning and end of the
% TrialDefinitions structure

%------------------------
%GENERIC BLANK TRIAL
%------------------------
% CODE
blankTrial                  = TrialDefinitions(1);
blankTrial.code             = 0;
blankTrial.tOnset           = 0;
blankTrial.userDefined      = zeros(1, length(blankTrial.userDefined));
blankTrial.page             = [Info.placeHold Info.pageEv1 Info.pageMask];
blankTrial.durations        = [1 Info.stimDurSec (Info.maskDurSec-Cfg.WaitSecs)]*Cfg.Screen.Resolution.hz;
blankTrial.startRTonPage    = 4;
blankTrial.endRTonPage      = 4;
blankTrial.correctResponse  = 0;
% CONDITION NAME
%blankTrial.condName = 'BLANK';
%------------------------

% SHIFT ALL TRIAL ONSETS BY 16s (pass this value into function, too)
nTrials = length(TrialDefinitions);
for iTrial = 1:nTrials
    TrialDefinitions(iTrial).tOnset = TrialDefinitions(iTrial).tOnset + 15; % CHECK
end

%ADD BLANK TRIALS TO START AND END
TrialDefinitionsNew(1) = blankTrial;
for iTrial = 1:nTrials
    TrialDefinitionsNew(iTrial+1) = TrialDefinitions(iTrial); %#ok<AGROW>
end
blankTrial.code             = -1;
blankTrial.page             = Info.placeHold;
blankTrial.durations        = (600-Cfg.WaitSecs);%60;
TrialDefinitionsNew(end+1)  = blankTrial;

% % Calculate trial onset time for the last blank trial
% onsetPrevious = TrialDefinitionsNew(end-1).tOnset;
% durationPreviousFrames = sum(TrialDefinitionsNew(end-1).durations)-1; %SUBTRACT ONE FRAME SINCE LAST PAGE IS A DUMMY PAGE OF DURATION 1
% durationPreviousSecs = 1/Cfg.Screen.Resolution.hz*durationPreviousFrames;
% TrialDefinitionsNew(end).tOnset = onsetPrevious + durationPreviousSecs + 15;
end

function TrialDefinitions = mergeTrialDef(td_cell)
nBlock=numel(td_cell);

i=1;
for iBlock=1:nBlock
    for iTrial=1:length(td_cell{iBlock})
        TrialDefinitions(i)=td_cell{iBlock}(iTrial);i=i+1;
    end
end


end

function writeTRD(TrialDefinitions, Info, trdName)

% This subfunction writes out the trd-file to a text file

fprintf(1, 'WRITING %s\n', trdName);

%Open the text file for writing
fid = fopen(trdName, 'w');

%--------------------------------------------------------------------------
%FIRST LINE OF THE TRD FILE

%Write out the factoral structure onto the first line of the text file
fprintf(fid,'%d   ', Info.factorialStructure);

if isfield(Info, 'factorNames')
    %Write out the names of the factors onto the first line of the text file
    fprintf(fid,'%s   ', Info.factorNames{:});
end

if isfield(Info, 'leveNames')
    %Then write out the names of the levels of each factor
    fprintf(fid,'%s   ', Info.levelNames{:});
end

nTrials = length(TrialDefinitions);

%--------------------------------------------------------------------------
%Loop through TrialDefinitions
for i = 1:nTrials
    
    % Jump to the next line in the text file
    fprintf(fid,'\n');
    
    % CODE
    fprintf(fid, '%d  ', TrialDefinitions(i).code);
    
    % TONSET
    fprintf(fid, '%8.3f    ', TrialDefinitions(i).tOnset);
    
    %     % USER DEFINED COLUMNS CONTAIN STIMULUS PARAMETERS
    fprintf(fid, '%4d ', TrialDefinitions(i).userDefined(:));
    fprintf(fid, '  ');
    %
    %     fprintf(fid, '%4d ', TrialDefinitions(i).userDefined(6:10));
    %     fprintf(fid, '   ');
    
    % PAGES AND DURATIONS
    fprintf(fid, '%2d %3d   ', [TrialDefinitions(i).page(:), TrialDefinitions(i).durations(:)]');
    fprintf(fid, '  ');
    
    % RESPONSE PARAMS
    fprintf(fid, '%d  ', TrialDefinitions(i).startRTonPage,...
        TrialDefinitions(i).endRTonPage,...
        TrialDefinitions(i).correctResponse);
end
fclose(fid);
end