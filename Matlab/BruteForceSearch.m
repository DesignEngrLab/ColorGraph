%% MCTS.m is a monte carlos tree search that runs in ColorGraph.m
% This version of MCTS keeps track of the best found so far and reports
% that at the end 
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
% if policy is incomplete, it does a random rollout for the remaining nodes
%% clean up
startTime=clock
evalRuns=0;
tic
%% Define the Problem
%Define the design tree that we are searching
% We start from a seed of no color, this is indexed as 1 in matlab (0
% in graphsynth)

% There are two alternating choices, 1) Select a node to add to, and 2)
% Select the color of the node ROYGBV (indexed 1-6 for simplicity)

% How big should out sample off of every node be?
sample=100;

% Create Space for recipe rows=node index, columns=[origin,color]
%different from ColorGraph.m which has 3 columns
rainbow=zeros(Nodes,3);
BESTrainbow=[];
BESTscore=[];
currentTime=clock;
TIMEELAPSED=currentTime-startTime;
    
    %% SELECT - Select nodes as informed by the current policy
while TIMEELAPSED(5)*60+TIMEELAPSED(6)<=TIMEOUT*60
    % We are starting from the beginning so reset n to 1
    n=1;
    CHECK=1;
    S=1;
    rainbow=zeros(Nodes,3);
    rainbow(:,1)=[1:Nodes]';
    
    while n<Nodes+1
        %Make a Random Graph
        run PureRandom.m
        %Count
        n=n+1;
    end
    
    % Evaluate the generated rainbow graph
    %run ColorScore_mcts.m;
    run ColorScore.m;
    
    % Distance in 3d from target coordinate
    Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
    % Is it the best score?
    [BESTscore,BESTrainbow]=isbest(Qp,rainbow,BESTscore,BESTrainbow);
    
    % TRACK TIME PER RUN
    currentTime=clock;
    TIMEELAPSED=currentTime-startTime;
    if toc>60
        disp(strcat('Time Elapsed: ',...
            num2str(TIMEELAPSED(3)),'-days, ','_',...
            num2str(TIMEELAPSED(4)),'-hours, ','_',...
            num2str(TIMEELAPSED(5)),'-mins, ','_',...
            num2str(TIMEELAPSED(6)),'-secs, ','_'))
        tic
    end
end
%Take best
rainbow=BESTrainbow;
Qp=BESTscore;

%% Best score function
function [BESTscore,BESTrainbow]=isbest(Qp,rainbow,BESTscore,BESTrainbow)
% Check if the best score
if isempty(BESTrainbow)||BESTscore>Qp
    BESTscore=Qp;
    BESTrainbow=rainbow;
%     disp(strcat('BS: ',num2str(BESTscore),' - ',' Qp: ',num2str(Qp)))
%     disp(rainbow);
end
end