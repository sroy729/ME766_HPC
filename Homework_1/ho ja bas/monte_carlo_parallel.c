// monte_carlo_parallel.c
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <omp.h>

#define pi 3.14159265358979323846

double f(double x) {
    return cos(x);
}

double monte_carlo_integrate(int samples, double a, double b, int threads) {
    double sum = 0.0;
    double range = b - a;
    
    #pragma omp parallel for num_threads(threads) reduction(+:sum)
    for (int i = 0; i < samples; i++) {
        double x = a + ((double)rand() / RAND_MAX) * range;
        sum += f(x);
    }

    return (range * sum) / samples;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: ./monte_carlo_parallel <samples> <threads>\n");
        return 1;
    }

    int samples = atoi(argv[1]);
    int threads = atoi(argv[2]);
    
    double a = -M_PI_2;
    double b = M_PI_2;

    double start_time = omp_get_wtime();
    double result = monte_carlo_integrate(samples, a, b, threads);
    double end_time = omp_get_wtime();

    printf("%.8f\n", end_time - start_time);  // Return the timing result
    return 0;
}

