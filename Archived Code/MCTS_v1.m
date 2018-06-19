%% outdated code, use MCTS.m instead
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
%% Create structure
% After reading about several data structures and considering the merits of
% struct, tree, classes, and cell arrays I decided a cell array was the
% best way to keep track of the scores.
% I will use a structure of mcTREE={SCORES;{BRANCHES}} alternating between
% locations and colors
% scores are an array [summed points, summed trials] so we can divide out
% their values 
mcTREE={[0];[1];{}};
bookMark=mcTREE;
%% SELECT 
% use policy (greedy selection of best Q value) 
turn=1;
for P=1:n
    %% Choose Location 
    choose=find(min(bookMark{1,:}/bookMark{2,:})==bookMark{1,:}/bookMark{2,:});
    rainbow(n,2)=choose-1;
    if isempty(bookMark{3,choose})==0
        bookMark=bookMark{3,choose};
        turn=2;
    else
        % If it is empty break the for loop and EXPAND
        break
    end
    %% Choose Color
    choose=find(min(bookMark{1,:}/bookMark{2,:})==bookMark{1,:}/bookMark{2,:});
    rainbow(n,3)=choose;
    if isempty(bookMark{3,choose})==0
        bookMark=bookMark{3,choose};
        turn=1;
    else 
        % If it is empty break the for loop and EXPAND
        break
    end
end
%% EXPAND
% find current terminal node (should be the Pth node listed in rainbow)
%% SIMULATE/EVALUATE
if P==10
    mcTREE{3,rainbow(1,2)+1}{3,rainbow(1,3)}{3,rainbow(2,2)+1}{3,rainbow(2,3)}...
        {3,rainbow(4,2)+1}{3,rainbow(4,3)}{3,rainbow(5,2)+1}{3,rainbow(5,3)}...
        {3,rainbow(6,2)+1}{3,rainbow(6,3)}{3,rainbow(7,2)+1}{3,rainbow(7,3)}...
        {3,rainbow(8,2)+1}{3,rainbow(8,3)}{3,rainbow(9,2)+1}{3,rainbow(9,3)}...
        {3,rainbow(10,2)+1}{3,rainbow(10,3)};
    %Do nothing, because it is done 
elseif P==1
    if turn==1 % Choose a location 
        % build on the seed
        rainbow(1,2)=0;
        mcTREE{3,rainbow(1,2)+1};
        
        nTEMP=n;
        n=0;
        while n<Nodes
            % Count
            n=n+1;
            run PureRandom.m;
        end
        
                
    end
end

%% BACK PROPAGATE SCORES 