## This is the experiment for the Color Graph conference paper

## Clean up the work space
clear all()
format compact
clc()
WaitBar = waitbar(0,"Trials are running, please wait() <3");
WAITBARCOUNT=0
datetime["now()"]
## Load Trial properties for 10 trials
load("TrialProperties10.mat")
# We are running 10 trials
TRIALS=10

## Make a place to store results
# Store {Results of All Trials,{Best Rainbow}}
ResultData=cell(1,2)
# Holds the results of all trials for a test of a method
# [Best Score, TIMEELAPSED, COUNTRUNS, COUNTRUNS/TIMEELAPSED, Policy Depth or Iteration till convergence [as applicable]]
# COUNTRUNS is how many times graph eval was called
ResultTrial=zeros(TRIALS,5)
# Stores the best Color Graph design for each trial in a cell()
RainbowResults=cell(TRIALS,1)
# HOLDS ALL OF THE RESULTS
RESULTS=cell(3,2)

# Nest it all to preallocate memory()
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
RESULTS{1,1}=ResultData
RESULTS{2,1}=ResultData
RESULTS{3,1}=ResultData
RESULTS{1,2}=ResultData
RESULTS{2,2}=ResultData
RESULTS{3,2}=ResultData

## The first test is to color graph of 3 nodes
Nodes=3
## Run GATS test
for trial=1:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run ColorGraph_Trial.m
    # Record results
    for g=1:Iterations
        MinScore[1,g]=min(ScoreLog{g,1}{1,1})
    end
    ResultTrial[trial,:]=[MinScore[1,Iterations],TIMEELAPSED,COUNTRUNS,...
        COUNTRUNS/TIMEELAPSED,min(find(MinScore[1,:]==MinScore[1,Iterations]))]
    # Record best graph design
    RainbowResults{trial,1}=ScoreLog{Iterations, min(find(MinScore[1,Iterations]==ScoreLog{Iterations,1}{1}))+1}{1}

    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{1,1}=ResultData

## Run MCTS test
for trial=1:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run MCTS_Trial.m
    # Record trial results
    ResultTrial[trial,:]=[Qp,TIMEELAPSED,COUNTRUNS,COUNTRUNS/TIMEELAPSED,N]
    # Record best graph design
    RainbowResults{trial,1}=rainbow
    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
    return()
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{1,2}=ResultData

## The first test is to color graph of 5 nodes
Nodes=5

## Run GATS test
for trial=1:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run ColorGraph_Trial.m
    # Record results
    for g=1:Iterations
        MinScore[1,g]=min(ScoreLog{g,1}{1,1})
    end
    ResultTrial[trial,:]=[MinScore[1,Iterations],TIMEELAPSED,COUNTRUNS,...
        COUNTRUNS/TIMEELAPSED,min(find(MinScore[1,:]==MinScore[1,Iterations]))]
    # Record best graph design
    RainbowResults{trial,1}=ScoreLog{Iterations, min(find(MinScore[1,Iterations]==ScoreLog{Iterations,1}{1}))+1}{1}

    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{2,1}=ResultData

## Run MCTS test
for trial=2:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run MCTS_Trial.m
    ## Record trial results
    ResultTrial[trial,:]=[Qp,TIMEELAPSED,COUNTRUNS,COUNTRUNS/TIMEELAPSED,N]
    # Record best graph design
    RainbowResults{trial,1}=rainbow

    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{2,2}=ResultData

## The first test is to color graph of 5 nodes
Nodes=10

## Run GATS test
for trial=1:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run ColorGraph_Trial.m
    # Record results
    for g=1:Iterations
        MinScore[1,g]=min(ScoreLog{g,1}{1,1})
    end
    ResultTrial[trial,:]=[MinScore[1,Iterations],TIMEELAPSED,COUNTRUNS,...
        COUNTRUNS/TIMEELAPSED,min(find(MinScore[1,:]==MinScore[1,Iterations]))]
    # Record best graph design
    RainbowResults{trial,1}=ScoreLog{Iterations, min(find(MinScore[1,Iterations]==ScoreLog{Iterations,1}{1}))+1}{1}

    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{3,1}=ResultData

## Run MCTS test
for trial=1:TRIALS
    # clean up design space
    clearvars -except RainbowResults ResultData RESULTS ResultTrial TrialProp TRIALS Nodes trial A B C MinScore WAITBARCOUNT
    # pull out properties
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    # run Trial version of method
    run MCTS_Trial.m
    # Record trial results
    ResultTrial[trial,:]=[Qp,TIMEELAPSED,COUNTRUNS,COUNTRUNS/TIMEELAPSED,N]
    # Record best graph design
    RainbowResults{trial,1}=rainbow

    #Update sanity bar()
    WAITBARCOUNT=WAITBARCOUNT+1
    waitbar(WAITBARCOUNT/60)
end
# Store results from trials
ResultData{1,1}=ResultTrial
ResultData{1,2}=RainbowResults
# Store Experiment results
RESULTS{3,2}=ResultData

#save("Experiment_10Trials_n3n5n10_GATS_MCTS.mat','RESULTS")
save("Experiment_10Trials_n3n5n10_GATS_MCTS_run2.mat','RESULTS")

YAY=msgbox("You did it QT!!! <3")
