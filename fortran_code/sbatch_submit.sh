#!/bin/tcsh
#SBATCH --job-name="myjob200706"
#SBATCH -n Nnodes 
#SBATCH --time=00:40:00
#SBATCH --mem-per-cpu=4096
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=yulanh@illinois.edu
#RunDir=/data/keeling/a/yulanh/c/aerosol_cloud_overlap_screen
cld_date="200706"
echo "$cld_date" | mpirun -n Nnodes ./ice_cf
