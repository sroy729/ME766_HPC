#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <random>
#include <chrono>

#define cudaCheckErrors(msg) \
do { \
        cudaError_t __err = cudaGetLastError(); \
        if(__err != cudaSuccess) { \
                fprintf(stderr, "Fatal error: %s (%s at %s:%d)\n", \
                                msg, cudaGetErrorString(__err), \
                                __FILE__, __LINE__); \
                fprintf(stderr, "***FAILED - ABORTING\n"); \
                exit(1); \
        } \
}while(0)

#define TILE_SIZE 16

__global__ void mat_mul(uint64_t* matA, uint64_t* matB, uint64_t* resC, uint64_t N) {
	int row = blockIdx.y * blockDim.y + threadIdx.y;  // Global row index
    int col = blockIdx.x * blockDim.x + threadIdx.x;  // Global column index

    uint64_t value = 0;

    if (row < N && col < N) {
        for (int i = 0; i < N; i++) {
            value += matA[row * N + i] * matB[i * N + col];
        }
        resC[row * N + col] = value;
    }
	
}

void init_mat(uint64_t* mat, uint64_t size){
	srand(766);
	for(int i = 0; i < size; i++)
		mat[i] = (rand() % 1000) + i;
}

int check_compute(uint64_t* A, uint64_t* B, uint64_t* C, uint64_t* d_C, uint64_t N) {
	
	for (int i = 0; i < N; i++) {          // Loop over rows of A
        for (int j = 0; j < N; j++) {      // Loop over columns of B
            for (int k = 0; k < N; k++) {  // Loop over columns of A / rows of B
                C[i * N + j] += A[i * N + k] * B[k * N + j];
            }
        }
    }
	
	for(int i = 0; i < N ; i++) {
		if (C[i] != d_C[i]){
			return -1;
		}
	}
	return 0;
}

int main(int argc, char* argv[]) {
	cudaDeviceReset();

	uint64_t N ;
	if (argc != 2) {
		printf("Usage ./mat_mul <size>\n");
		exit(1);
	}
	else {
		N = (uint64_t)atoi(argv[1]);
	}

	uint64_t *d_A, *d_B, *d_resC;
	uint64_t *h_A, *h_B, *h_C, *h_resC;

	cudaMalloc(&d_A, N*N*sizeof(uint64_t));
	cudaMalloc(&d_B, N*N*sizeof(uint64_t));
	cudaMalloc(&d_resC, N*N*sizeof(uint64_t));

	h_A = (uint64_t*)malloc(N*N*sizeof(uint64_t));
	h_B = (uint64_t*)malloc(N*N*sizeof(uint64_t));
	h_resC = (uint64_t*)malloc(N*N*sizeof(uint64_t));
	h_C = (uint64_t*)malloc(N*N*sizeof(uint64_t));
	memset(h_resC, 0, N*N*sizeof(uint64_t));
	memset(h_C, 0, N*N*sizeof(uint64_t));

	init_mat(h_A, N);
	init_mat(h_B, N);

	cudaMemcpy(d_A, h_A, N*N*sizeof(uint64_t), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, h_B, N*N*sizeof(uint64_t), cudaMemcpyHostToDevice);
	cudaMemcpy(d_resC, h_resC, N*N*sizeof(uint64_t), cudaMemcpyHostToDevice);

	cudaDeviceSynchronize();

	dim3 threadsPerBlock(TILE_SIZE, TILE_SIZE);
	dim3 numBlocks((N + TILE_SIZE - 1) / TILE_SIZE, (N + TILE_SIZE - 1) / TILE_SIZE);

	auto start = std::chrono::high_resolution_clock::now();
	mat_mul<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_resC, N);
	cudaCheckErrors("kernel failed to launch\n");
	cudaDeviceSynchronize();
	auto end = std::chrono::high_resolution_clock::now();
	std::chrono::duration<double, std::milli> elapsed = end - start;

	cudaMemcpy(h_resC, d_resC, N*N*sizeof(uint64_t), cudaMemcpyDeviceToHost);
	
	//int ret = check_compute(h_A, h_B, h_C, h_resC, N);
	
	//if(ret == 0)
	printf("%lu, %f, Successful\n", N, elapsed.count());
	//else{
		//printf("Failed\n");
		//return -1;
	//}
	return 0;


}
