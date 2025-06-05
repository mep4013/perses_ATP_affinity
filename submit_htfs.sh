#!/usr/bin/env bash
#SBATCH --time=2:00
#SBATCH --output=/data1/choderaj/pathilm/FEC/abl/2_HTFs/generate_htfs-%j.out
#SBATCH --error=/data1/choderaj/pathilm/FEC/abl/2_HTFs/generate_htfs-%j.stderr
#SBATCH --partition=cpushort
#SBATCH -n 1
#SBATCH --mem-per-cpu=64G
#SBATCH --job-name=htf.0

# run with https://github.com/choderalab/perses/commit/c790a780a20367c7415a86d50879e0983456d92b
# SBATCH --gpus=1

script_directory_path=/data1/choderaj/pathilm/FEC/abl/scripts
perses_env_name=perses

# PROTEIN_FILE=/data1/choderaj/pathilm/FEC/abl/1_solvation_equilibrium/apo_equilibrated.pdb
# PROTEIN_FILE=/data1/choderaj/pathilm/FEC/abl/0_ABL_input/ABL_input_protein.pdb # THIS WORKS FOR APO
PROTEIN_FILE=/data1/choderaj/pathilm/FEC/abl/0_ABL_input/new_input/ABL_input_protein.pdb
LIGAND_FILE=/data1/choderaj/pathilm/FEC/abl/0_ABL_input/new_input/ABL_ATP_ligand_2.sdf
# COMPLEX_FILE=/data1/choderaj/pathilm/FEC/abl/0_ABL_input/ABL_input_protonated.pdb
MUTATION=THR315ILE
DIRECTORY_NAME=/data1/choderaj/pathilm/FEC/abl/2_HTFs
MUTANT_CHAIN=A

source ~/.bashrc
conda activate $perses_env_name

cd $script_directory_path
python setup_mutation_htf.py -o ${DIRECTORY_NAME}/${MUTATION}_test -p ${PROTEIN_FILE} -l ${LIGAND_FILE} -m ${MUTATION} -c ${MUTANT_CHAIN}



