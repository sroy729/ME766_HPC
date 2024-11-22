#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define SIZE 1024

// Function to initialize matrix with random float numbers
void initialize_matrix(float *matrix, int N) {
    for (int i = 0; i < N * N; i++) {
        matrix[i] = (float)rand() / RAND_MAX;
    }
}

// Function to multiply matrices A and B, storing result in C
void matrix_multiply(float *A, float *B, float *C, int N, int start_row, int end_row) {
    for (int i = start_row; i < end_row; i++) {
        for (int j = 0; j < N; j++) {
            C[i * N + j] = 0.0;
            for (int k = 0; k < N; k++) {
                C[i * N + j] += A[i * N + k] * B[k * N + j];
            }
        }
    }
}

int main(int argc, char** argv) {
	int n = SIZE;
	if(argc != 2) {
		printf("Usage ./mul <size of matrix>\n");
		exit(1);
	}
	else {
		n = atoi(argv[1]);
	}

    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

	int N = n;

	float *A = NULL;
	float *B = NULL;
	float *C = NULL;
	float *local_A, *local_C;

	int rows_per_proc = N / size;
	int start_row = rank * rows_per_proc;
	int end_row = (rank == size - 1) ? N : (rank + 1) * rows_per_proc;

	// Allocate memory for local chunks of matrices A and C
	local_A = (float*)malloc(rows_per_proc * N * sizeof(float));
	local_C = (float*)malloc(rows_per_proc * N * sizeof(float));

	// Allocate full matrices A, B, and C in rank 0
	if (rank == 0) {
		A = (float*)malloc(N * N * sizeof(float));
		B = (float*)malloc(N * N * sizeof(float));
		C = (float*)malloc(N * N * sizeof(float));

		// Initialize A and B with random numbers
		srand(time(0));
		initialize_matrix(A, N);
		initialize_matrix(B, N);
	}

	// Broadcast matrix B to all processes
	if (rank == 0) {
		MPI_Bcast(B, N * N, MPI_FLOAT, 0, MPI_COMM_WORLD);
	} else {
		B = (float*)malloc(N * N * sizeof(float));  // Allocate space for B in other processes
		MPI_Bcast(B, N * N, MPI_FLOAT, 0, MPI_COMM_WORLD);
	}

	// Scatter rows of A to all processes
	MPI_Scatter(A, rows_per_proc * N, MPI_FLOAT, local_A, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

	// Start timing
	double start_time = MPI_Wtime();

	// Perform local matrix multiplication
	matrix_multiply(local_A, B, local_C, N, 0, rows_per_proc);

	// Gather the results from all processes
	MPI_Gather(local_C, rows_per_proc * N, MPI_FLOAT, C, rows_per_proc * N, MPI_FLOAT, 0, MPI_COMM_WORLD);

	// End timing
	double end_time = MPI_Wtime();

	if (rank == 0) {
		printf("Matrix size: %d x %d, MPI processes: %d, Time taken: %f seconds\n", N, N, size, end_time - start_time);
		free(A);
		free(B);
		free(C);

	free(local_A);
	free(local_C);
    }

    MPI_Finalize();
    return 0;
}

