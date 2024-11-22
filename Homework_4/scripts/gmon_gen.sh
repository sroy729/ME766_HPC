#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Not enought arguements"
	echo "Usage $0 <mul/mul_openmp/mul_mpi> <mat_size>"
	exit 1
fi

export GMON_OUT_PREFIX=$1_$2

../executables/$1 $2

gprof ../executables/$1 $1_$2* > ../output/$1_$2.out

rm $1_$2*

#./gprof_to_csv.sh ../output/$1_$2.out

#rm ../output/$1_$2.out
