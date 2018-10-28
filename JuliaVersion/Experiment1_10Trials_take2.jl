%% This is the experiment for the Color Graph conference paper

%% Clean up the work space
clear all
format compact
clc
WaitBar = waitbar(0,'Trials are running, please wait <3'); 
WAITBARCOUNT=0;
datetime('now')
%% Load Trial properties for 10 trials
load('TrialProperties10.mat');
% We are running 10 trials
TRIALS=10;
NodeSet=[3,5,10];
TIMEOUT=15;

% Turn on Test Conditions 
TestConditions=true; 

%% Make a place to store results
% Store {Results of All Trials,{Best Rainbow}}
ResultData=cell(1,2);
% Holds the results of all trials for a test of a method
% [Best Score, TIMEELAPSED, evalRuns, evalRuns/TIMEELAPSED, Policy Depth or Iteration till convergence (as applicable)]
% COUNTRUNS is how many times graph eval was called
ResultTrial=zeros(TRIALS,6);
% Stores the best Color Graph design for each trial in a cell
RainbowResults=cell(TRIALS,2);
% HOLDS ALL OF THE RESULTS
RESULTS=cell(3,5);

% Nest it all to preallocate memory
ResultData{1,1}=ResultTrial;
ResultData{1,2}=RainbowResults;

for f=1:5
    RESULTS{1,f}=ResultData;
    RESULTS{2,f}=ResultData;
    RESULTS{3,f}=ResultData;
end

%% The first test is to color graph of 3 nodes
for ndset=2:3
    Nodes=NodeSet(ndset);
    %% Run test for each algorithm
    for algorithm=1:5
        algSet={'GATS','GA-No Cross','MCTS','ACO','PureRandom'};
        TSselect=algSet(algorithm);
        %% Run GATS test
        for Trial=1:TRIALS
            if ndset==2&&algorithm<=2
                break
            end
            disp(strcat(num2str(Nodes),'-Nodes_',TSselect,'_Trial:',num2str(Trial)));
            % clean up design space
            clear rainbow
            %     clearvars -except algorithm ndset RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
            
            % pull out properties
            A=TrialProp{Trial,1};
            B=TrialProp{Trial,2};
            C=TrialProp{Trial,3};
            % run Trial version of method
            run ColorGraph_Experiment.m
            % Record results
            if strcmp(TSselect,'MCTS')||strcmp(TSselect,'ACO')||strcmp(TSselect,'MCTS-Best Score')
                % what to do if free looping;
                % Record trial results
                ResultTrial(Trial,:)=[Qp,timeelapsed,evalRuns,evalRuns/timeelapsed,N,COMPLETED];
                % Record best graph design
                RainbowResults{Trial,1}=rainbow;
                RainbowResults{Trial,1}=BESTrainbow;
                %Update sanity bar
                WAITBARCOUNT=WAITBARCOUNT+1;
                waitbar(WAITBARCOUNT/60);
            else
                % what to do if uses ColorGraph loop
                for g=1:Iterations
                    MinScore(1,g)=min(ScoreLog{g,1}{1,1});
                end
                ResultTrial(Trial,:)=[MinScore(1,Iterations),timeelapsed,evalRuns,...
                    evalRuns/timeelapsed,min(find(MinScore(1,:)==MinScore(1,Iterations))),COMPLETED];
                % Record best graph design
                RainbowResults{Trial,1}=ScoreLog{Iterations, min(find(MinScore(1,Iterations)==ScoreLog{Iterations,1}{1}))+1}{1};
                
                %Update sanity bar
                WAITBARCOUNT=WAITBARCOUNT+1;
                waitbar(WAITBARCOUNT/60);
            end
        end
        % Store results from trials
        ResultData{1,1}=ResultTrial;
        ResultData{1,2}=RainbowResults;
        % Store Experiment results
        RESULTS{ndset,algorithm}=ResultData;
        % Save intermediate results
        save('Experiment1_10Trials_IDETC_Take2.mat','RESULTS');
    end
end
YAY=msgbox('You did it QT!!! <3');