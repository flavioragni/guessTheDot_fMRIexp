% check if the trd files are correct
% - check if repetitions of conditions are balanced (same repetition number)
% - check if there are no more than two same cue in a row
% -
% TO BE COMPLETED!!
% 
% rt 20160616
clear all
iSub=2;
nRuns=6;
condition='PERCEPTION'; %'IMAGERY';
stimuli(:,1)=13:132;stimuli(:,2)=1;
figure;
for iRun=1:nRuns
    trdfile=fullfile('trd', sprintf('guessTheDot_S%02d_R%02d_%s.trd',iSub, iRun, condition));
    %Count repetition of each condition in this trd
    trdMat=guessTheDot_TRD_importfile(trdfile,condition);
    expTrialsFilter=~ismember(trdMat(:,1), [0 -1]);
    codevec=trdMat(expTrialsFilter,1);
    n=hist(codevec, unique(codevec));   
    display(n);
    if any(n~=2)
        error('WARNING:at least one condition does not have the correct number of repetition!');
        error(num2str(find(n~=2)));
    end
    % plot trial sequence to visualize if there are more than 2 same conditions in a row
    cuevec=trdMat(expTrialsFilter,5);
    subplot(2,3,iRun); bar(codevec); ylim([-1 16]);           
    if any(diff(find(diff(codevec)==0))==1)
        error('WARNING:more than 2 same cues in a row in run %02', iRun);
    end
    %Check blank trials (positioning and length)
    expTrialsFilterBlank=ismember(trdMat(:,1), [-1]);
    blankPos=[1:6:length(trdMat)]';
    if expTrialsFilterBlank(blankPos)==~1
        error('WARNING:at least one blank trial is in the wrong position!');
        error(num2str(find(n~=1)));
    end
    if trdMat(blankPos(1:end-1),7)==~595
        error('WARNING:at least one blank trial has the wrong length!');
        error(num2str(find(n~=595)));
    end
    if trdMat(blankPos(end),7)==~600
        error('WARNING:at least one blank trial has the wrong length!');
        error(num2str(find(n~=600)));
    end
    %Check placeholder trials
    expTrialsFilterPlacehold=ismember(trdMat(:,1), [0]);
    placeholdPos=[2:6:length(trdMat)]';
    if expTrialsFilterPlacehold(placeholdPos)==~1
        error('WARNING:at least one placeholder trial is in the wrong position!');
        error(num2str(find(n~=1)));
    end
    for k=1:length(placeholdPos)
        if trdMat(placeholdPos(k)+1,1)>= 1 & trdMat(placeholdPos(k)+1,1)<=4
            trdMat(placeholdPos(k),8)==4;
        elseif trdMat(placeholdPos(k)+1,1)>= 7 & trdMat(placeholdPos(k)+1,1)<=10
            trdMat(placeholdPos(k),8)==5;
        elseif trdMat(placeholdPos(k)+1,1)>= 13 & trdMat(placeholdPos(k)+1,1)<=16
            trdMat(placeholdPos(k),8)==6;
        else
            error('WARNING:at least one placeholder trial shows the wrong couple of images!');
        end
    end
    %Flag each stimulus used in the trd
    stimvec=trdMat(expTrialsFilter,:);
    for j=1:length(stimvec)
        switch condition
            case 'PERCEPTION'
                stimuli(stimuli(:,1)==stimvec(j,12),:)=0;
            case 'IMAGERY'
                stimuli(stimuli(:,1)==stimvec(j,10),:)=0;
        end
    end
end
%Check that all the stimuli were used in the trd
if any(stimuli(:,2)==1)
    error('WARNING:at least one stimulus was not used it this condition!');
end
sprintf('Everything is OK, good job!')