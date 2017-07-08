#!/bin/bash
#SBATCH --ntasks-per-node=10
#SBATCH --nodes=10
#SBATCH --job-name=IO-500
#SBATCH --time=02:50:00
#SBATCH -d singleton
#SBATCH -o io_500_out_%J
#SBATCH -e io_500_err_%J

module load bullxmpi
module load intel

# parameters that are always true
maxTasks=$((${SLURM_TASKS_PER_NODE} * ${SLURM_JOB_NUM_NODES}))
mpirun="srun -m block"
workdir=/mnt/lustre02/work/k20200/k202079/io500-data/
output_dir=/mnt/lustre02/work/k20200/k202079/io500-results-${SLURM_JOB_NUM_NODES}

# precreate directories for lustre with the appropriate striping
mkdir -p ${workdir}/ior_easy
lfs setstripe --stripe-count 2  ${workdir}/ior_easy

mkdir -p ${workdir}/ior_hard
lfs setstripe --stripe-count 100  ${workdir}/ior_hard

# commands
find_cmd=$PWD/io500-find.sh
ior_cmd=/home/dkrz/k202079/work/io-500/io-500-dev/proposal-draft/ior
mdtest_cmd=/home/dkrz/k202079/work/io-500/io-500-dev/proposal-draft/mdtest

#
identify_parameters_ior_hard=False
identify_parameters_ior_easy=False
identify_parameters_mdt_easy=True # also identifies find
identify_parameters_mdt_hard=False

source ./auto-determine-parameters.sh
