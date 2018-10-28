#
#ACO.m is an Ant Colony Optimization algorithm for the colorgraph problem.
#It is run in ColorGraph.m
#
# ## Parameters
# evaporation=0.25; # the rate at which the pheromone evaporates as a product
# follow=0; # a scalar that weights the probaility of trying a new path (0=likely new, 100=probably repeat)

## First Generation
# The first generation of the GA is purely Random, use PureRandom.m

# # # # # for iteration=1:Iterations
for drone=1:Brood
    if iteration==1



        if drone==1
            # Create place to store final graphs
            clear decisionTree
            FinalDecisionTrees=cell(Iterations,5)

#             # create the seed
#             rainbow=zeros(Nodes,3)
#             # This seeds the first iteration of ants
#             for n=1:Nodes
#                 run PureRandom.m
#             end

            # Add path to search tree as a digraph with terminal nodes (at level n=
            # Nodes) tracking scores and edgeweights tracking pheromone trails

            # We will keep track of the index of the Source Node S and target node T
            S=1

            # We need to make labels for the nodels
            nodeLabel={"n0"}
            nodeLabel{1,S+1}='r'
            nodeLabel{1,S+2}='o'
            nodeLabel{1,S+3}='y'
            nodeLabel{1,S+4}='g'
            nodeLabel{1,S+5}='b'
            nodeLabel{1,S+6}='v'

            # We are going to need to keep track of the sum score values
            #     NodeTable=table[[0],"VariableNames',{'Sum"}]
            NodeTable=table[[0;0;0;0;0;0;0],"VariableNames',{'Sum"}]

            # We need to create a digraph with edge weights, of Sum
            decisionTree=digraph[S,2:7,[0,0,0,0,0,0],NodeTable]
            #     decisionTree=digraph[S,[0],NodeTable]

            run ColorScore.m
            Qp=sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)

            #Add to the graph
            [decisionTree,nodeLabel]=UpdateTree(decisionTree,rainbow,nodeLabel,Qp)
        return()
        end
    end
end
## Function Bank
# Updates the decisionTree digraph given a rainbow
function UpdateTree(decisionTree,rainbow,nodeLabel,Qp)
[Nodes,col]=size(rainbow)
rnbw=cell(Nodes,2)
Colors={"r','o','y','g','b','v"}

#calculate pheromone intensity by normalizing on a log scale from perfect
#score=0 to worst possible score=sqrt(3*50^2)~612.3724
pheromone=2*normcdf[-1*Qp,0,sqrt(3*50)/3]

#going through the rainbow add each decision
for r=1:Nodes #first convert rainbow to node labels and place in rnbw
    rnbw{r,1}=strcat('n',num2str(rainbow[r,2]))
    rnbw{r,2}=Colors{rainbow[r,3]}
end

#Seed node is first source
S=1
T=[decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]]; #all leaves
Ti=find(strcmp(nodeLabel[T],rnbw{1,2})); #target index in T
S=T[Ti]; #new source
#add pheromone trail
pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone

for r=2:Nodes*2
    nLBL=nodeLabel[S]
    if ~strcmp(nLBL{1}(1),'n') #is a color
        # Does the branch exist()?
        if ~isempty([find(decisionTree.Edges.EndNodes[:,1]==S)]) # it does exist()
            # add pheromone trail
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
            T=[decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]]
            Ti=find(strcmp(nodeLabel[T],rnbw{ceil(r/2),1}))
            S=T[Ti]
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
        else() # it doesn"t exist disp('Expand Locations")
            if r==Nodes*2
                break()
            end
            for no=0:ceil(r/2)
                nodeLabel{1,length(nodeLabel)+1}=strcat('n',num2str(no))
                decisionTree=addedge[decisionTree,S,length(nodeLabel),0]
            end
            T=[decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]]
            Ti=find(strcmp(nodeLabel[T],rnbw{ceil(r/2),1}))
            S=T[Ti]
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
        end
    else() #is a location
        # Does the branch exist()?
        if ~isempty([find(decisionTree.Edges.EndNodes[:,1]==S)]) # it does exist()
            # add pheromone trail
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
            T=[decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]]
            Ti=find(strcmp(nodeLabel[T],rnbw{ceil(r/2),2}))
            S=T[Ti]
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
        else() #it doesn"t exist disp('Expand Colors")
            for color=1:6
                nodeLabel{1,length(nodeLabel)+1}=Colors{color}
                decisionTree=addedge[decisionTree,T[Ti],length(nodeLabel),0]
            end

            T=[decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]]
            Ti=find(strcmp(nodeLabel[T],rnbw{ceil(r/2),2}))
            S=T[Ti]
            pherEdge=find(S==decisionTree.Edges.EndNodes[:,2])
            decisionTree.Edges.Weight[pherEdge]=decisionTree.Edges.Weight[pherEdge]+pheromone
        end
    end
end
#
[decisionTree,nodeLabel]
end
#Record goodness of end
decisionTree.Nodes.Sum[S]=pheromone*20
end
end
