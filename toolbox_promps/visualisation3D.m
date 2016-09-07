% Function that plot the matrix with the color col1. x is the number of line of the
% matrix, y the number of colonnes, type is the reference of the kind of data you want to plot, nameFig is the fig

function y = visualisation3D(matrix, x, y, type, nbDof, col1, nameFig)

tall= size(nameFig,2);
for i=1:x
    for j=1:y
        val(i,j) = matrix(y*(i-1)+j);
    end
end

nb=0;
for cpt =1:type-1
    nb = nb + nbDof(cpt);
end
if(isa(col1, 'char'))
       nameFig(tall + 1 ) = plot3(val(nb + 1,:) ,val(nb + 2,:),val(nb + 3,:), col1); hold on;
else
      nameFig(tall+ 1) = plot3(val(nb + 1,:) ,val(nb + 2,:),val(nb + 3,:), 'Color', col1); hold on;
end


 y = nameFig;
end