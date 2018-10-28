using PyPlot

## Draw Graphs
Graph=digraph[1,2]
## Add all nodes to appropriate place
for n=2:Nodes
    Graph=addedge[Graph,rainbow[n,1]+1,n+1]
end
p=plot(Graph,"Layout','force','NodeLabel",{})
## Color the nodes appropriately
highlight[p,1,"NodeColor','k"]
labelnode[p,1,"SEED"]
for n=2:length(rainbow)+1
    if rainbow[n-1,2]==1
        NODECOLOR='r'
    elseif rainbow[n-1,2]==2
        NODECOLOR=[1,0.5,0]
    elseif rainbow[n-1,2]==3
        NODECOLOR='y'
    elseif rainbow[n-1,2]==4
        NODECOLOR='g'
    elseif rainbow[n-1,2]==5
        NODECOLOR='b'
    elseif rainbow[n-1,2]==6
        NODECOLOR=[.75,0.25,.9]
    end
    highlight[p,n,"NodeColor",NODECOLOR]
    labelnode[p,n,n-1]
end
