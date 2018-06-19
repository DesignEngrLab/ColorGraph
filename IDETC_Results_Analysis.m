%{ 
Perform analysis on the final results of the experiments for idetc
%}
%% Set up 
clc
algSet={'GATS','GA-No Cross','MCTS','ACO','PureRandom'};

%% find the mean scores
MeanScores=zeros(3,5);
for ts=1:5
    for n=1:3
        MeanScores(n,ts)=mean(RESULTS{n,ts}{1,1}(:,1));
    end
end
disp('muS')
disp(MeanScores)
%% Find the std of scores 
stdScores=zeros(3,5);
for ts=1:5
    for n=1:3
        stdScores(n,ts)=std(RESULTS{n,ts}{1,1}(:,1));
    end
end
disp('sigS')
disp(stdScores)
%% find the mean times 
MeanTimes=zeros(3,5);
for ts=1:5
    for n=1:3
        MeanTimes(n,ts)=mean(RESULTS{n,ts}{1,1}(:,2));
    end
end
disp('muT')
disp(MeanTimes)
%% Find the std of times 
stdTimes=zeros(3,5);
for ts=1:5
    for n=1:3
        stdTimes(n,ts)=std(RESULTS{n,ts}{1,1}(:,2));
    end
end
disp('sigT')
disp(stdTimes)
%% find the mean times 
MeanEvals=zeros(3,5);
for ts=1:5
    for n=1:3
        MeanEvals(n,ts)=mean(RESULTS{n,ts}{1,1}(:,3));
    end
end
disp('muE')
disp(MeanEvals)
%% Find the std of times 
stdEvals=zeros(3,5);
for ts=1:5
    for n=1:3
        stdEvals(n,ts)=std(RESULTS{n,ts}{1,1}(:,3));
    end
end
disp('sigE')
disp(stdEvals)
%% Find the std of times 
runstill=zeros(3,5);
for ts=1:5
    for n=1:3
        runstill(n,ts)=std(RESULTS{n,ts}{1,1}(:,5));
    end
end
disp('runs')
disp(runstill)

%% Find total eval time 
TotalTime=zeros(3,5);
for ts=1:5
    for n=1:3
        TotalTime(n,ts)=sum(RESULTS{n,ts}{1,1}(:,2));
    end
end
TotalTime=sum(sum(TotalTime));
disp('TotalTime')
disp(strcat(num2str(floor(TotalTime/60/60)),'hours_',...
    num2str(floor(TotalTime/60)-floor(TotalTime/60/60)*60),'min_',...
    num2str(TotalTime-(floor(TotalTime/60)-floor(TotalTime/60/60)*60)*60),'sec'))
