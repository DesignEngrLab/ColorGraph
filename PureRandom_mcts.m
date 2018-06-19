% A tree search that randomly selects a location and adds a colored node
%%
% Select a location
    %because n is the current size of the graph, we can use it as an upper
    %bound
location=ceil(n*rand())-1;
% Select a color R-1,O-2,Y-3,G-4,B-5,V-6
color=ceil(6*rand());
% Put it all together and pass back as ADDED 
ADDED=[location,color];
%add to rainbow
rainbow(n,:)=ADDED;