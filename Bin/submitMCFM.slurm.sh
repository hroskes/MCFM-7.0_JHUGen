#!/bin/bash
#SBATCH --job-name=serial-job
#SBATCH --time=48:0:0
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --partition=shared
#SBATCH --mem=24000

cd ${SLURM_SUBMIT_DIR}
echo "SLURM job running in: " `pwd`
source /work-zfs/lhc/installations/addtopath.sh    #sets LHAPDF environment variables
cd ~/CMSSW_7_6_3/src
eval `scramv1 runtime -sh`
cd ${SLURM_SUBMIT_DIR}

../mcfm $1
