#!/bin/bash
#SBATCH -o somd-array-gpu-%A.%a.out
#SBATCH -p main
#SBATCH -n 1
#SBATCH --gres=gpu:1
#SBATCH --time 24:00:00
#SBATCH --array=0-40

#module load cuda/7.5

echo "CUDA DEVICES:" $CUDA_VISIBLE_DEVICES

lamvals=( 0.000 0.025 0.050 0.075 0.100 0.125 0.150 0.175 0.200 0.225 0.250 0.275 0.300 0.325 0.350 0.375 0.400 0.425 0.450 0.475 0.500 0.525 0.550 0.575 0.600 0.625 0.650 0.675 0.700 0.725 0.750 0.775 0.800 0.825 0.850 0.875 0.900 0.925 0.950 0.975 1.000 )
lam=${lamvals[SLURM_ARRAY_TASK_ID]}

if [ "$SLURM_ARRAY_TASK_ID" -eq "0" ]
then
    cat ../input/distres >> ../input/sim.cfg
fi

sleep 5

echo "lambda is: " $lam

mkdir lambda-$lam
cd lambda-$lam

export OPENMM_PLUGIN_DIR=/home/finlayclark/anaconda3/envs/biosimspace-dev/lib/plugins/

srun /home/finlayclark/anaconda3/envs/biosimspace-dev/bin/somd-freenrg -C ../../input/sim.cfg -l $lam -p CUDA
cd ..

wait

#if [ "$SLURM_ARRAY_TASK_ID" -eq "25" ]
#then
   # sleep 30
   # sbatch ../ljcor.sh
   # sleep 30 
   # sbatch ../standardstate.sh
   # sleep 30 
   # sbatch ../mbar.sh
#fi

