% Function that plot the matrix with the color col1. x is the number of line of the
% matrix, y the number of colonnes, bool=1 if we want forces, 0 if we want
% cartesian position, col1 is the color of the fig, nameFig is the fig

function y = visualisation3D2(matrix, , y, type, col1, alpha, nameFig)

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
sizeV = size(val, 2);

    if(isa(col1, 'char'))
           nameFig(tall + 1 ) = plot3(val(nb + 1,1:alpha:sizeV), val(nb + 2,1:alpha:sizeV),val(nb + 3,1:alpha:sizeV), col1); hold on;
    else
          nameFig(tall+ 1) = plot3( val(nb + 1,1:alpha:sizeV), val(nb + 2,1:alpha:sizeV),val(nb + 3,1:alpha:sizeV), 'Color', col1); hold on;
    end

 y = nameFig;
end
