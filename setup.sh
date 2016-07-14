#!/bin/bash

if (( $# < 2 ))
then
    echo "Error: too few parameters!"
    exit
fi

rock_file=`basename $2 .dat`


del_rho=$1

fr=$(echo $del_rho 1 | awk '{print $1 + $2}')
pr=$(echo $del_rho 1 | awk '{print $2 - $1}')

OUTPUT="output"
INPUT="input-file"
JOBNAME=K_del_rho_${del_rho}
JOBDIR=${OUTPUT}/${rock_file}/K_$del_rho
JOBINPUT=${JOBDIR}/${INPUT}-${JOBNAME}
JOBOUTPUT=${JOBNAME}

mkdir -p ${JOBDIR}

CHECKPOINT=(`ls -rt ${JOBDIR}/checkpoint_${JOBNAME}_*p000000.xdr 2>/dev/null`)
if [ ! -z ${CHECKPOINT} ]
then
	CHECKPOINT=`basename ${CHECKPOINT[@]:(-1)}`
	CHECKPOINT=`echo ${CHECKPOINT} | cut -d'_' -f5`
fi

sed -e "s,^folder.*,folder = '""${JOBDIR}""/'," \
    -e "s/^gr_out_file.*/gr_out_file = '${JOBOUTPUT}'/" \
    -e "s/^obs_file.*/obs_file = '${rock_file}.dat'/" \
    -e "s/^fr.*/fr=${fr}/" \
    -e "s/^pr.*/pr=${pr}/" \
     ${INPUT} > ${JOBINPUT}


cp -pf ${HOME}/lb3d/src/lbe ${JOBDIR}

echo ${JOBNAME} ${JOBDIR} ${JOBINPUT} ${CHECKPOINT}
