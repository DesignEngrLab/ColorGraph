%{
ACO.m is an Ant Colony Optimization algorithm for the colorgraph problem.
It is run in ColorGraph.m
%}

%% First Generation
% The first generation of the GA is purely Random, use PureRandom.m
if iteration==1
    % This seeds the first iteration of ants
    for n=1:Nodes
        run PureRandom.m;
    end
    
    % Add path to search tree as a digraph with terminal nodes (at level n=
    % Nodes) tracking scores and edgeweights tracking pheromone trails
    
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
    NodeTable=table([0;0;0;0;0;0;0],'VariableNames',{'Sum'});
    
    % We need to create a digraph with edge weights, of Sum
    decisionTree=digraph(S,2:7,[0,0,0,0,0,0],NodeTable);
    
    run ColorScore.m
    Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
    
    decisionTree=UpdateTree(decisionTree,rainbow,nodeLabel,NodeTable,Qp);
    
    
    
    %% Offspring generations
else
    % get fitness scores
    if offspring==1
        run FitnessFun.m
    end
    % Preserve top from previous generation
    if (1<=offspring) && (offspring<=top)
        %Transcribe over top
        rainbow=ScoreLog{iteration-1,Ranked(offspring,2)+1}{1};
    else % Generate the rest of the generation 
        %% CROSS
        %Randomly select two parents
        RentA=ScoreLog{iteration-1,Ranked(ceil(icdf(pd,1-rand()/2)),2)+1}{1};
        RentB=ScoreLog{iteration-1,Ranked(ceil(icdf(pd,1-rand()/2)),2)+1}{1};
        for row=1:Nodes
            if rand()>0.5
                rainbow(row,:)=RentA(row,:);
            else
                rainbow(row,:)=RentB(row,:);
            end
            %% MUTATE
            if mute>rand()
                % change node color if mutation occurs
                rainbow(row,3)=ceil(6*rand());
            end
            if mute>rand()
                % change node color if mutation occurs
                rainbow(row,2)=floor(row*rand());
            end
        end
    end
end

%% Function Bank 
% Updates the decisionTree digraph given a rainbow 
function decisionTree=UpdateTree(decisionTree,rainbow,nodeLabel,NodeTable,Qp)
[Nodes,col]=size(rainbow);
rnbw=cell(Nodes,2);
Colors={'r','o','y','g','b','v'};

%calculate pheromone intensity by normalizing on a log scale from perfect
%score=0 to worst possible score=sqrt(3*50^2)~612.3724
pheromone=2*normcdf(-1*Qp,0,sqrt(3*50)/3);

%going through the rainbow add each decision
for r=1:Nodes %first convert rainbow to node labels and place in rnbw
    rnbw{r,1}=strcat('n',num2str(rainbow(r,2)));
    rnbw{r,2}=Colors{rainbow(r,3)};
end
%check if edge exists 
S=1; % the seed node is the first (s)ource node
for r=1:Nodes
    T=decisionTree.Edges.EndNodes([find(decisionTree.Edges.EndNodes(:,1)==S)],2);
    nodeExists=isempty(find(strcmp(nodeLabel(T),rnbw{r,2})==1,1))==0;
    if ~nodeExists %if node doesn't exist, add it
        if rnbw{r,2}(1)=='n'
            for no=1:Nodes
                nodeLabel{1,length(nodeLabel)+1}=strcat('n',num2str(Nodes-1));
                decisionTree.Nodes.Sum(length(nodeLabel))=0;
            end
%             msgbox('Update Tree Error: 01');
%             return
        else
            % Add the appropriate edge to the decision tree
            decisionTree=addedge(decisionTree,S,length(nodeLabel)+1:...
                length(nodeLabel)+6,zeros(6,1));
            %Add the appropriate node labels
            for color=1:6
                nodeLabel{1,length(nodeLabel)+1}=Colors{color};
                decisionTree.Nodes.Sum(length(nodeLabel))=0;
            end
        end
    end
    %Add pheromone to path (edge) 
    % from T (possible targets), but must select the one in rnbw, Ti
    Ti=find(strcmp(nodeLabel(T),rnbw{r,2}));
    % Locate Edge row 
    EdgeRow=find(T(Ti)==decisionTree.Edges.EndNodes(find(...
        S==decisionTree.Edges.EndNodes(:,1)),2));
    % Update the Weight for that Edge 
    decisionTree.Edges.Weight(EdgeRow)=...
        decisionTree.Edges.Weight(EdgeRow)+pheromone;
    
    % Set Source as previous Target
    S=T(Ti);
end
end