#!/bin/bash
#SBATCH -o somd-array-gpu-%A.%a.out
#SBATCH -p main
#SBATCH -n 1
#SBATCH --gres=gpu:1
#SBATCH --time 24:00:00
#SBATCH --array=0-14

#module load cuda/7.5

echo "CUDA DEVICES:" $CUDA_VISIBLE_DEVICES

lamvals=( 0.000 0.071 0.143 0.214 0.286 0.357 0.429 0.500 0.571 0.643 0.714 0.786 0.857 0.929 1.000 )
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

