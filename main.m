clear;
clc;

global Price_da_train;
global Pro_da_train;
global Price_rt_train;
global Price_da_test;
global Price_rt_test;
global DC_choose;
global C;
global N;

N=3;
DC_choose(1)=3;
DC_choose(2)=2;
DC_choose(3)=1;

C{DC_choose(1)}=35;
C{DC_choose(2)}=20;
C{DC_choose(3)}=10;

Price_da_train{DC_choose(1)}=xlsread('Data/Train/NYISO_Train.xlsx','D2:D9601');
Pro_da_train{DC_choose(1)}=xlsread('Data/Train/NYISO_Train.xlsx','E2:E9601');
Price_rt_train{DC_choose(1)}=xlsread('Data/Train/NYISO_Train.xlsx','G2:G25');
Price_da_train{DC_choose(2)}=xlsread('Data/Train/ALDENE_Train.xlsx','D2:D9601');
Pro_da_train{DC_choose(2)}=xlsread('Data/Train/ALDENE_Train.xlsx','E2:E9601');
Price_rt_train{DC_choose(2)}=xlsread('Data/Train/ALDENE_Train.xlsx','G2:G25');
Price_da_train{DC_choose(3)}=xlsread('Data/Train/Denmark_Train.xlsx','B2:B9601');
Pro_da_train{DC_choose(3)}=xlsread('Data/Train/Denmark_Train.xlsx','C2:C9601');
Price_rt_train{DC_choose(3)}=xlsread('Data/Train/Denmark_Train.xlsx','E2:E25');

[Alpha_h,Beta_h,Gama_h]=costtogo('Log=true');

Price_da_test{DC_choose(1)}=xlsread('Data/Test/NYISO_Test.xlsx','B2:B697');
Price_rt_test{DC_choose(1)}=xlsread('Data/Test/NYISO_Test.xlsx','C2:C697');
Price_da_test{DC_choose(2)}=xlsread('Data/Test/PJM_Test.xlsx','B2:B697');
Price_rt_test{DC_choose(2)}=xlsread('Data/Test/PJM_Test.xlsx','C2:C697');
Price_da_test{DC_choose(3)}=xlsread('Data/Test/Denmark_Test.xlsx','D2:D697');
Price_rt_test{DC_choose(3)}=xlsread('Data/Test/Denmark_Test.xlsx','E2:E697');
load('Data/Test/workload.mat');

SC=schemeSC(Alpha_h,Gama_h,workload);
[Baseline,Bid,RT,BidGLB]=schemeComp(workload);

fprintf('In this case, the average cost of SC is %f\n',SC);
fprintf('The average cost of the comparison scheme is:\n');
fprintf('Baseline: %f  Bid: %f  RT: %f  BidGLB: %f \n',Baseline,Bid,RT,BidGLB);
fprintf('The detail of the cost-to-go function is stored in Costtogo_Log\n');
fprintf('If you want to know more about the algorithm, you can visit at https://github.com/wtligit/Second-Chance\n');