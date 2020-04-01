%Functionality: Machine Learning Algorithm based on Linear Regression
%Developed by: Michail Chatzis
%Running time: 20 seconds on an Intel i5-6200U with 4GB RAM
%Calculations show that less than 2 GB of (Free)RAM systems may fail to run the
%code especially the SVM part
%(quite unlikely for modern computers)


%BASED ON 10-FOLD VALIDATION

clear
clc
warning('off','all')
warning
close all

tic;

%Import data from csv file
%Create training data space input matrix
%Also keep aside 320 data (20% of data set) for testing|DON'T Touch them
%until the end so that they can be trusted!
XtrainingImp = csvread("./data/winequality-red.csv",1,0,[1,0,1279,10]);
XtestingImp = csvread("./data/winequality-red.csv",1280,0,[1280,0,1599,10]);



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

%Clear up some memory 
clear XtrainingImp
clear XtestingImp
clear x0

%training output vector
yTraining = csvread("./data/winequality-red.csv",1,11,[1,11,1279,11]);
yTesting = csvread("./data/winequality-red.csv",1280,11,[1280,11,1599,11]);

%Documenting what inputs are in reality
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

%Initiate array to keep errors being returned from functions that perform
%learning
Ein = [];
ECVal = [];

%{
GENERAL COMMENTS FOR CODE FOLLOWING...
A. 10-Fold Cross Validation is used to obtain a Cross Validation error for
   the models that follow. The vFoldCrossValidation.m function calls the
   linear regression algorithm and hence performs the whole modelling by
   itself without the need for further functions. 
B. Specification for the exact operation of the functions called by this 
   top level module can be found as comments inside the respective
   functions to avoid verbose code.
C. Due to similarity of code used for following models, comments applying
   to all models will be made once in the first instance needed and then
   will be assumed known. i.e. comments will get reduced as moving down
%}

%LINEAR REGRESSION - No Regularization
%lamda parameter is passed into vFoldCrossValidation to determine
%regularization amount
lamda = 0;
%Next function performs linear Regression with weight decay regularization
%of value lamda and validating using 10-fold cross validation
%g = weight vector
%ErrIn = in-sample Error
%Caution: both g dummy are dummy. This is because
%they are not trained on whole dataset because 10-fold cross-validation
%leaves out a tenth of data each time. Hence, ErrIn is calculated
%seperately on the whole dataset after cross validation.
%ErrOut on the contrary is important, because it is the cross validation
%error which we will use to pick our model
[g,dummy,ErrOut] = vFoldCrossValidation(Xtraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Xtraining,yTraining,lamda);
Ein = [Ein ; ErrIn];
ECVal = [ECVal ; ErrOut];

%NON-LINEAR TRANSFORMATION REGRESSION of F2(x) - NO regularization
%Mapping performed
%(1,x1,x2...x11) -> (1,x1,x1^2,x1x2,x1x3,...x1x11,x2,x2^2,x2x3...x11^2)
lamda = 0;
%Transform Xtraining to Ztraining
Ztraining = NonLinearCorrelations(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal; ErrOut];

%2nd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x2,x2^2...x11^2)
lamda = 0;
Ztraining = nthOrderTransform(Xtraining,2);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein; ErrIn];
ECVal = [ECVal;ErrOut];

%3rd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x1^3,x2,x2^2,x2^3...x11^3)
lamda = 0;
Ztraining = nthOrderTransform(Xtraining,3);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein; ErrIn];
ECVal = [ECVal;ErrOut];

%6th Order Transform
lamda = 0;
Ztraining = nthOrderTransform(Xtraining,6);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein; ErrIn];
ECVal = [ECVal;ErrOut];

%LEGENDRE REGRESSION of order 2
%Using transformation based on Legendre Polynomials up to order 2
lamda = 0;
Ztraining = transformXtoZ_Legendre2(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein; ErrIn];
ECVal = [ECVal;ErrOut];

%LEGENDRE REGRESSION of order 3
lamda = 0;
Ztraining = transformXtoZ_Legendre3(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal ;ErrOut];

%LEGENDRE REGRESSION of order 4
lamda = 0;
Ztraining = transformXtoZ_Legendre4(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal; ErrOut];

%LEGENDRE REGRESSION of order 5
lamda = 0;
Ztraining = transformXtoZ_Legendre5(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal; ErrOut];

%LEGENDRE REGRESSION of order 6
lamda = 0;
Ztraining = transformXtoZ_Legendre6(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal; ErrOut];


%LEGENDRE REGRESSION of order 10
lamda = 0;
Ztraining = transformXtoZ_Legendre10(Xtraining);
[g,dummy,ErrOut] = vFoldCrossValidation(Ztraining,yTraining,lamda);
[dummy1,ErrIn,dummy2] = linReg(Ztraining,yTraining,lamda);
Ein = [Ein ;ErrIn];
ECVal = [ECVal; ErrOut];



%{
%This model is an overkill, it applies the F2(x) transformation
%twice (by feeding back the Ztraining into the input of F2(x)), hence
%giving a mapping to 4th dimensional space with all linear 
%and quadratic combinations and their inbetween combinations considered.
lamda = 0;
Ztraining = NonLinearCorrelations(Xtraining);
ZZtraining = NonLinearCorrelations(Ztraining);
disp('Overkill Model results:')
[g,dummy,ErrOut] = vFoldCrossValidation(ZZtraining,yTraining,lamda)
%}

concatArrays = [ Ein ECVal]; 
%Present collected results with a table
Results_No_Regularization = array2table(concatArrays);
Results_No_Regularization.Properties.VariableNames = {'Ein','ECV'};
Results_No_Regularization.Properties.RowNames = {'SimpleLinReg','F2','Simple2ndOrderTransf','Simple3rdOrderTransf','Simple6thtOrderTransf','Legendre2','Legendre3','Legendre4','Legendre5','Legendre6','Legendre10'};
Results_No_Regularization

disp('Regularization is now introduced')


%REGULARIZATION INTRODUCED

%The next section applies regularization to all models considered above.
%It has been commented-out to speed up the algorithm because it is not
%needed anymore. Why? Because I observed the results and decided that even
%with regularization, it is pointless to consider transformations of 4th
%order and above. Therefore, by commenting-out the high order transformations I can
%use smaller lamda values (less regularization needed) and obtain plots
%that will be more zoomed in smaller values of lamda which will make them
%more easy to understand and use.
%If the examiner wants to see the intermediate graphs that led me to the
%decision to cut off the high order transformations they can 
%un-comment the section and run the code normally!

%{

%This creates an array "L" which contains lamdas to give to the
%function that tries to minimize ECV
L = [];
lamda = 0.0001;
for i = 1:8
    lamda = lamda * 10;
    for j = 1:9
        zeta = lamda * j;
        L = [L zeta];
    end
end

lamdaArray=[];
ECV = [];
%LINEAR REGRESSION
Ztraining = Xtraining;
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'LinReg');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%NON-LINEAR TRANSFORMATION REGRESSION of F2(x)
%Mapping performed
%(1,x1,x2...x11) -> (1,x1,x1^2,x1x2,x1x3,...x1x11,x2,x2^2,x2x3...x11^2)
Ztraining = NonLinearCorrelations(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'F2(x)');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%2nd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x2,x2^2...x11^2)
Ztraining = nthOrderTransform(Xtraining,2);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'2ndOrderSimpleTransf');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%3rd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x1^3,x2,x2^2,x2^3...x11^3)
Ztraining = nthOrderTransform(Xtraining,3);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'3rdOrderSimpleTransf');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 2
%Using transformation based on Legendre Polynomials up to order 2
Ztraining = transformXtoZ_Legendre2(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre2');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 3
Ztraining = transformXtoZ_Legendre3(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre3');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 4
Ztraining = transformXtoZ_Legendre4(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre4');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 5
Ztraining = transformXtoZ_Legendre5(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre5');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 6
Ztraining = transformXtoZ_Legendre6(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre6');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 10
Ztraining = transformXtoZ_Legendre10(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre10');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

totalArray = [ECV lamdaArray];
%Present collected results with a table
Results_With_Regularization = array2table(totalArray);
Results_With_Regularization.Properties.VariableNames = {'ECV','lamda'};
Results_With_Regularization.Properties.RowNames = {'SimpleLinReg','F2','2ndOrderSimpleTransf','3rdOrderSimpleTransf','Legendre2','Legendre3','Legendre4','Legendre5','Legendre6','Legendre10'};
Results_With_Regularization
%}

disp('Noticing that Leg6 and Legendre10 are not worth even plotting...')
disp('We will now exclude them and focus on smaller lamda values!')

%REGULARIZATION OF LOW ORDER MODELS


lamdaArray=[];
ECV = [];
totalArray= [];
%This creates an array "L" which contains lamdas to give to the
%function that tries to minimize ECV
L = [];
lamda = 0.0001;
for i = 1:4
    lamda = lamda * 10;
    for j = 1:19
        zeta = lamda * j/2;
        L = [L zeta];
    end
end

lamdaArray=[];
ECV = [];
%LINEAR REGRESSION
Ztraining = Xtraining;
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'LinReg');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];


%{
%NON-LINEAR TRANSFORMATION REGRESSION of F2(x)
%Notice that F2(x) does not use L but lamda, because it needs a bigger
%lamda than the other models and I didn't want to disturb the other models'
%graphs by increasing the values of L
lamda = 10:1:1000;
%Mapping performed
%(1,x1,x2...x11) -> (1,x1,x1^2,x1x2,x1x3,...x1x11,x2,x2^2,x2x3...x11^2)
Ztraining = NonLinearCorrelations(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,lamda,'F2(x)');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];
%}

%2nd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x2,x2^2...x11^2)
Ztraining = nthOrderTransform(Xtraining,2);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'2ndOrderSimpleTransf');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%3rd Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x1^3,x2,x2^2,x2^3...x11^3)
Ztraining = nthOrderTransform(Xtraining,3);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'3rdOrderSimpleTransf');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 2
%Using transformation based on Legendre Polynomials up to order 2
Ztraining = transformXtoZ_Legendre2(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre2');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 3
Ztraining = transformXtoZ_Legendre3(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,L,'Legendre3');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

title('Regularization for different models');
legend('SimpleLinReg','2ndOrderSimpleTransf','3rdOrderSimpleTransf','Legendre2','Legendre3','Location','Best');

figure

%NON-LINEAR TRANSFORMATION REGRESSION of F2(x)
%Notice that F2(x) does not use L but lamda, because it needs a bigger
%lamda than the other models and I didn't want to disturb the other models'
%graphs by increasing the values of L
lamda = 10:1:1000;
%Mapping performed
%(1,x1,x2...x11) -> (1,x1,x1^2,x1x2,x1x3,...x1x11,x2,x2^2,x2x3...x11^2)
Ztraining = NonLinearCorrelations(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,lamda,'F2(x)');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

figure 

lamda = 1:10:100;
%4th Order Transform
%Using simple mapping (1,x1,x2...) -> (1,x1,x1^2,x1^3,x2,x2^2,x2^3...x11^3)
Ztraining = nthOrderTransform(Xtraining,4);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,lamda,'4thOrderSimpleTransf');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

%LEGENDRE REGRESSION of order 4
Ztraining = transformXtoZ_Legendre4(Xtraining);
[lamdaMin,ECVmin] = minimizeECV(Ztraining,yTraining,lamda,'Legendre4');
lamdaArray = [lamdaArray;lamdaMin];
ECV = [ECV ; ECVmin];

title('Regularization for different models');
legend('4thOrderSimpleTransf','Legendre4','Location','Best');



totalArray = [ECV lamdaArray];
Regularization = array2table(totalArray);
Regularization.Properties.VariableNames = {'ECV','lamda'};
Regularization.Properties.RowNames = {'SimpleLinReg','2ndOrderSimpleTransf','3rdOrderSimpleTransf','Legendre2','Legendre3','F2(x)','4thOrderSimpleTransf','Legendre4'};
Regularization


%Only uncomment this section if you want to also see SVM results
%NB: This function takes an average of 15 MINUTES to compute!!
%svm()

disp('Finally, the best hypothesis (Legendre2) test error is:')

%give lamda optimum 
lamdaOpt = 0.35;
%perform transformation to training data
Ztraining = transformXtoZ_Legendre2(Xtraining);
%obtain weights
[g,ErrIn,ErrCv] = linReg(Ztraining,yTraining,lamdaOpt);

%Calculate test error using g(best hypothesis)
%First, perform transformation to test data
Ztesting = transformXtoZ_Legendre2(Xtesting);
ErrorVector = Ztesting*g - yTesting;
TotalError = norm(ErrorVector) ^ 2;
TestError = 1/(length(yTesting)) * TotalError

toc
