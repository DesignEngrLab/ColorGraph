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

            # create the seed
            rainbow=zeros(Nodes,3)
            # This seeds the first iteration of ants
            for n=1:Nodes
                run PureRandom.m
            end

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
        else()
            #Generate random 1st iteration path()
            for n=1:Nodes
                run PureRandom.m
            end
            run ColorScore.m
            Qp=sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
            [decisionTree,nodeLabel]=UpdateTree(decisionTree,rainbow,nodeLabel,Qp)
        end
    else() # generations 2-end
        # create the seed
        rainbow=zeros(Nodes,3)
        rainbow[:,1]=1:Nodes
        S=1; #start at the seed
        # We know we select a color fist with already expanded options
        # Select a color edge to follow
                Option=decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]
                # Create a distribution based on pheromone values
                # RANDOM PROPORTIONAL RULE
                OptProportion=zeros(length(Option),1)
                OptProportion[1]=((Option[1]+.1^follow)/sum(Option+.1^follow))
                for opt=2:length(Option)
                    OptProportion[opt]=OptProportion[opt-1]+((Option[opt]+.1^follow)/sum(Option+.1^follow))
                end
                # Randomly select one
                T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]; # potential targets
                Ti=find(rand()<OptProportion, 1 ); # Index of selected target
                rainbow[1,3]=Ti
                S=T[Ti]; # update source
        for n=2:Nodes
            # Select path based on pheromone trails
            # loop until off the rails
            if ~isempty([find(decisionTree.Edges.EndNodes[:,1]==S)]) # if options exist()
                # Select a LOCATION edge to follow
                Option=decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]
                # Create a distribution based on pheromone values
                # RANDOM PROPORTIONAL RULE
                OptProportion=zeros(length(Option),1)
                OptProportion[1]=((Option[1]+.1^follow)/sum(Option+.1^follow))
                for opt=2:length(Option)
                    OptProportion[opt]=OptProportion[opt-1]+((Option[opt]+.1^follow)/sum(Option+.1^follow))
                end
                # Randomly select one
                T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]; # potential targets
                Ti=find(rand()<OptProportion, 1 ); # Index of selected target
                rainbow[n,2]=Ti-1
                S=T[Ti]

                if ~isempty([find(decisionTree.Edges.EndNodes[:,1]==S)]) # if options exist()
                # Select a COLOR edge to follow
                Option=decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]
                # Create a distribution based on pheromone values
                # RANDOM PROPORTIONAL RULE
                OptProportion=zeros(length(Option),1)
                OptProportion[1]=((Option[1]+.1^follow)/sum(Option+.1^follow))
                for opt=2:length(Option)
                    OptProportion[opt]=OptProportion[opt-1]+((Option[opt]+.1^follow)/sum(Option+.1^follow))
                end
                # Randomly select one
                T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]; # potential targets
                Ti=find(rand()<OptProportion, 1 ); # Index of selected target
                rainbow[n,3]=Ti
                S=T[Ti]
                else()
                    rainbow[n,3]=ceil(6*rand())
                end
            else() # if options don't exist()
            run PureRandom.m
            end
        end
        run ColorScore.m
        Qp=sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
        [decisionTree,nodeLabel]=UpdateTree(decisionTree,rainbow,nodeLabel,Qp)
    end
end

## Evaporation
decisionTree.Edges.Weight=decisionTree.Edges.Weight*(1-evaporation)

# update window
disp(strcat("Trial:',num2str(trial),'_','Iteration:',num2str(iteration),'_','Drone:",num2str(drone)))

# Determine current best design as proposed by ACO
rainbow=zeros(Nodes,3)
rainbow[:,1]=1:Nodes
S=1
T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]
    Ti=find(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]==...
        max(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]))
    rainbow[1,3]=Ti
    S=T[Ti]
for n=2:Nodes
    #Location
    T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]
    Ti=find(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]==...
        max(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]))
    rainbow[n,2]=Ti-1
    S=T[Ti]
    #Color
    T=decisionTree.Edges.EndNodes[[find(decisionTree.Edges.EndNodes[:,1]==S)],2]
    Ti=find(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]==...
        max(decisionTree.Edges.Weight[[find(decisionTree.Edges.EndNodes[:,1]==S)]]))
    rainbow[n,3]=Ti
    S=T[Ti]
end
run ColorScore.m
evalRuns=evalRuns-1; # uncount this eval as not part of algorithm
Qp=sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
BESTrainbow=rainbow
BESTscore=Qp
beep on
beep()
beep off
# Best on field
BESTavailable=find(decisionTree.Nodes.Sum==maximum(decisionTree.Nodes.Sum))
# Save Final Tree for each iteration
FinalDecisionTrees{iteration,1}=decisionTree
FinalDecisionTrees{iteration,2}=nodeLabel
FinalDecisionTrees{iteration,3}=BESTrainbow
FinalDecisionTrees{iteration,4}=BESTscore
FinalDecisionTrees{iteration,5}=BESTavailable==S
# Reset
S=1;

# # # # # end


# # # ## Display graph with weigthed edges
# # # Lwidth=decisionTree.Edges.Weight*19+1
# # # graphPlot=plot(decisionTree,"Layout','layered','NodeLabel",nodeLabel,...
# # #     "LineWidth",Lwidth)
# # # toHL=find(decisionTree.Nodes.Sum~=0)
# # # for HL=1:length(toHL)
# # # highlight[graphPlot,toHL[HL],"Marker','s','NodeColor','r','MarkerSize",decisionTree.Nodes.Sum[toHL[HL]]+5]
# # # end
# # # toHL=find(decisionTree.Nodes.Sum==maximum(decisionTree.Nodes.Sum))
# # # highlight[graphPlot,toHL,"NodeColor','y"]


## Function Bank
# Updates the decisionTree digraph given a rainbow
function() [decisionTree,nodeLabel]=UpdateTree(decisionTree,rainbow,nodeLabel,Qp)
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
# end
#Record goodness of end
decisionTree.Nodes.Sum[S]=pheromone*20
end
end
