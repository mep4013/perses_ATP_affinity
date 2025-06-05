#!/usr/bin/env bash
#SBATCH --time=2:00:00
#SBATCH --output=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/run_equil_apo.out
#SBATCH --error=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/run_equil_apo.stderr
#SBATCH --partition=gpushort
#SBATCH -n 1
#SBATCH --mem-per-cpu=3G
#SBATCH --gpus=1
#SBATCH --job-name=inputs.0

script_directory_path=/data1/choderaj/pathilm/FEC/abl/scripts
root_output_directory=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium
perses_env_name=perses

outdir=$root_output_directory
phase=apo

source ~/.bashrc
conda activate $perses_env_name

cd $script_directory_path
python run_equilibration.py $outdir $phase