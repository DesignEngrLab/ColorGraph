% I have had it with GraphSynth and am writing my own thing really quick
% for my sanity
% I will search the design tree to generate a color graph, and then plot it
% as digraph https://www.mathworks.com/help/matlab/ref/graph.plot.html?requestedDomain=www.mathworks.com
%%
tic
% Bypass setup if test conditions are being used
if (exist('TestConditions','var')==true)
    %Set Nodes
    Nodes=NodeSet(ndset);
    %Set Default Parameters
    if strcmp(TSselect,'GATS')||strcmp(TSselect,'GA-No Cross')||...
            strcmp(TSselect,'GA-No Mutate')
        %GA parameters are 
        Iterations=20;
        Brood=100;
    elseif strcmp(TSselect,'ACO')
        %ACO parameters
        evaporation=0.375;
        follow=1;
        Iterations=10;
        Brood=100;
    else
        %MCTS and others params
        Brood=1;
        Iterations=1;
    end
    %Store ALL THE DATA in a cell array rows by iteration/generation, columns
    %contain {score, recipe} for each graph in generation
    ScoreLog=cell(Iterations,Brood);
    % BROOD by 1 doubleof the scores for a single generation
    GenerationScores=zeros(Brood,1);
    % Disable colorgraph trial loop 
    Trials=1;
    
else % non-experiment version
    % Clear workspace
    format compact;
    clear all;
    clc
    COUNTRUNS=0;
    %Define the design tree that we are searching
    % We start from a seed of no color, this is indexed as 1 in matlab (0
    % in graphsynth)
    % There are two alternating choices, 1) Select a node to add to, and 2)
    % Select the color of the node ROYGBV (indexed 1-6 for simplicity)
    %We are going to add 10 nodes to the seed
    choice = questdlg('Graph Size', ...
        'How many nodes should be added?', ...
        '3 Nodes','5 Nodes','10 Nodes','3 Nodes');
    % Handle Response
    switch choice
        case '3 Nodes'
            Nodes=3;
        case '5 Nodes'
            Nodes=5;
        case '10 Nodes'
            Nodes=10;
    end
    %The graph recipe is an array or 3 columns, [Node Index, Added to, Color]
    %and a number of columns equal to the number of Nodes, for 10 Nodes added
    %we should end up with a 10x3 double, does not include seed properties
    % We need to load the property set we want to use.
    choice = questdlg('Gen Rand Prop', ...
        'Generate New Random Properties?', ...
        'Yes pls!','No Thank you','Yes pls!');
    % Handle Response
    switch choice
        case 'Yes pls!'
            run RandoProps.m;
        case 'No Thank you'
    end
    % Select Algorithm
    ListAlgorithms={'ACO','BFS','Brute Force',...
        'GATS','GA-No Cross','GA-No Mutate',...
        'MCTS','MCTS-Best Score',...
        'PureRandom'};
    [selection,ok]=listdlg('PromptString','Select an algorithm:',...
        'SelectionMode','single',...
        'ListString',ListAlgorithms);
    TSselect=ListAlgorithms(selection);
    disp(TSselect);
    %Select Experiment Parameters
    if strcmp(TSselect,'GATS')||strcmp(TSselect,'GA-No Cross')||...
            strcmp(TSselect,'GA-No Mutate')
        %Do we need to run multiple iterations for the class of tree search?
        %Do we need muliple "offspring" in this class of tree search?
        answer=inputdlg({'How many iterations?','What brood size?'...
            ,'Timeout after how many minutes','How many trials?'},...
            'Run Parameters',1,{'20','100','20','10'});
        Iterations=str2double(answer{1,1});
        Brood=str2double(answer{2,1});
        TIMEOUT=str2double(answer{3,1});
        Trials=str2double(answer{4,1});
        clear answer
    elseif strcmp(TSselect,'ACO')
        %Do we need to run multiple iterations for the class of tree search?
        %Do we need muliple "offspring" in this class of tree search?
        answer=inputdlg({'Evaporation Rate? (0-1)','Following Power? (0-5+)'...
            ,'How many iterations?','What brood size?'...
            ,'Timeout after how many minutes','How many trials?'},...
            'Run Parameters',1,{'0.375','1','10','100','20','1'});
        evaporation=str2double(answer{1,1});
        follow=str2double(answer{2,1});
        Iterations=str2double(answer{3,1});
        Brood=str2double(answer{4,1});
        TIMEOUT=str2double(answer{5,1});
        Trials=str2double(answer{6,1});
        clear answer
    else
        answer = inputdlg({'Timeout after how many minutes','How many trials?'},...
            'Run Parameters',1,{'20','10'});
        Trials=str2double(answer{2,1});
        TIMEOUT=str2double(answer{1,1});
        Brood=1;
        Iterations=1;
        clear answer
    end
    %Store ALL THE DATA in a cell array rows by iteration/generation, columns
    %contain {score, recipe} for each graph in generation
    ScoreLog=cell(Iterations,Brood);
    % BROOD by 1 doubleof the scores for a single generation
    GenerationScores=zeros(Brood,1);
    %ResultsTrial
    ResultsTrials=cell(Trials,1);
end
tic; %start timer for time elapsed
%% Loop for iterations and brood size
for trial=1:Trials
    evalRuns=0;
    BESTrainbow=[];
    BESTscore=[];
    for iteration=1:Iterations
        %Is time out for the run? 
        timeelapsed=toc;
        if timeelapsed>=TIMEOUT*60
            COMPLETED=0;
            return
        end
        offspring=1; % first value in loop 
        while offspring<=Brood
            % create the seed
            rainbow=zeros(Nodes,3);
            % build out the graph to the appropriate size using a treesearch function
            n=0;
            while n<Nodes
                % Count
                n=n+1;
                % Pass the added node from the tree search script
                % Select Search Method
                if strcmp(TSselect,'PureRandom')
                    run PureRandom.m;
                elseif strcmp(TSselect,'GATS')
                    run GATS.m;
                elseif strcmp(TSselect,'GA-No Cross')
                    run GAnocross.m;
                elseif strcmp(TSselect,'GA-No Mutate')
                    run GAnomute.m;
                elseif strcmp(TSselect,'MCTS')
                    run MCTS_CGrunnable.m;
                    n=Nodes;
                elseif strcmp(TSselect,'MCTS-Best Score')
                    run MCTS_cg_Best.m;
                    n=Nodes;
                elseif strcmp(TSselect,'BFS')
                    run BFS.m;
                elseif strcmp(TSselect,'Brute Force')
                    run BruteForceSearch.m
                    n=Nodes;
                elseif strcmp(TSselect,'ACO')
                    run ACO.m
%                     return
                    n=Nodes;
                    offspring=Brood;
                end
            end
            % tidy up
            clear ADDED;
            %% Evaluation
            % Evaluate the graph, this should probably be passed from another script
            % For now do additive properties of single edges
            run ColorScore.m
            if strcmp(TSselect,'MCTS')||strcmp(TSselect,'ACO')||strcmp(TSselect,'MCTS-Best Score')
                evalRuns=evalRuns-1;
            end
            Qp=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
            % Is it the best score?
            [BESTscore,BESTrainbow]=isbest(Qp,rainbow,BESTscore,BESTrainbow);
%             COUNTRUNS=COUNTRUNS+1;

            % Record all scores, along with recipes for this generation
            ScoreLog{iteration,offspring+1}={rainbow};
            GenerationScores(offspring,:)=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
            clear GraphScore;
            %% End Brood and iteration loops
            offspring=offspring+1;
        end
        ScoreLog{iteration,1}={GenerationScores};
    end
    COMPLETED=1;
    timeelapsed=toc;
%     ResultsTrials{trial,1}=ScoreLog;
%     ResultsTrials{trial,2}{1}=[BESTscore;evalRuns];
%     ResultsTrials{trial,2}{2}=BESTrainbow;
end
beep on
beep
beep off
%% Report Results
% MuScore=mean(ScoreLog{1,1}{1,1})
% MedScore=median(ScoreLog{1,1}{1,1})
% MinScore=min(ScoreLog{1,1}{1,1})
% LastScore=mean(ScoreLog{Iterations,1}{1,1})
% % % % run GeneratePlots.m;
% run ACOplot.m


%{
End code
%}
%% FUNCTIONS
% Best score function
function [BESTscore,BESTrainbow]=isbest(Qp,rainbow,BESTscore,BESTrainbow)
% Check if the best score
if isempty(BESTrainbow)||BESTscore>Qp
    BESTscore=Qp;
    BESTrainbow=rainbow;
    %     disp(strcat('BS: ',num2str(BESTscore),' - ',' Qp: ',num2str(Qp)))
    %     disp(rainbow);
end
end
% Generate Decision Tree
function dtGraph=plotDecisionTree(decisionTree,nodeLabel)
dtGraph=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel);
end