MeanScorePlot=zeros(1,Iterations);
MinScorePlot=zeros(1,Iterations);
MaxScorePlot=zeros(1,Iterations);
for g=1:Iterations
    MeanScorePlot(1,g)=mean(ScoreLog{g,1}{1,1});
    MinScorePlot(1,g)=min(ScoreLog{g,1}{1,1});
    MaxScorePlot(1,g)=max(ScoreLog{g,1}{1,1});
end
figure 
subplot(1,3,1)
plot((1:Iterations),MeanScorePlot)
title('Mean Score')
xlabel('Generation')
ylabel('Score')
axis([1,Iterations 0,100])

subplot(1,3,2)
plot((1:Iterations),MinScorePlot)
title('Min Score')
xlabel('Generation')
ylabel('Score')
axis([1,Iterations 0,100])

subplot(1,3,3)
plot((1:Iterations),MaxScorePlot)
title('Max Score')
xlabel('Generation')
ylabel('Score')
axis([1,Iterations 0,100])
