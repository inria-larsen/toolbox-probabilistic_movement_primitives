%in this function, we try to recongize a movement from the 30 first data
%and to complete it.
%TO do that, we consider the phasis of the movement as the mean of the
%phasis used during the learning.

%variable tuned to achieve the trajectory correctly

%accuracy that we want : choose randomly
text= ['Give the test you want to do (from 1 to ' num2str(nbKindOfTraj) ')'];
trial = input(text);
disp(['we try the number ', num2str(trial)])


%computation of the loglikelihood for each trajectory using only cartesian
%coordinates
typeReco = 1; %what kind of dof we use for the reco
vr = 0;
prevDof = 0;
for j=1:typeReco-1
    vr = vr + nbDof(j)*nbFunctions(j);
    prevDof = prevDof + nbDof(j); 

end
%we cut the mu_w to correspond only to the cartesian position informaiton
for i=1:nbKindOfTraj
    mu_w_reco{i} = mu_w{i}(vr + 1 : vr + nbDof(typeReco)*nbFunctions(typeReco));
  %  mu_w_f{i} = mu_w{i}(nbDof(1)*nbFunctions(1)+1:nbDof(1)*nbFunctions(1)+nbDof(2)*nbFunctions(2));
    sigma_w_reco{i} = sigma_w{i}(vr + 1 : nbDof(typeReco)*nbFunctions(typeReco),vr + 1:nbDof(typeReco)*nbFunctions(typeReco));
end


% we compute for each learned distribution the loglikelihood that this
% movement correspond to the distribution
reco = {0 , 0.0, 0 }; %{trajectory recognized, probability, timestep} of the best likelihood
for t=5:nbData
    for i=1:nbKindOfTraj
        %matrix of cartesian basis functions that correspond to the first nbData 
        PSI_reco{t}{i} = computeBasisFunction(z,nbFunctions(typeReco), nbDof(typeReco), mu_alpha(i), floor(z/mu_alpha(i)), center_gaussian(typeReco), h(typeReco),t);
        
        %matrix of forces basis functions that correspond to the first nbData
        %PSI_forces{t}{i} = computeBasisFunction(z,nbFunctions(2), nbDof(2), mu_alpha(i), floor(z/mu_alpha(i)), center_gaussian(2), h(2), t);
        %matrix of basis functions for all data that correspond to the first
        %nbData
        PSI_tot{t}{i} = computeBasisFunction(z,nbFunctions, nbDof, mu_alpha(i), floor(z/mu_alpha(i)), center_gaussian, h,t);

        %we retrieve the learned trajectory of cartesian position
        u{t}{i} = PSI_reco{t}{i}*mu_w_reco{i};
        sigma{t}{i} = PSI_reco{t}{i}*sigma_w_reco{i}*PSI_reco{t}{i}' + accuracy*eye(size(PSI_reco{t}{i}*sigma_w_reco{i}*PSI_reco{t}{i}'));
        
        %we compute the probability it correspond to the actual trial
        y_trial_part{t} = [];
        for k=1:nbDof(typeReco)
           y_trial_part{t} = [y_trial_part{t} ; y_trial_Tot{trial}(totalTimeTrial(trial)*(prevDof+k -1) + 1 : totalTimeTrial(trial)*(prevDof+k -1) + t)];
        end
        prob(i,t)= logLikelihood(y_trial_part{t}',u{t}{i}',sigma{t}{i});

        %we record the max of probability to know wich distribution we
        %recognize
        if(prob(i,t) > reco{2})
            reco{2} = prob(i,t);
            reco{1} = i;
            reco{3} = t;
        end

    end
end
disp(['The recognize trajectory is the number ', num2str(reco{1})])

figure;
for i=1:nbKindOfTraj
    plot(prob(i,:), 'col', [ 1 - (i/nbKindOfTraj), i/nbKindOfTraj , (0.5*i)/nbKindOfTraj]);hold on
end
title(['log likelihood according to time'])
xlabel('iterations')
ylabel('log likelihood')
%legend('other movement', 'other movement', 'Movement that correspond');
%we retrieve the computed distribution that correspond to the recognized
%trajctory
mu_new = mu_w{reco{1}};
sigma_new = sigma_w{reco{1}}; 

%we complete the data with the supposed forces correlated to the movement
%according to the learned trajectory
y_prev = [];
for i=1:prevDof
    y_prev  = [y_prev ; y_trial_Tot{trial}(totalTimeTrial(trial)*(i -1) + 1 : totalTimeTrial(trial)*(i -1) + t)];
end

y_after = [];
for i= (1 + prevDof + nbDof(typeReco)): nbDofTot
   y_after = [y_after;  y_trial_Tot{trial}(totalTimeTrial(trial)*(i -1) + 1 : totalTimeTrial(trial)*(i -1) + t)];   
end
y_trial_nbData =[y_prev ; y_trial_part{reco{3}}; y_after ]; 

%we aren't suppose to know "realData",  it is only used to draw the real
%trajectory of the sample if we continue it to the end
realAlpha = z /totalTimeTrial(reco{1});
display(['The real alpha is ', num2str(realAlpha), ' with total time : ', num2str(totalTimeTrial(reco{1})) ])
display(['The supposed alpha is ', num2str(mu_alpha(reco{1})), ' with total time : ', num2str(z / mu_alpha(reco{1})) ])


%we need to have the psi matrix and vector value according to time to
%update the distribution (just a rewriting of data to simplify the next
%computation.
vr=0;
for j=1:typeReco-1
    vr = vr + nbDof(j);
end
for t=1:reco{3}
    for i=vr + 1: vr + nbDof(typeReco)
        PSI_update{t}(i,:) = PSI_tot{reco{3}}{reco{1}}(t + reco{3}*(i-1),:);
        ynew{t}(i) = y_trial_nbData(t + reco{3}*(i-1)) ;
    end
end

% compute the new distribution (we try to pass by via point that correspond
% to the fist nbData, with an accuracy tuned at the begining)
for t=1:reco{3}     
    K = sigma_new*PSI_update{t}' * inv(accuracy*eye(size(PSI_update{t}*sigma_new*PSI_update{t}')) + PSI_update{t}*sigma_new*PSI_update{t}');
    mu_new = mu_new + K* (ynew{t}' - PSI_update{t}*mu_new);
    sigma_new = sigma_new - K*(PSI_update{t}*sigma_new);
end

%%%%%%%%%%%%%%%%%%%%%%%%REPRESENTATION (plot)%%%%%%%%%%%%%%%
%Plot the total trial and the data we have
nameFig = figure;
i = reco{1};

for t=1:reco{3}
       nameFig(t) = scatter(t*realAlpha, y_trial_nbData((i-1)*reco{3} + t), '.b'); hold on;       
end
nameFig = visualisation2(y_trial_Tot{reco{1}}, nbDofTot, totalTimeTrial(reco{1}), i, ':b', realAlpha, nameFig);
%draw the infered movement
nameFig = visualisation(PSI_z*mu_new, nbDofTot, z, i, '+g', nameFig);
nameFig = visualisation(PSI_z*mu_w{i}, nbDofTot, z, i,'r', nameFig);
nameFig = visualisation(PSI_z*(mu_w{i} + 1.96*sqrt(diag(sigma_w{i}))), nbDofTot, z,i, '-.r', nameFig);
nameFig = visualisation(PSI_z*(mu_w{i}- 1.96*sqrt(diag(sigma_w{i}))), nbDofTot, z, i, '-.r', nameFig);
legend(nameFig([1 (nbData+1) (nbData +2) (nbData +3) ]),'Data known', 'Data we should have', 'Data deducted', 'Learned distribution');
name2 = trial + 'th DOF';

title(['Recognition of the', trial, 'th trajectory ']);
xlabel('Iterations');
ylabel(name2);

%draw the infered movement 3D
name3D = figure;
for t=1:reco{3}
       name3D(t) = scatter3(y_trial_nbData(prevDof*reco{3} + t), y_trial_nbData((prevDof+1)*reco{3} + t), y_trial_nbData((prevDof+2)*reco{3} + t), '.b'); hold on;
end
name3D = visualisation3D(y_trial_Tot{reco{1}}, nbDofTot, totalTimeTrial(reco{1}),1, nbDof, ':b', name3D);hold on;

i = reco{1};
name3D = visualisation3D(PSI_z*mu_new, nbDofTot, z, 1, nbDof, '+g', name3D);
name3D = visualisation3D(PSI_z*mu_w{i}, nbDofTot, z, 1, nbDof, '.r', name3D);
name3D = visualisation3D(PSI_z*(mu_w{i} + 1.96*sqrt(diag(sigma_w{i}))), nbDofTot, z, 1, nbDof, '-.r', name3D);
name3D = visualisation3D(PSI_z*(mu_w{i}- 1.96*sqrt(diag(sigma_w{i}))), nbDofTot, z, 1, nbDof, '-.r', name3D);
legend(name3D([1 (reco{3}+1) (reco{3} +2) (reco{3} +3) ]),'Data known', 'Data we should have', 'Data deducted', 'Learned distribution');

title(['Position recognition of the ', trial ,'th trajectory'])
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');




clear mu_w_coord mu_w_f sigma_w_coord PSI_coor PSI_forces PSI_mean u sigma prob reco mu_n sigma_n y_trial_nbData realAlpha PSI_update ynew K mu_new sigma_new
