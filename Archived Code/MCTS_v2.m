%% most current is MCTS.m
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
%% clean up
clear all;
clc
%% Problem Definition
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
%% Create structure
% I tried several structures, but I think the best way to do this is to use
% a digraph and plot properties to track data and results
Source=1;
nodeLabel={'s'};
% Create score table to use as NodeTable in the digraph 
NodeTable = table([1;1;1;1;1;1;1],'VariableNames',{'Sum'});
% digraph with edge weights, the edge weights are number of times travels
decisionTree=digraph(Source,2:7,[1,1,1,1,1,1],NodeTable);
dTst=[0,0,1;table2array(decisionTree.Edges)];
NodeScore=[1;1]; %top column is cumulative score, bottom is times called
NodeQ=[NodeScore(1,Source)/NodeScore(2,Source)]; %weight of decision node
%% add first set of choices
% scores for color nodes
ciScores=[1,1,1,1,1,1;1,1,1,1,1,1];
NodeScore=[NodeScore,ciScores];
NodeQ=NodeScore(1,:)./NodeScore(2,:);
% labels
nodeLabel{1,Source+1}='r';
nodeLabel{1,Source+2}='o';
nodeLabel{1,Source+3}='y';
nodeLabel{1,Source+4}='g';
nodeLabel{1,Source+5}='b';
nodeLabel{1,Source+6}='v';
%decisionTree=addedge(decisionTree,Index,[2,3,4,5,6,7]);
TreeGraph=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel);
%% Create initial policy
% we know that the first location must be seed
% EXPAND
% we are expanding on a location node because it is the first time
% SIMULATE
% Sample for all colors
for Color=1:6
    Target=Source+Color;
    rainbow=[0,Color];
    for s=1:sample
        n=1;
        % SIMULATE
        while n<Nodes
            % Count
            n=n+1;
            % Make Random Graph
            run PureRandom_mcts.m;
        end
        % evaluate the graph
        run ColorScore_mcts.m
        % difference from target
        Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
        NodeScore(1,Target)=NodeScore(1,Target)+Qp;
        NodeScore(2,Target)=NodeScore(2,Target)+1;
        % BACK PROPAGATE
        while dTst(Target,1)>1
            Tsource=dTst(Target,1);
            NodeScore(1,Tsource)=NodeScore(1,Tsource)+Qp;
            NodeScore(2,Tsource)=NodeScore(2,Tsource)+1;
        end
    end
end
% update nodeweights
NodeQ=NodeScore(1,:)./NodeScore(2,:);
decisionTree.Edges.Weight=NodeQ(2:length(NodeQ))'
% tidy up
clear location color ADDED Qp GraphScore;
rainbow=zeros(Nodes,2);
%% Begin MCTS loop
%% SELECT
% use policy (greedy selection of best Q value)
%% Select-First location
% index node we are choosing in rainbow
n=1;
% add seed origin to rainbow
rainbow(n,1)=Source-1;
%% Start Select Policy Loop
while isempty(find(dTst(:,1)==Source))==0
    if isempty(find(dTst(:,1)==Source))==0 % Skip to Expand if Empty
        %% Select-Color
        % Options should be the first 6 nodes listed after source
        % the list should always be r o y g b v indexed as 1:6
        OptionI=find(dTst(:,1)==Source);
        OptionS=NodeQ(OptionI);
        Choice=find(min(OptionS)==OptionS);
        Source=OptionI(Choice);
        rainbow(n,2)=Choice;
    end
    if isempty(find(dTst(:,1)==Source))==0
        %% Select-Location
        % % Count options
        % count=1;
        % if nodeLabel{Source+count}~='r'&&nodeLabel{Source+count}~='o'&&...
        %         nodeLabel{Source+count}~='y'&&nodeLabel{Source+count}~='g'&&...
        %         nodeLabel{Source+count}~='b'&&nodeLabel{Source+count}~='v'
        %     count=count+1;
        % end
        % list options
        return
        OptionI=find(dTst(:,1)==Source);
        OptionS=NodeQ(OptionI);
        Choice=find(min(OptionS)==OptionS)+Source-1;
        Source=OptionI(Choice);
        % add to rainbow
        rainbow(n,1)=Choice-1;
    end
    % Count how many rows in rainbow we have defined
    n=n+1;
end
%% EXPAND
% Find current terminal node to expand 
% is it a location or a color
if nodeLabel{Source}=='r'||nodeLabel{Source}=='o'||...
        nodeLabel{Source}=='y'||nodeLabel{Source}=='g'||...
        nodeLabel{Source}=='b'||nodeLabel{Source}=='v'
    %Expand location options 
else 
    %Expand color options 
    % first add nodes 
    decisionTree=addedge(decisionTree,Source,length(nodeLabel)+1:...
        length(nodeLabel)+6);
end
%% SIMULATE/EVALUATE
%
%% BACK PROPAGATE SCORES
NodeQ=NodeScore(1,:)./NodeScore(2,:);
for w=1:length(NodeQ)
    highlight(TreeGraph,w,'MarkerSize',NodeQ(1,w));
end