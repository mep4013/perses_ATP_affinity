Input files and scripts for ATP affinity with ABL on Perses

**Inputs**
- `ABL_input_complex_protonated.pdb` AF3 output passed through PDB fixer <br />
- `ABL_input_ligand.sdf` SDF of ATP used for HTF <br />
- `ABL_input_protein.pdb` PDB of kinase + Mg2+ ions used for HTF <br />
- `AF3_selected_sample` raw AF3 CIF file 

**Scripts**
- `setup_mutation_htf.py` script to run Perses PointMutationExecutor
- `submit_htfs.sh` bash script with inputs
