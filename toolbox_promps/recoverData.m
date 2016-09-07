%%%%%%%%%%%%%%%%%%%%%%%%%%%% Recover the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for i=1:nbKindOfTraj
% %we open the files
f(i) = fopen(nameD{i}, 'r');

% we scan the files line per line
X{i} = textscan(f(i), '%s', 'delimiter', '\n');

%we close the files
fclose(f(i));

%we put data in vectors as numbers
X{i} = cellfun(@str2num, X{i}{1}, 'UniformOutput', false);

%we compute the number of block (delimited by a carriage return) and we put
%data in the vector B.
numBlock = 1;
numLine = 0;
for n = 1:size(X{i}, 1)
 
    if isempty(X{i}{n})
        numBlock = numBlock + 1;
        numLine = 0;
    else
        numLine = numLine+1;
        data{i}{numBlock}(numLine,:) = X{i}{n}; 
    end
 
end

end
clear f numBlock numLine n X ans nameD
% load('dataTotal2.mat');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Create the y vector  and other usefull variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
nbDofTot = size(data{1}{1},2);
%a = 1;
%v = [1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10];
namf = figure;
affich=1; %what we want to plot  (x y z fx fy fz))

% % We keep the last sample to try to recognize the movement
for k=1:nbKindOfTraj
    var(k) = size(data{k},2) - 1;
    % totalTime will be the number of time of each trajectories, to begin with it is the same as the totalTime
    % y is the input vector of data
    for i=1:var(k)
        y{k}{i} = [];
        for j = 1:nbDofTot
           y{k}{i}=  [ y{k}{i} ; data{k}{i}(:,j) ];% data{k}{i}(:,2); data{k}{i}(:,3); filter(v,a,data{k}{i}(:,4)) ; filter(v,a,data{k}{i}(:,5)); filter(v,a,data{k}{i}(:,6))];
        end
        totalTime(k,i) = size(data{k}{i},1);
        
        namf = visualisation(y{k}{i}, nbDofTot, totalTime(k,i), affich, [k/nbKindOfTraj, 1 - (k/nbKindOfTraj),0.5*(k/nbKindOfTraj)], namf);hold on; %we draw only the first DOF because too much data  
    end 
end


%Information about the previous plot that represent each sample of each
%trajectory
if(affich ==1) namePlot = ('x');
elseif(affich ==2) namePlot = ('y');
elseif(affich ==3) namePlot = ('z');
elseif(affich ==4) namePlot = ('fx');
elseif(affich ==5) namePlot = ('fy');
else namePlot = ('fz');
end
title('Trajectories used to learn');
xlabel('time');
ylabel(namePlot);
%legend(namf([2 (var(1)+2) (var(1) + var(2) + 2)]),'Right','Ahead','Top');

% 
% 
% %TRIAL DATA
% %we keep the last sample of each trajectory to see if we recognize
% %correctly the last movement
for k=1:nbKindOfTraj
 i = size(data{k},2);
 totalTimeTrial(k) = size(data{k}{i},1); %if we continue the movement to the end
 y_trial_Tot{k} = [];
 for j=1:nbDofTot
    y_trial_Tot{k} =  [ y_trial_Tot{k} ; data{k}{i}(:,j)] ; %data{k}{i}(:,2); data{k}{i}(:,3); data{k}{i}(:,4) ; data{k}{i}(:,5); data{k}{i}(:,6)];
 end
end

% Plot the trials we will use to verify the learning
name = figure;
for k=1:nbKindOfTraj
name = visualisation(y_trial_Tot{k}, nbDofTot, totalTimeTrial(k),affich, [(nbKindOfTraj-k)/nbKindOfTraj, k/nbKindOfTraj,0.5*(k/nbKindOfTraj)], name);hold on;
end
title('Trial we keep to try the recognition step (one for each kind of trajectory)');
xlabel('Iterations');
ylabel(namePlot);


% % %%%%%%%%%%%%%%%%%%%3D REPRESENTATION
% 
%plot 3D data
 nam2 = figure;
for j=1:size(nbDof,1)
 for k=1:nbKindOfTraj
 	for i=1:var(k)
        nam2 = visualisation3D(y{k}{i}, nbDofTot, totalTime(k,i), 1, nbDof, [(nbKindOfTraj-k)/nbKindOfTraj, k/nbKindOfTraj,0.5*(k/nbKindOfTraj)], nam2);
        nam2 = visualisation3D(y_trial_Tot{k}, nbDofTot, totalTimeTrial(k), 1, nbDof,  ':b', nam2);
    end
 end
 name = ['Trajectories type ' num2str(j) ' used to learn'];
title(name)
xlabel('1')
ylabel('2')
zlabel('3')
end

%plot 3D trials
nam4 = figure;
for k =1 : nbKindOfTraj
    nam4 = visualisation3D(y_trial_Tot{k}, nbDofTot, totalTimeTrial(k), 1, nbDof, [(nbKindOfTraj-k)/nbKindOfTraj, k/nbKindOfTraj,0.5*(k/nbKindOfTraj)], nam4);hold on;
end
title('Trial trajectories');
xlabel('x')
ylabel('y')
zlabel('z')


clear nam* affich data i j k;