%% Display graph with weigthed edges
graphPlot=plot(decisionTree,'Layout','layered','NodeLabel',nodeLabel,'NodeColor','k','EdgeColor','k');
% toHL=find(decisionTree.Nodes.Sum~=0);
% for HL=1:length(toHL)
% highlight(graphPlot,toHL(HL),'Marker','s','NodeColor','r','MarkerSize',decisionTree.Nodes.Sum(toHL(HL))+5);
% end
% toHL=find(decisionTree.Nodes.Sum==max(decisionTree.Nodes.Sum));
highlight(graphPlot,33,'NodeColor','r','Marker','p','MarkerSize',10)