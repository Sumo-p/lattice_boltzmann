#!/bin/bash

LB3D=~/lb3d/src/lbe

if [ ! -f ${LB3D} ]; then
  echo "Please place executable at ${LB3D}."
  exit -1
fi

# Probe P3M
#CNT=`strings lbe | grep '\-DP3M' | wc -l`
#if [[ "$CNT" -lt 1 ]]; then
#  echo "Warning: -DP3M not set, skipping poisson_solver = 'p3m'."
#fi

walltime=40:00:00

del_rho=0.00005

rock_file=fibmb96.dat

for del_rho in 0.00001 0.00002 0.00003 0.00004 0.00005 0.00006 0.00007 0.00008 0.00009 0.00010; do
	SETUP=(`./setup.sh ${del_rho} ${rock_file}`)
	JOBNAME=${SETUP[0]}
	JOBDIR=${SETUP[1]}
	JOBINPUT=${SETUP[2]}

	qsub -N ${JOBNAME} \
             -l walltime=${walltime} \
             -v JOBDIR=${JOBDIR},JOBINPUT=${JOBINPUT} \
             run_palmetto.sh

 
done
