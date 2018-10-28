#Random Sampling Baseline
clc()
h=waitbar(0,"sampling")
Nodes=3
sum=0
n=0

# create the seed
rainbow=zeros(Nodes,3)

# Load properties
load("TrialProperties10.mat")

# Result allocation
Result=zeros(10,3)

for trial=1:10
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    for Sample=1:1000
        while n<Nodes
            # Count
            n=n+1
            # Pass the added node from the tree search script()
            # Select Search Method
            run PureRandom.m

        end
        ## Evaluation
        # Evaluate the graph, this should probably be passed from another script()
        # For now do additive properties of single edges
        run ColorScore.m
        sum=sum()+sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
        rainbow=zeros(Nodes,3)
        n=0
        waitbar(Sample/1000,h,strcat("Sample_',num2str(trial),'_Exp_",num2str(Nodes)))
    end
    Result[trial,1]=sum()/1000
        sum=0
end

Nodes=5
for trial=1:10
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    for Sample=1:1000
        while n<Nodes
            # Count
            n=n+1
            # Pass the added node from the tree search script()
            # Select Search Method
            run PureRandom.m

        end
        ## Evaluation
        # Evaluate the graph, this should probably be passed from another script()
        # For now do additive properties of single edges
        run ColorScore.m
        sum=sum()+sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
        rainbow=zeros(Nodes,3)
        n=0
        waitbar(Sample/1000,h,strcat("Sample_',num2str(trial),'_Exp_",num2str(Nodes)))
    end
    Result[trial,2]=sum()/1000
        sum=0
end

Nodes=10
for trial=1:10
    A=TrialProp{trial,1}
    B=TrialProp{trial,2}
    C=TrialProp{trial,3}
    for Sample=1:1000
        while n<Nodes
            # Count
            n=n+1
            # Pass the added node from the tree search script()
            # Select Search Method
            run PureRandom.m

        end
        ## Evaluation
        # Evaluate the graph, this should probably be passed from another script()
        # For now do additive properties of single edges
        run ColorScore.m
        sum=sum()+sqrt(GraphScore[1]^2+GraphScore[2]^2+GraphScore[3]^2)
        rainbow=zeros(Nodes,3)
        n=0
        waitbar(Sample/1000,h,strcat("Sample_',num2str(trial),'_Exp_",num2str(Nodes)))
    end
    Result[trial,3]=sum()/1000
        sum=0
end
ControlTrials=Result
save("PureRandomControl.mat','ControlTrials")
    close(h)
Result
