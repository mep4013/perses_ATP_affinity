#!/usr/bin/env bash

#SBATCH --partition=gpushort
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64G
#SBATCH --ntasks-per-node=1
#SBATCH --gpus=1

HTF_DIRECTORY=/data1/choderaj/pathilm/FEC/abl/2_HTFs
NEQ_DIRECTORY=/data1/choderaj/pathilm/FEC/abl/3_NEQ

script_directory_path=/data1/choderaj/pathilm/FEC/abl/scripts
perses_env_name=perses

source ~/.bashrc
conda activate $perses_env_name

cd $script_directory_path
python run_neq_complex.py -i $HTF_DIRECTORY/$MUTATION -o $NEQ_DIRECTORY/$MUTATION -p $PHASE -c $SLURM_ARRAY_TASK_ID
