#!/bin/tcsh
#SBATCH --job-name="myjob200701"
#SBATCH -n Nnodes 
#SBATCH --time=00:40:00
#SBATCH -p sesempi
#SBATCH --mem-per-cpu=4096
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=yulanh@illinois.edu
#RunDir=/data/keeling/a/yulanh/c/aerosol_cloud_overlap_screen
##cld_date="200701"
echo "200701" | mpirun -n Nnodes ./caliop
