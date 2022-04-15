#!/bin/bash

#PBS -N myjob202006

#PBS -l nodes=1:ppn=32

#PBS -l walltime=00:20:00

# combine PBS standard output and error files

#PBS -j oe

# mail is sent to you when the job starts and when it terminates or aborts

#PBS -m bea

# specify your email address

##PBS -M yulanh@illinois.edu

#change to the directory where you submitted the job

cd $PBS_O_WORKDIR

#include the full path to the name of your MPI program

cld_date="202006"

echo "$cld_date" | aprun -n 30 ./caliop

exit 0
