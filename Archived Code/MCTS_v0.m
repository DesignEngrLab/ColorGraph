%% MCTS.m is the most current, MCTS_v0 is an earlier iteration 
% is a monte carlos tree search that runs in ColorGraph.m
% really good tutorial https://www.youtube.com/watch?v=onBYsen2_eA
% if first run define parameters
if n==1
    % sample size
    smpsz=10;
    % Create a place to log Q values, each row is a new round of decisions
    % with the first column being position selection and second column
    % color selection
    Qlog=cell(Nodes,2)
end
%% Select
% use policy (greedy selection of highest Q value)
for P=1:n
    % select location based on existing policy
    if isempty(Qlog{n,1})==0
        rainbow(n,2)=min(Qlog{n,1}(1,:)/Qlog{n,1}(2,:))-1;
    end
    % select color based on exxisting policy
    if isempty(Qlog{n,2})==0
        rainbow(n,3)=min(Qlog{n,1}(1,:)/Qlog{n,1}(2,:));
    end
end
%% LOCATION NODE
%% Expansion
% If level has not been evaluated yet randomly sample designs and record
% results
% We can not assume that level n has not yet been explored because we may
% end up evaluating a different leaf earlier on, so first we must check to
% see if our current level has been explored 
for P=1:n
    if isempty
%% Simulate
% Evaluation states to determine mean Q value
%% Backup
% adjust previous nodes averages to reflect new Q values
%% COLOR NODE
%% Expansion
% If level has not been evaluated yet randomly sample designs and record
% results
% expand
%% Simulate
% Evaluation states to determine mean Q value
%% Backup
% adjust previous nodes averages to reflect new Q values
%% Clean up
clear smpsz