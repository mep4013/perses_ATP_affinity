import os
import pickle
import argparse
from pathlib import Path

import openmm
from openmm import unit, app
from perses.app.relative_point_mutation_setup import PointMutationExecutor
from perses.utils.smallmolecules import  render_protein_residue_atom_mapping

# Read args
parser = argparse.ArgumentParser(description='run equilibration')
parser.add_argument(
    "-o",
    dest="output_dir",
    type=str,
    help="the path to the output directory",
)
parser.add_argument(
    "-p",
    dest="protein_path",
    type=str,
    help="the path to the protein structure in e.g. PDB format",
)
parser.add_argument(
    "-l",
    dest="ligand_path",
    type=str,
    default="",
    help="the path to e.g. the ligand structure in SDF format or another protein in PDB format",
)
parser.add_argument(
    "-m",
    dest="mutation",
    type=str,
    help="the mutation to setup in the format ALA123THR including non-standard amino acids e.g. HIP159ALA",
)
parser.add_argument(
    "-c",
    dest="protein_chain",
    type=str,
    default="1",
    help="the protein chain which should be mutated",
)
parser.add_argument(
    "-f",
    dest="small_molecule_ff",
    type=str,
    default="gaff-2.11",
    help="the forcefield to use for the small molecule parametrization",
)
parser.add_argument(
    "--conduct_endstate_validation",
    dest="conduct_endstate_validation",
    action="store_true",
    default=False,
    help="if endstate validation should be conducted",
)
args = parser.parse_args()

# Set parameters for input to `PointMutationExecutor`
forcefield_files = ['amber14/protein.ff14SB.xml', 'amber14/tip3p.xml']
forcefield_kwargs = {'removeCMMotion': False, 'constraints' : app.HBonds, 'rigidWater': True, 'hydrogenMass' : 3 * unit.amus}

# if not args.is_vacuum:
#     is_vacuum = False
#     is_solvated = True
#     barostat = openmm.MonteCarloBarostat(1.0 * unit.atmosphere, 300 * unit.kelvin, 50)
#     periodic_forcefield_kwargs = {'nonbondedMethod': app.PME, 'ewaldErrorTolerance': 0.00025}
#     nonperiodic_forcefield_kwargs = None
# else:
#     is_vacuum = True
#     is_solvated = False
#     barostat = None
#     periodic_forcefield_kwargs = None
#     nonperiodic_forcefield_kwargs = {'nonbondedMethod': app.NoCutoff}

conduct_endstate_validation = False
w_lifting = 0.3 * unit.nanometer
generate_unmodified_hybrid_topology_factory = True # MP: changed to True to generate "vanilla" HTF
generate_rest_capable_hybrid_topology_factory = False # MP: changed to False to skip rest-capable HTF

# Generate htfs
solvent_delivery = PointMutationExecutor(
                        protein_filename=args.protein_path,
                        mutation_chain_id=args.protein_chain,
                        old_residue=args.mutation[:3],
                        mutation_residue_id=args.mutation[3:-3],
                        proposed_residue=args.mutation[-3:],
                        forcefield_files=['amber14/protein.ff14SB.xml', 'amber14/tip3p.xml'],
                        conduct_endstate_validation=args.conduct_endstate_validation,
                        # ligand_input=args.ligand_path if args.ligand_path else None,
                        small_molecule_forcefields="gaff-2.11",
                        generate_unmodified_hybrid_topology_factory=generate_unmodified_hybrid_topology_factory
                       )

# Saving htfs as pickles
print("Saving htfs as pickles")
directory_number = Path(args.outdir).parts[-2]
apo_htf = solvent_delivery.get_apo_htf() # MP: changed to apo_htf from apo_rest_htf
phase = 'apo'

with open(os.path.join(args.outdir, f"{phase}.pickle"), "wb") as f:   # MP: changed naming to "apo"____
    pickle.dump(apo_htf, f)

if args.ligand_input:
    complex_htf = solvent_delivery.get_complex_htf()
    with open(os.path.join(args.outdir, f"{directory_number}_complex.pickle"), "wb") as f:
        pickle.dump(complex_htf, f)

# Render atom map
atom_map_filename = f'{args.outdir}/atom_map.png'
render_protein_residue_atom_mapping(apo_htf._topology_proposal, atom_map_filename)

# Save pdbs
# MP: changed naming to "apo"____
app.PDBFile.writeFile(apo_htf._topology_proposal.old_topology, apo_htf.old_positions(apo_htf.hybrid_positions), open(os.path.join(args.outdir, f"{phase}_old.pdb"), "w"), keepIds=True)
app.PDBFile.writeFile(apo_htf._topology_proposal.new_topology, apo_htf.new_positions(apo_htf.hybrid_positions), open(os.path.join(args.outdir, f"{phase}_new.pdb"), "w"), keepIds=True)

if args.ligand_input:
    app.PDBFile.writeFile(complex_htf._topology_proposal.old_topology, complex_htf.old_positions(complex_htf.hybrid_positions), open(os.path.join(args.outdir, f"{directory_number}_complex_old.pdb"), "w"), keepIds=True)
    app.PDBFile.writeFile(complex_htf._topology_proposal.new_topology, complex_htf.new_positions(complex_htf.hybrid_positions), open(os.path.join(args.outdir, f"{directory_number}_complex_new.pdb"), "w"), keepIds=True)
