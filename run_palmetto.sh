#!/bin/bash -l

# Batch script to run an MPI parallel job on Palmetto.

#export LD_LIBRARY_PATH=/usr/lib64/:$LD_LIBRARY_PATH
#export LIBRARY_PATH=/usr/lib64/:$LIBRARY_PATH

# Load modules
source /etc/profile.d/modules.sh
export MODULEPATH=/software/experimental:$MODULEPATH
module purge
module add gcc/6.1.0 openmpi/1.10.3 hdf5/1.10.0

# Make sure any symbolic links are resolved to absolute path 
export PBS_O_WORKDIR=$(readlink -f $PBS_O_WORKDIR)

# Switch to current working directory
cd $PBS_O_WORKDIR

JOBDIR=($( IFS=: ; echo ${JOBDIR} )) #read -ra JOBDIR <<< "${JOBDIR}"
JOBINPUT=($( IFS=: ; echo ${JOBINPUT} )) #read -ra JOBINPUT <<< "${JOBINPUT}"
CHECKPOINT=($( IFS=: ; echo ${CHECKPOINT} )) #read -ra CHECKPOINT <<< "${CHECKPOINT}"

# The executable binary
LBE=${JOBDIR[$PBD_ARRAY_INDEX]}/lbe

# Run the parallel program
if [ -z ${CHECKPOINT} ]
then
	JOBCOMMAND="$LBE -f ${JOBINPUT[$PBS_ARRAY_INDEX]}"
else
	JOBCOMMAND="$LBE -f ${JOBINPUT[$PBS_ARRAY_INDEX]} -r ${CHECKPOINT[$PBS_ARRAY_INDEX]}"
fi

ncores=`qstat -xf $PBS_JOBID | grep List.ncpus | sed 's/^.\{26\}//'`

#echo `qstat -xf $PBS_JOBID | grep Resource_List.selec` 1>&2
#echo `qstat -xf $PBS_JOBID | grep exec_host` 1>&2
#echo `module list`
#echo $LD_LIBRARY_PATH 1>&2
#ldd $LBE 1>&2
#env 1>&2

#mpiexec --mca pml ob1 -n 1 ${JOBCOMMAND}
mpiexec --mca mpi_cuda_support 0 ${JOBCOMMAND}

#rsync -nCauvh ${JOBDIR[$PBD_ARRAY_INDEX]}/ ./output/
