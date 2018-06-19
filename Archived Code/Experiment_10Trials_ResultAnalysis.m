%% Analyze Results of the 3 10 Trial Experiments
%% Clean up the work space
clear all
clc

%% Load Results
load('Experiment_10Trials_n3n5n10_GATS_MCTS.mat')
load('PureRandomControl.mat')
load('TrialProperties10.mat')

%% What are the things we should care about 
% We want the mean score
MeanScore=zeros(3,3);
%GA
MeanScore(1,1)=mean(RESULTS{1,1}{1,1}(:,1));
MeanScore(2,1)=mean(RESULTS{2,1}{1,1}(:,1));
MeanScore(3,1)=mean(RESULTS{3,1}{1,1}(:,1));
%MCTS
MeanScore(1,2)=mean(RESULTS{1,2}{1,1}(:,1));
MeanScore(2,2)=mean(RESULTS{2,2}{1,1}(:,1));
MeanScore(3,2)=mean(RESULTS{3,2}{1,1}(:,1));
%Random Control 
MeanScore(1,3)=mean(ControlTrials(:,1));
MeanScore(2,3)=mean(ControlTrials(:,2));
MeanScore(3,3)=mean(ControlTrials(:,3));

% We want standard deviation of trial results 
stdScore=zeros(3,3); 
%GA
stdScore(1,1)=std(RESULTS{1,1}{1,1}(:,1));
stdScore(2,1)=std(RESULTS{2,1}{1,1}(:,1));
stdScore(3,1)=std(RESULTS{3,1}{1,1}(:,1));
%MCTS
stdScore(1,2)=std(RESULTS{1,2}{1,1}(:,1));
stdScore(2,2)=std(RESULTS{2,2}{1,1}(:,1));
stdScore(3,2)=std(RESULTS{3,2}{1,1}(:,1));
%Random Control 
stdScore(1,3)=std(ControlTrials(:,1));
stdScore(2,3)=std(ControlTrials(:,2));
stdScore(3,3)=std(ControlTrials(:,3));

% Variance 
varScore=stdScore.^2;

% How much better is the method than the random control 
diffScore=zeros(3,2);
%GA
diffScore(1,1)=mean(ControlTrials(:,1)-RESULTS{1,1}{1,1}(:,1));
diffScore(2,1)=mean(ControlTrials(:,2)-RESULTS{2,1}{1,1}(:,1));
diffScore(3,1)=mean(ControlTrials(:,3)-RESULTS{3,1}{1,1}(:,1));
%MCTS
diffScore(1,2)=mean(ControlTrials(:,1)-RESULTS{1,2}{1,1}(:,1));
diffScore(2,2)=mean(ControlTrials(:,2)-RESULTS{2,2}{1,1}(:,1));
diffScore(3,2)=mean(ControlTrials(:,3)-RESULTS{3,2}{1,1}(:,1));

% What is the confidence that the method is better than random 
% Use a normal distribution 
ciScore=zeros(3,2);

%GA 
ciScore(1,1)=normcdf(diffScore(1,1)/stdScore(1,3),0,stdScore(1,3));
ciScore(2,1)=normcdf(diffScore(2,1)/stdScore(2,3),0,stdScore(2,3));
ciScore(3,1)=normcdf(diffScore(3,1)/stdScore(3,3),0,stdScore(3,3));
%MCTS
ciScore(1,2)=normcdf(diffScore(1,2)/stdScore(1,3),0,stdScore(1,3));
ciScore(2,2)=normcdf(diffScore(2,2)/stdScore(2,3),0,stdScore(2,3));
ciScore(3,2)=normcdf(diffScore(3,2)/stdScore(3,3),0,stdScore(3,3));

%Elapsed time=
ET=0;
ET=ET+sum(RESULTS{1,1}{1,1}(:,2));
ET=ET+sum(RESULTS{2,1}{1,1}(:,2));
ET=ET+sum(RESULTS{3,1}{1,1}(:,2));
ET=ET+sum(RESULTS{1,2}{1,1}(:,2));
ET=ET+sum(RESULTS{2,2}{1,1}(:,2));
ET=ET+sum(RESULTS{3,2}{1,1}(:,2));

%% Save them 
save('Experiment_Results_10T_3-4-10N.mat');
