#!/usr/bin/env bash
#SBATCH --time=15:00
#SBATCH --output=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/generate_solvated_inputs.out
#SBATCH --error=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/generate_solvated_inputs.stderr
#SBATCH --partition=gpushort
#SBATCH -n 1
#SBATCH --mem-per-cpu=3G
#SBATCH --gpus=1
#SBATCH --job-name=inputs.0

script_directory_path=/data1/choderaj/pathilm/FEC/abl/scripts
input_PDB_directory=/data1/choderaj/pathilm/FEC/abl/0_ABL_input
root_output_directory=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium
perses_env_name=perses

protein_filename=$input_PDB_directory/ABL_input_protein.pdb
outdir=$root_output_directory

source ~/.bashrc
conda activate $perses_env_name

cd $script_directory_path
python generate_solvated_inputs.py $protein_filename $outdir --padding 1.7