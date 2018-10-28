%% FitnessFun.m states the current design objective
% We want to minimize the score, rate by closeness to zero 
Position=1:Brood; 
Fitness=[GenerationScores,Position'];
Ranked=sortrows(Fitness,1);
clear Position Fitness; 