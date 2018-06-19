% I have had it with GraphSynth and am writing my own thing really quick
% for my sanity
% I will search the design tree to generate a color graph, and then plot it
% as digraph https://www.mathworks.com/help/matlab/ref/graph.plot.html?requestedDomain=www.mathworks.com
%%
tic 
% Bypass setup if test conditions are being used
if (exist('TestConditions','var')==true)
    %Skip the setup, it is performed in RunTests.m
else
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
    % Select Algorithm 
    TSselect='GATS'; 
end
%% Loop for iterations and brood size
for iteration=1:Iterations
    for offspring=1:Brood
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
            elseif strcmp(TSselect,'BFS')
                run BFS.m;
            end
        end
        % tidy up
        clear ADDED;
        %% Evaluation
        % Evaluate the graph, this should probably be passed from another script
        % For now do additive properties of single edges
        run ColorScore.m
        COUNTRUNS=COUNTRUNS+1;
        % Record all scores, along with recipes for this generation
        ScoreLog{iteration,offspring+1}={rainbow};
        GenerationScores(offspring,:)=sqrt(GraphScore(1)^2+GraphScore(2)^2+GraphScore(3)^2);
        clear GraphScore;
        %% End Brood and iteration loops
    end
    ScoreLog{iteration,1}={GenerationScores};
end
%% Report Results
mean(ScoreLog{1,1}{1,1})
mean(ScoreLog{round(Iterations/2),1}{1,1})
mean(ScoreLog{Iterations,1}{1,1})
timeelapsed=toc
run GeneratePlots.m;