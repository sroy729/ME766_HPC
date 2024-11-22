#!/bin/bash

if [ $# -lt 2 ]; then 
	echo "Not enough args"
	echo "Usage $0 <cuda_program> <mat_size>"
	exit 1
fi

nsys profile --trace=cuda,osrt,nvtx ../executables/$1 $2

nsys stats *.nsys-rep > ../output/$1_$2.out

rm *.nsys-rep *.sqlite
