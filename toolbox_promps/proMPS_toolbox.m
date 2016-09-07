%This toolbox allow (1) to learn the distribution of any kind of trajectories (i.e. data input that evolved in time) (2) to infer the end of an initiate trajectory, thanks to the learned distribution.
%by Oriane Dermy 07/09/2016
% For any problem / remark / improvement, contact me:
% oriane.dermy@gmail.com with subject [proMPs_toolbox]

close all;
clear all;

%%%VARIABLES, please refer you to the readme

nbKindOfTraj = 3;
nameD{1} = 'Data/dataAhead.txt';
nameD{2} = 'Data/dataTop.txt';
nameD{3} = 'Data/dataRight.txt';
z = 100; %total time after modulation
nbData = 60; %30;%floor(2*z /3); %number of data max with what you try to find the correct movement
nbDof(1) = 3; %number of degree of freedom
nbDof(2) = 3; %number of forces
nbFunctions(1) = 11; %number of basis functions
nbFunctions(2) = 21; %number of basis functions for forces
center_gaussian(1) = 1.0 / (nbFunctions(1)-1);
center_gaussian(2) = 1.0 / (nbFunctions(2)-1);
h(1) = center_gaussian(1)*6*(1/z); %0.006; %bandwidth of the gaussians
h(2) = center_gaussian(1)*6*(1/z);%0.003;
accuracy = 0.00000005; %precision we want during inference

%%%COMPUTATIONS

%we define also the variables nbKindOfTraj, var, totalTime
recoverData;

%compute the distribution for each kind of trajectories.
%we define var and TotalTime in this function
%here we need to define the bandwith of the gaussians h
computeDistributions;

%Recognition of the movement
inference;