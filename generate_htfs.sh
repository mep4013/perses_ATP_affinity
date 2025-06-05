#!/usr/bin/env bash
#SBATCH --time=10:00
#SBATCH --output=/data1/choderaj/pathilm/FEC/abl/2_HTFs/generate_htfs_cpu.out
#SBATCH --error=/data1/choderaj/pathilm/FEC/abl/2_HTFs/generate_htfs_cpu.stderr
#SBATCH --partition=cpushort
#SBATCH -n 1
#SBATCH --mem-per-cpu=128G
#SBATCH --job-name=htf.0

# run with https://github.com/choderalab/perses/commit/c790a780a20367c7415a86d50879e0983456d92b
# SBATCH --gpus=1

script_directory_path=/data1/choderaj/pathilm/FEC/abl/scripts
perses_env_name=perses

PROTEIN_FILE=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/apo_equilibrated.pdb
LIGAND_FILE=/data1/choderaj/pathilm/FEC/abl/0_ABL_input/ABL_input_ligand.sdf
DIRECTORY_NAME=/data1/choderaj/pathilm/FEC/abl/2_HTFs
MUTATION=THR315ILE
MUTANT_CHAIN=A

source ~/.bashrc
conda activate $perses_env_name

cd $script_directory_path
python generate_htfs.py -o ${DIRECTORY_NAME}/${MUTATION} -p ${PROTEIN_FILE}  -m ${MUTATION} -l ${LIGAND_FILE} -c ${MUTANT_CHAIN}
