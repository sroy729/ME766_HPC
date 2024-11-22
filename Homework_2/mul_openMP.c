#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#define N 1024
#define SEED 500

void initMat(double* mat, int size) {
	for(int i=0; i<size*size; i++) 
		mat[i] = (double)rand()/(double)RAND_MAX * 10.0;
}

void matrixMul(double* A, double*B, double*C, int n) {
	double sum =0;
	#pragma omp parallel for
	for(int i=0; i<n ; i++){
		for(int j=0; j<n; j++){
			double sum =0;
			for(int k=0; k<n; k++){
				sum += A[i * n +k] * B[k * n + j]; 
			}
			C[i * n + j] = sum;
		}
	}
}


int main(int argc, char* argv[]){
	srand(SEED);
	int n = N;
	if(argc != 2) {
		printf("Usage ./mul <size of matrix>\n");
		exit(1);
	}
	else {
		n = atoi(argv[1]);
	}
	
	int size = n*n;
	//initalize data structure
	double* A = (double*)malloc(size*sizeof(double));
	double* B = (double*)malloc(size*sizeof(double));
	double* C = (double*)calloc(size, sizeof(double));
	initMat(A, n);
	initMat(B, n);
	
	clock_t start = clock();
	matrixMul(A, B, C, n);
	clock_t end = clock();

	double time_taken = (double)(end - start)/CLOCKS_PER_SEC; //time in seconds
	printf("time taken in milisecond: %.2f\n", time_taken*1e3);

	free(A);
	free(B);
	free(C);
	return 0;
}
