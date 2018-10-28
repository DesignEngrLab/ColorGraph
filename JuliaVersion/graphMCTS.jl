% Plots final results of MCTS.m
% if you turned on hold while doing this it is
% probably faster
%% OutPut?
wait=length(NodeQ);
WaitBar = waitbar(0,'Ploting...');
NodeQ=10*[1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight]/max([1;decisionTree.Nodes.Sum(2:length(decisionTree.Nodes.Sum))./...
    decisionTree.Edges.Weight]);
LWidth=5*decisionTree.Edges.Weight/max(decisionTree.Edges.Weight);
TreeGraph=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel,'LineWidth',LWidth);
for w=1:length(NodeQ)
    waitbar(w/wait);
    highlight(TreeGraph,w,'MarkerSize',11-NodeQ(w,1));
end
%% write something to highlight the best node at each level
close(WaitBar);
%h = msgbox('Did it work?');