#!/bin/bash
#SBATCH -n 2 
#SBATCH -N 1 
#SBATCH --time 1-00:00:00
#SBATCH --mem-per-cpu 4775
#SBATCH --job-name c3g_cromwell

module load java/13
# load c3g software stack
export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles


# Path of the script
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# server log path
cd /project/rrg-bourqueg-ad/C3G/projects/CROMWELL_SERVER

# set temp dir for when running on login node
SLURM_TMPDIR=${SLURM_TMPDIR:-/tmp}

mkdir -p ${SLURM_TMPDIR}/cromwell-executions/cromwell-db

rsync -rv ./cromwell-executions/cromwell-db/ ${SLURM_TMPDIR}/cromwell-executions/cromwell-db/

sed "s@__DATA_BASE_ROOT__@$SLURM_TMPDIR/@g"  ${script_path}/cc_cromwell.conf.tpl > ${SLURM_TMPDIR}/cc_cromwell.conf

java -Dconfig.file=${SLURM_TMPDIR}/cc_cromwell.conf -jar ./jar_repo/cromwell-52.jar   server >> cromwell_server.log & 

mkdir -p .cromwell-executions/cromwell-db

while true ; do 

 sleep 360

 rsync -r --progress ${SLURM_TMPDIR}/cromwell-executions/cromwell-db/  ./cromwell-executions/cromwell-db/.

done

