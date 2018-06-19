%% So far so good
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
%% clean up
clear all;
clc
%WaitBar = waitbar(0,'Please wait...');

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

% How big should out sample off of every node be?
sample=10;

% Create Space for recipe rows=node index, columns=[origin,color]
%different from ColorGraph.m which has 3 columns
rainbow=zeros(Nodes,2);

%% Initiate the Directed Graph
% I tried several structures, but I think the best way to do this is to use
% a digraph and plot properties to track data and results

% We will keep track of the index of the Source Node S and target node T
S=1;

% We need to make labels for the nodels
nodeLabel={'n0'};
nodeLabel{1,S+1}='r';
nodeLabel{1,S+2}='o';
nodeLabel{1,S+3}='y';
nodeLabel{1,S+4}='g';
nodeLabel{1,S+5}='b';
nodeLabel{1,S+6}='v';

% We are going to need to keep track of the sum score values
NodeTable=table([1;0;0;0;0;0;0],'VariableNames',{'Sum'});

% We need to create a digraph with edge weights, of Sum
decisionTree=digraph(S,2:7,[1,1,1,1,1,1],NodeTable);
% Create an array with Q scores for each node
NodeQ=[decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight];

% % Generate a plot of the directed graph, but we don't need to until end
% TreeGraph=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel);

%% Create initial Policy
% We know that the first location has to be the seed
rainbow(1,1)=str2num(nodeLabel{S}(2:length(nodeLabel{S})));

% I have already expanded so I need to make a queue of Targets
% Create a queue of Targets
Tq=decisionTree.Edges.EndNodes(find(decisionTree.Edges.EndNodes(:,1)==S),2);

% We know that the Targets are colors so we can skip logic
for Color=1:6
    % Select Target node from the queue
    T=Tq(Color);
    
    % Record the Target node color
    rainbow(1,2)=Color;
    
    % We have filled in 1 row already so n starts at 2
    n=2;
    
    % Run Samples using pure random
    for s=1:sample
        % Simulate to generate rainbows
        while n<Nodes+1
            %Make a Random Graph
            run PureRandom_mcts.m
            %Count
            n=n+1;
        end
        % Reset n position
        n=2;
        
        % Evaluate the generated rainbow graph
        run ColorScore_mcts.m;
        % Distance in 3d from target coordinate
        Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
        
        % Update Scores sums in decisionTree.Nodes.Sum
        decisionTree.Nodes.Sum(T)=decisionTree.Nodes.Sum(T)+Qp;
        % Update edges travelled
        [nada,row]=intersect(decisionTree.Edges.EndNodes,[S,T],'rows');
        decisionTree.Edges.Weight(row)=decisionTree.Edges.Weight(row)+1;
        
        % Now we can follow this policy in the next section
        S=1; % Make sure that S is one before starting Select
    end
end

%% MCTS LOOP START - This is where the primary loop begins
%%% while PolicyDepth<Nodes

%% SELECT - Select nodes as informed by the current policy

% We are starting from the beginning so reset n to 1
n=1;
rainbow=zeros(Nodes,2);
rainbow(1,1)=str2num(nodeLabel{S}(2:length(nodeLabel{S})));

% Is the current source node a location or a color?
% if Source Node Label starts with "n" we need to pick the next color
if nodeLabel{S}(1)=='n'
    % Make a queue of possible target nodes
    Tq=decisionTree.Edges.EndNodes(find(decisionTree.Edges.EndNodes(:,1)==S),2);
    
    % Double check there are six options
    if length(Tq)~= 6
        errbox = msgbox('at line 116 length(Tq)~=6');
        return
    end
    
    % Using the Tq indexes determine choice with best Q value
    % Update Q scores for each node
    NodeQ=[decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
        decisionTree.Edges.Weight];
    % Select the Q scores for Options in the queue
    Options=NodeQ(Tq-1);
    % Choose the best option
    Choice=find(min(Options)==Options);
    
    % Record Position in Rainbow
    rainbow(n,2)=Choice;
    % Update Source node 
    S=Tq(Choice);
else % if not "n" then we must be picking a position
    % Make a queue of possible Target nodes
    Tq=decisionTree.Edges.EndNodes(find(decisionTree.Edges.EndNodes(:,1)==S),2);
    
    % Double check that the number of options=n
    if length(Tq)~= 6
        errbox = msgbox('at line 146 length(Tq)~=n');
        return
    end
    
    % Using the Tq indexes determine choice with the best Q value
    NodeQ=[decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
        decisionTree.Edges.Weight];
    % Select the Q scores for Options in the queue
    Options=NodeQ(Tq-1);
    % Choose the best option
    Choice=find(min(Options)==Options);
    
    % Record Position in Rainbow, indexed from 0 to Nodes 
    rainbow(n,1)=Choice-1;
    % Update Source node 
    S=Tq(Choice);
end