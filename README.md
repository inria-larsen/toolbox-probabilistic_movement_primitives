# toolbox-probabilistic_movement_primitives
This toolbox allow (1) to learn the distribution of any kind of trajectories (i.e. data input that evolved in time) (2) to infer the end of an initiate trajectory, thanks to the learned distribution. 

#INFO 
This toolbox is inspired by the one from this [one](https://github.com/marcoewerton/Learning_Motor_Skills_from_Partially_Observed_Movements_Executed_at_Different_Speeds)
The change is to allow to use the toolbox for any kind of trajectory, and for any “kind of data” we want that have any dimension we want.
Please, do not hesitate to contact [me](oriane.dermy@gmail.com) if you have any problem, remarks, or some idea of improvement, with subject [proMPs_toolbox].

# PARAMETERS  
To use it, in the function proMPS_toolbox has some parameters:  

- *nameD{x}*: You have to write here the path from the Matlab directory to your data files (e.g. 'Data/test2.txt')
- *z*: It is the reference velocity of the movement (e.g. the supposed number of iteration of a trajectory).
- *nbData*: it is the number max of iteration you allow to do the recognition of the movement.

- *NbDof*: It is a table  whose dimension corresponds to the number of «kind of data» you have, and the value of each cell corresponds to the dimension of each kind of data.
For example in the given example, we learn Cartesian position (3D) and forces (3D): nbDof = [3,3].
- *accuracy*: this variable represents how much you want to stay close to the learned distribution (compromise between the learned distribution ( accuracy  close to 1) and the new initiate trajectory (I use the smaller possible number accuracy = 0.00000005 ).

## Information bout the basis function you use to represent the trajectory other time: 
- *nbFunctions*: This table corresponds to the number of functions you use to represent each «kind of data». Thus, like NbDof, its dimension corresponds to the number of «kind of data».  
How to chose this number : Less your trajectory is smooth, more you will need functions.  
For example, in the given example, the forces information are less smooth than Cartesian position information. Thus, we use more functions to represent the forces: nbFunctions = [11, 21];  
- *center\_gaussian*: this variable is used to sparse the basis functions in time. It is computed thanks to the formula center\_gaussianx(nbFunctions-1) = 1.
In the given example we have center_gaussian = [0.1 , 0.05]
- *h*: it is the bandwidth of the Gaussians. The computation is done from the formula: center_gaussian*6*(1/z) to have neightboor basis functions that are a little intersecting each other.

