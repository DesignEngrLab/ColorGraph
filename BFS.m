%% BFS.m is a best first search of the ColorGraph problem.
%Begin the choices list
choices=A(:,:).^2+B(:,:).^2+C(:,:).^2;
options=choices(7,:);
if n==1
    %% if this is the first node added
    %Generate scores for each first choice
    best=find(options == min(options(:)));
    % Put it all together and pass back as ADDED
    ADDED=[n,0,best];
else
    %% add later nodes
    % What are the possible node placements
    OriginOptions=unique(rainbow(:,3));
    OriginOptions=OriginOptions(find(OriginOptions~=0));
    for L=1:length(OriginOptions)
        options=[options;choices(OriginOptions(L),:)];
    end
    % which find row and column of best
    [row,col]=find(choices == min(options(:)));
    if row==7
        ADDED=[n,0,col];
    else
        ADDED=[n,row,col];
    end
end
%add to rainbow
rainbow(n,:)=ADDED;
clear seeded L OriginOptions ADDED best seeded row col