
# Vasculature to Permeability Simulation
This code here is designed to using fluid dynamic simulation to estimate the permeability of the vasculature structure.   

## How to use
There are 3 steps, and the reason is the simulation is very computationally heavy, thus the simulation part was designed to run on HPC with others parts can be finished on a workstation computer. 

Step 1:   Open *RUN_THIS_FILE.m* inside *001_Preparing* folder in Matlab.  Edit *dir_root* to locate your data folder. Run the file. The code will give you a *.mat* file named by your data folder. 

Step 2:   Move the *.mat* file from step 1 to desire HPC or workstation. Copy the content of *002_Voxel_CFD* to the same folder. Edit the *job_file_list* to fit your file listing. Edit and run the *RUN_THIS_FILE_slurm_batch* (Each data will be submit to 20 node, so edit the job array accordingly). Each node will save the results as a *.mat* file. 

Step 3:   Download all the *.mat* files and put them in the *003_post_processing_1_collecting* folder. Edit and run the *RUN_THIS_FILE.m*. This step will gives you a single integrated output as a *.mat*file. 



## Limitations
- This module is designed to digest outcome of the *STPT_vasculature_tracer*. 

## Environment
Matlab 2019a
elastix version 4.9.0

## Liscense
Free academic use.
