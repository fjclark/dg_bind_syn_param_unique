#!/bin/bash
#SBATCH -o standardstate-%A.%a.out
#SBATCH -p main
#SBATCH -n 1
#SBATCH --time 24:00:00

sleep 30 

cd lambda-1.000

srun /home/finlayclark/anaconda3/envs/biosimspace-dev/bin/standardstatecorrection -C ../../input/sim.cfg -r traj000000001.dcd -s 1 -b 4 -d 0.25 -o 60 > ../standard-state-s-1-b-4-d-0.25-o-60.dat

cd ..

wait


