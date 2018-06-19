% GATS.m is a Genetic Algorithm tree search. It is run in ColorGraph.m
% after initialization, but before evaluation
%% First Generation
% The first generation of the GA is purely Random, use PureRandom.m
if iteration==1
    % This seeds the first generation
    %% Parameters
    % the number of top scorer's that get to live and breed
    top=10;
    % Distribution of offspring use icdf(pd,RAND) to get out a value
    mu=0;
    sigma=8;
    pd = makedist('Normal',mu,sigma);
    % Crossover rate
    cross=0.8;
    % Mutation rate
    mute=0.05;
    %% Generate seed
    run PureRandom.m;
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