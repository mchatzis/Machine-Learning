function [] = svm()
%SVM


%Import data from csv file
%Create training data space input matrix
%Also keep aside 320 data (20% of data set) for testing
XtrainingImp = csvread("winequality-red.csv",1,0,[1,0,1279,10]);
XtestingImp = csvread("winequality-red.csv",1280,0,[1280,0,1599,10]);



%Enter x0 = 1 for all N to accomodate for the bias weights
x0 = ones(1279,1);
Xtraining = [x0 XtrainingImp];
x0 = ones(320,1);
Xtesting = [x0 XtestingImp];

%{
XImp = csvread("winequality-red.csv",1,0,[1,0,1599,10]);
x0 = ones(1599);
X = [x0 XImp];
y = csvread("winequality-red.csv",1,11,[1,11,1599,11]);
%}

clear XtrainingImp
clear XtestingImp
clear x0

%training output vector
yTraining = csvread("winequality-red.csv",1,11,[1,11,1279,11]);
yTesting = csvread("winequality-red.csv",1280,11,[1280,11,1599,11]);

%x0 = fixed acidity
%x1 = volatile acidity
%x2 = citric acid
%x3 = residual sugar
%x4 = chlorides
%x5 = free sulfur dioxide
%x6 = total sulfur dioxide 
%x7 = density
%x8 = pH
%x9 = sulphates
%x10 = alcohol
%y = quality

%ACTUAL LEARNING STARTS
%USING Statistics and Machine Learning Toolbox™ of Matlab


% Create a SVM regression model
svmLin = fitrsvm(Xtraining,yTraining,'OptimizeHyperparameters','all');
  
% Estimate mse and epsilon-insensitive loss by cross-validation
cv = crossval(svmLin);
mse = kfoldLoss(cv);

ypIn = predict(svmLin,Xtraining);
l = length(ypIn);
Ein = 1/l*((norm(ypIn-yTraining))^2);


forTable = [Ein mse];
SVMResults = array2table(forTable);
SVMResults.Properties.VariableNames={'Ein','Ecv'};

disp('SVM with hyper-optimized parameters follow')

SVMResults


toc
