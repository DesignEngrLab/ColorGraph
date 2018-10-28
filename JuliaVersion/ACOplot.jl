## Display graph with weigthed edges
Lwidth=decisionTree.Edges.Weight*19+1
Lwidth=10*Lwidth/maximum(Lwidth)
graphPlot=plot(decisionTree,"Layout','layered','NodeLabel",nodeLabel,...
    "LineWidth",Lwidth)
toHL=find(decisionTree.Nodes.Sum~=0)
for HL=1:length(toHL)
highlight[graphPlot,toHL[HL],"Marker','s','NodeColor','r','MarkerSize",decisionTree.Nodes.Sum[toHL[HL]]+5]
end
toHL=find(decisionTree.Nodes.Sum==maximum(decisionTree.Nodes.Sum))
highlight[graphPlot,toHL,"NodeColor','y"]
