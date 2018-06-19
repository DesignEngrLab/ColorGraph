%% MCTS.m is a monte carlos tree search that runs in ColorGraph.m
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
%% clean up
%%%clear all;
clc
WaitBar = waitbar(0,'Please wait...');
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
nodeLabel={'n0'};
% Create score table to use as NodeTable in the digraph
NodeTable = table([1;1;1;1;1;1;1],'VariableNames',{'Sum'});
% digraph with edge weights, the edge weights are number of times travels
decisionTree=digraph(Source,2:7,[1,1,1,1,1,1],NodeTable);
dTst=[0,1,1;table2array(decisionTree.Edges)];
NodeQ=[1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight]; %weight of decision node

%% add first set of choices
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
    Target=Source+Color; %this line is probably not quite right
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
        % Update Scores
        decisionTree.Nodes.Sum(Target)=decisionTree.Nodes.Sum(Target)+Qp;
        % Update edges travelled
        [dontcare,row]=intersect(dTst(:,1:2),[Source,Target],'rows');
        decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
        % update DTST
        dTst=[0,1,1;table2array(decisionTree.Edges)];
        % BACK PROPAGATE
        Ttarget=Target;
        while dTst(Ttarget,1)>1
            [dontcare,row]=intersect(dTst(:,2),Ttarget,'rows')
            Tsource=dTst(row,1);
            % Update Scores
            decisionTree.Nodes.Sum(Ttarget)=decisionTree.Nodes.Sum(Ttarget)+Qp;
            % Update edges travelled
            [dontcare,row]=intersect(dTst(:,1:2),[Tsource,Ttarget],'rows');
            decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
            % Step back
            [dontcare,row]=intersect(dTst(:,2),Tsource,'rows')
            Ttarget=dTst(row,1);
        end
    end
end
% update nodeweights
NodeQ=[1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight];
% tidy up
clear location color ADDED Qp GraphScore;
rainbow=zeros(Nodes,2);

%% Begin MCTS loop
PolicyDepth=0;
while PolicyDepth<Nodes
    
    %% SELECT
    % use policy (greedy selection of best Q value)
    %% Select-First location
    % index node we are choosing in rainbow
    n=1;
    % add seed origin to rainbow
    rainbow=zeros(Nodes,2);
    %% Start Select Policy Loop
    PolicyDepth=1;
    Source=0;
    while isempty(find(dTst(:,1)==Source))==0
        if isempty(find(dTst(:,1)==Source))==0 % Skip to Expand if Empty
            %% Select-Color
            % Options should be the first 6 nodes listed after source
            % the list should always be r o y g b v indexed as 1:6
            OptionI=find(dTst(:,1)==Source);
            NodeQ=[1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
                decisionTree.Edges.Weight];
            OptionS=NodeQ(OptionI);
            Choice=find(min(OptionS)==OptionS);
            Source=OptionI(Choice);
            rainbow(n,2)=Choice;
        end
        if isempty(find(dTst(:,1)==Source))==0
            %% Select-Location
            % list options
            OptionI=find(dTst(:,1)==Source);%indexs of all options 
            OptionS=NodeQ(OptionI);%scores of all options 
            Choice=find(min(OptionS)==OptionS);
            Source=OptionI(Choice);
            % add to rainbow
            rainbow(n,1)=Choice-1;
        end
        % Count how many rows in rainbow we have defined
        n=n+1;
        PolicyDepth=PolicyDepth+1;
        waitbar(PolicyDepth/11);
        if PolicyDepth==11
            close(WaitBar);
            run graphMCTS.m;
            return
        end
    end
    
    %% EXPAND
    % Find current terminal node to expand
    % is it a location or a color
    if strcmp(nodeLabel{Source},'r')||strcmp(nodeLabel{Source},'o')||...
            strcmp(nodeLabel{Source},'y')||strcmp(nodeLabel{Source},'g')||...
            strcmp(nodeLabel{Source},'b')||strcmp(nodeLabel{Source},'v')
        %Expand location options
        decisionTree=addedge(decisionTree,Source,length(nodeLabel)+1:...
            length(nodeLabel)+n,[ones(n,1)]);
        %Update Target
        Target=length(nodeLabel)+1;
        %Record New Node Labels
        for newLabel=1:n
            nodeLabel{1,length(nodeLabel)+1}=strcat('n',num2str(newLabel-1));
            %Add first pass to make positive
            decisionTree.Nodes.Sum(length(nodeLabel))=1;
        end
    else
        %Expand color options
        decisionTree=addedge(decisionTree,Source,length(nodeLabel)+1:...
            length(nodeLabel)+6,ones(6,1));
        %Update target
        Target=length(nodeLabel)+1;
        %Record New Node Labels
        nodeLabel{1,length(nodeLabel)+1}='r';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
        nodeLabel{1,length(nodeLabel)+1}='o';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
        nodeLabel{1,length(nodeLabel)+1}='y';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
        nodeLabel{1,length(nodeLabel)+1}='g';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
        nodeLabel{1,length(nodeLabel)+1}='b';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
        nodeLabel{1,length(nodeLabel)+1}='v';
        decisionTree.Nodes.Sum(length(nodeLabel))=1;
    end
    %% SIMULATE/EVALUATE
    % Determine if we need to pick a location or a color first
    
    %% Location
    if strcmp(nodeLabel{Source},'r')||strcmp(nodeLabel{Source},'o')||...
            strcmp(nodeLabel{Source},'y')||strcmp(nodeLabel{Source},'g')||...
            strcmp(nodeLabel{Source},'b')||strcmp(nodeLabel{Source},'v')
        Target=Target-1;%see two lines down
        for Node=1:n %survey all possible nodes 
            Target=Target+1;
            rainbow(n-1,:)=[Node-1,ceil(6*rand())];
            for s=1:sample
                N=n;% store n
                
                %% SIMULATE
                while n<=Nodes
                    % Make Random Graph
                    run PureRandom_mcts.m;
                    % Count
                    n=n+1;
                end
                n=N;
                % evaluate the graph
                run ColorScore_mcts.m
                % difference from target
                Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
                % Update Scores
                decisionTree.Nodes.Sum(Target)=decisionTree.Nodes.Sum(Target)+Qp;
                % Update edges travelled
                [dontcare,row]=intersect(dTst(:,1:2),[Source,Target],'rows');
                decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
                % update DTST
                dTst=[0,1,1;table2array(decisionTree.Edges)];
                
                %% BACK PROPAGATE
                Ttarget=Target;
                while dTst(Ttarget,1)>1
                    [dontcare,row]=intersect(dTst(:,2),Ttarget,'rows');
                    Tsource=dTst(row,1);
                    % Update Scores
                    decisionTree.Nodes.Sum(Ttarget)=decisionTree.Nodes.Sum(Ttarget)+Qp;
                    % Update edges travelled
                    [dontcare,row]=intersect(dTst(:,1:2),[Tsource,Ttarget],'rows');
                    decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
                    % Step back
                    [dontcare,row]=intersect(dTst(:,2),Tsource,'rows');
                    Ttarget=dTst(row,1);
                end
            end
            
        end
        
        %% COLOR SIM
    else
        Target=Target-1;%see two lines down
        for Color=1:6
            Target=Target+1;
            rainbow(n-1,2)=Color; %figure out what the location was from rainbow
            for s=1:sample
                N=n;
                %%%n=n-1;
                %% SIMULATE
                while n<=Nodes
                    % Make Random Graph
                    run PureRandom_mcts.m;
                    % Count
                    n=n+1;
                end
                n=N;
                % evaluate the graph
                run ColorScore_mcts.m
                % difference from target
                Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
                % Update Scores
                decisionTree.Nodes.Sum(Target)=decisionTree.Nodes.Sum(Target)+Qp;
                % Update edges travelled
                [dontcare,row]=intersect(dTst(:,1:2),[Source,Target],'rows');
                decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
                % update DTST
                dTst=[0,1,1;table2array(decisionTree.Edges)];
                
                %% BACK PROPAGATE
                Ttarget=Target;
                while dTst(Ttarget,1)>1
                    [dontcare,row]=intersect(dTst(:,2),Ttarget,'rows');
                    Tsource=dTst(row,1);
                    % Update Scores
                    decisionTree.Nodes.Sum(Ttarget)=decisionTree.Nodes.Sum(Ttarget)+Qp;
                    % Update edges travelled
                    [dontcare,row]=intersect(dTst(:,1:2),[Tsource,Ttarget],'rows');
                    decisionTree.Edges.Weight(row-1)=decisionTree.Edges.Weight(row-1)+1;
                    % Step back
                    [dontcare,row]=intersect(dTst(:,2),Tsource,'rows');
                    Ttarget=dTst(row,1);
                end
            end
        end
    end
end

%% OutPut?
NodeQ=10*[1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight]/max([1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight]);
LWidth=10*decisionTree.Edges.Weight/max(decisionTree.Edges.Weight);
TreeGraph=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel,'LineWidth',LWidth);
for w=1:length(NodeQ)
    highlight(TreeGraph,w,'MarkerSize',NodeQ(w,1));
end
h = msgbox('Something went weird');