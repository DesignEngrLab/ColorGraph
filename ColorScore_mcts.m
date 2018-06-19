% ColorScore.m is run in ColorGraph.m Calculates the score for a graph and
% passes it back as GraphScore
%tic
m=0;
aScore=0;
bScore=0;
cScore=0;
while m<Nodes
    %Count
    m=m+1;
    %Determine originating Node
    origin=rainbow(m,1);
    if origin==0
        % Then act as if it is connect to itself 
        % determine terminal node color
        termColor=rainbow(m,2);
        % Currently just summing properties, but could replace with more
        % complicated operation
        aScore=aScore+A(7,termColor);
        bScore=bScore+B(7,termColor);
        cScore=cScore+C(7,termColor);
    else
        orgColor=rainbow(rainbow(m,1),2);
        % determine terminal node color
        termColor=rainbow(m,2);
        % Currently just summing properties, but could replace with more
        % complicated operation
        aScore=aScore+A(orgColor,termColor);
        bScore=bScore+B(orgColor,termColor);
        cScore=cScore+C(orgColor,termColor);
    end
end
COUNTRUNS=COUNTRUNS+1;
% Record Graph's Score
GraphScore=[aScore,bScore,cScore];
clear m origin orgColor termColor aScore bScore cScore;
%toc