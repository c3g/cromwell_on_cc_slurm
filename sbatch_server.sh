#!/bin/bash
#SBATCH -n 1 
#SBATCH --time 12
#SBATCH --mem-per-cpus 4775

VERSION=52

java -Dconfig.file=cc_cromwell.conf -jar ${CROMWELL}/cromwell-${VERSION}.jar   server
