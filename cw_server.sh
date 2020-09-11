#!/bin/bash
#SBATCH -n 1 
#SBATCH --time 1-00:00:00
#SBATCH --mem-per-cpu 4775
#SBATCH --job-name c3g_cromwell
#SBATCH --chdir /project/rrg-bourqueg-ad/C3G/projects/CROMWELL_SERVER

CROMWELL=${CROMWELL:-/home/poq/CROMWELL} 
java -Dconfig.file=/home/poq/c3g/cromwell_on_cc_slurm/cc_cromwell.conf -jar $CROMWELL/cromwell-52.jar   server
