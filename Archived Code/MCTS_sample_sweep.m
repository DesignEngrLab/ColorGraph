%% Param Sweep MCTS

%% clean up
clear all;
clc

%% Define the Problem
%Define the design tree that we are searching
% We start from a seed of no color, this is indexed as 1 in matlab (0
% in graphsynth)

% There are two alternating choices, 1) Select a node to add to, and 2)
% Select the color of the node ROYGBV (indexed 1-6 for simplicity)

%We are going to add 10 nodes to the seed
Nodes=10;

%The graph recipe is an array or 3 columns, [Node Index, Added to, Color]
%and a number of columns equal to the number of Nodes, for 10 Nodes added
%we should end up with a 10x3 double, does not include seed properties
% We need to load the property set we want to use.
run RandoProps.m;


% Create Space for recipe rows=node index, columns=[origin,color]
%different from ColorGraph.m which has 3 columns
rainbow=zeros(Nodes,2);

%% Start param sweep of sample size
PERFORMANCE=zeros(9,5);

sample=1;
WaitBar = waitbar(0,'1/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(1,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

%sample=10;
%WaitBar = waitbar(0,'1/10 Please wait...');
%COUNTRUNS=0;
%tic
%run MCTS.m 
PERFORMANCE(2,:)=[10,4,1.3257,13.4563,301];
%%
sample=20;
WaitBar = waitbar(0,'2/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(3,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=40;
WaitBar = waitbar(0,'3/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(4,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=80;
WaitBar = waitbar(0,'4/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(5,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=160;
WaitBar = waitbar(0,'5/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(6,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=320;
WaitBar = waitbar(0,'6/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(7,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=640;
WaitBar = waitbar(0,'7/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(8,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
clearvars -except PERFORMANCE Nodes A B C 

sample=1000;
WaitBar = waitbar(0,'8/8 Please wait...');
COUNTRUNS=0;
tic
run MCTS.m 
PERFORMANCE(9,:)=[sample,N,length(nodeLabel)/TIMEELAPSED,COUNTRUNS/TIMEELAPSED,TIMEELAPSED];
