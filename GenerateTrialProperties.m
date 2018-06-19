%% Generate and Archive trial properties 

% how many 
trials=10;

% place to store them 
TrialProp=cell(trials,3);

% Fill in with random properties 
for t=1:10
    run RandoProps.m
    TrialProp{t,1}=A;
    TrialProp{t,2}=B;
    TrialProp{t,3}=C;
end

% Comment out specific save file so they don't go away 
%save('TrialProperties10.mat','TrialProp');
save('TrialProperties.mat','TrialProp');
