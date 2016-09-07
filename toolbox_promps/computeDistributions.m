% In this part, we compute the distribution for each kind of trajectories.

for i=1:nbKindOfTraj
   
    for j = 1:var(i)
        %we compute the phasis
        alpha{i}(j) = z / totalTime(i,j);
        %we compute the corresponding PSI matrix
        PSI{i}{j} = computeBasisFunction (z,nbFunctions, nbDof, alpha{i}(j), totalTime(i,j), center_gaussian, h, totalTime(i,j));
    end
    mu_alpha(i) = mean(alpha{i});
    sigma_alpha(i) = cov(alpha{i});
    min_alpha_i(i) = min(alpha{i});
    max_alpha_i(i) = max(alpha{i});
end
min_alpha = min(min_alpha_i(i));
max_alpha = max(max_alpha_i(i));

PSI_z = computeBasisFunction (z,nbFunctions,nbDof, 1, z,center_gaussian,h, z);

%w computation for each trials
%figure;
for i = 1 : nbKindOfTraj
    val = 0;
    for cpt =1:size(nbDof,2)
        val = val + nbDof(cpt)*nbFunctions(cpt);
    end
    test = zeros(var(i),val);
    
    
    for j = 1 : var(i)
        %resolve a little bug
        sizeY  = size(y{i}{j},1);
        if(sizeY ~= size(PSI{i}{j},1))
            y{i}{j} = y{i}{j}(1:sizeY-(nbDof(1)+nbDof(2)));
            totalTime(i,j) = totalTime(i,j) -nbDofTot;
            alpha{i}(j) = z /totalTime(i,j);
        end

        w{i}(j,:) = (PSI{i}{j}'*PSI{i}{j}+1e-6*eye(val)) \ PSI{i}{j}' * y{i}{j};        
        test(j,:) =w{i}(j,:); 
    end
        
    %computation of the w distribution     
    mu_w{i} = mean(test)';
    sigma_w{i} = cov(test);

   
       nf3D = figure;           
     % Plot3D the learned distribution 
   for type=1:size(nbDof,2)

       nf3D = visualisation3D(PSI_z*mu_w{i}, nbDofTot, z, type, nbDof, 'r', nf3D); hold on;
       nf3D = visualisation3D(PSI_z*(mu_w{i} + 1.96*sqrt(diag(sigma_w{i}))), nbDofTot, z,type, nbDof, '-.g', nf3D);
       nf3D = visualisation3D(PSI_z*(mu_w{i}- 1.96*sqrt(diag(sigma_w{i}))),nbDofTot, z,type, nbDof, '-.g', nf3D);
       for j=1:var(i)
           nf3D = visualisation3D(y{i}{j},nbDofTot, totalTime(i,j), type, nbDof, 'b', nf3D);
       end 
        
        title(['learned distribution for the' num2str(type) 'type of DOF of the' num2str(i) 'th trajectory' ]);%strcat('learned distribution for the', atostr(i), ' trajectory');
        
        xlabel('1')
        ylabel('2')
        zlabel('3')
       legend(nf3D([2 4 5]),'Distribution Learned','Standard deviation','Data'); 
   end

   
end
    clear i j test w PSI min_alpha_i max_alpha_i cpt nf3D sizeY type val;
