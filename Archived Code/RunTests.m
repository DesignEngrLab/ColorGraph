%% RunTests.m is a script that runs ColorGraph.m using multiple TSs
% Clear workspace
format compact;
clear all;
clc
% Set a bypass for the properties
TestConditions=true;
%% Define Properties of the Test
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
%Do we need to run multiple iterations for the class of tree search?
Iterations=20;
%Do we need muliple "offspring" in this class of tree search?
Brood=100;
%Store ALL THE DATA in a cell array rows by iteration/generation, columns
%contain {score, recipe} for each graph in generation
ScoreLog=cell(Iterations,Brood);
% BROOD by 1 doubleof the scores for a single generation
GenerationScores=zeros(Brood,1);
%% Select the tree search to run 'GATS', 'PureRandom', 'BFS', or 'MCTS'
TSselect='GATS';
run ColorGraph.m;