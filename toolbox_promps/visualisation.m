% Function that plot the matrix with the color col1. x is the line of the
% matrix, y the number of colonnes

function y = visualisation(matrix, x,y, z, col1, nameFig)

tall = size(nameFig,2);
for i=1:x
    for j=1:y
        val(i,j) = matrix(y*(i-1)+j);
    end
end


if(isa(col1, 'char'))
    %for i=1:x
     i=z;
       nameFig(tall + 1) = plot(val(i,:), col1); hold on;
    %end
else
    %for i=1:x 
     i=z;
      nameFig(tall + 1) = plot(val(i,:), 'Color', col1); hold on;
    %end
end
 y = nameFig;
end