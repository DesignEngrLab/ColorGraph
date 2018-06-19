% ColorScore.m is run in ColorGraph.m Calculates the score for a graph and
% passes it back as GraphScore
evalRuns=evalRuns+1; %how many evaluations
ni=0;
aScore=0;
bScore=0;
cScore=0;
while ni<Nodes
    %Count
    ni=ni+1;
    %Determine originating Node
    origin=rainbow(ni,2);
    if origin==0
        % Then act as if it is connect to itself 
        % determine terminal node color
        termColor=rainbow(ni,3);
        % Currently just summing properties, but could replace with more
        % complicated operation
        aScore=aScore+A(7,termColor);
        bScore=bScore+B(7,termColor);
        cScore=cScore+C(7,termColor);
    else
        orgColor=rainbow(rainbow(ni,2),3);
        % determine terminal node color
        termColor=rainbow(ni,3);
        % Currently just summing properties, but could replace with more
        % complicated operation
        aScore=aScore+A(orgColor,termColor);
        bScore=bScore+B(orgColor,termColor);
        cScore=cScore+C(orgColor,termColor);
    end
end
% Record Graph's Score
GraphScore=[aScore,bScore,cScore];
clear ni origin orgColor termColor aScore bScore cScore;