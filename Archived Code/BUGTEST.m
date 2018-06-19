% Reliability test
tic
for GOODRUNS=1:10;
    clearvars -except GOODRUNS % commented out line 4
    run MCTS.m;
end
toc