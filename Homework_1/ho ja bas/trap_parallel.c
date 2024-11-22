// trapezoidal_parallel.c
#include <stdio.h>
#include <math.h>
#include <omp.h>

#define pi 3.14159265358979323846

double f(double x) {
    return cos(x);
}

double cosine_trap_integrate(int interval, double a, double b, int threads) {
    double h = (b - a) / interval;
    double sum = 0.0;

    #pragma omp parallel for num_threads(threads) reduction(+:sum)
    for (int i = 1; i < interval; i++) {
        sum += f(a + i * h);
    }
    
    sum = (sum + 0.5 * (f(a) + f(b))) * h;
    return sum;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: ./trapezoidal_parallel <interval> <threads>\n");
        return 1;
    }

    int interval = atoi(argv[1]);
    int threads = atoi(argv[2]);
    double a = -M_PI_2;
    double b = M_PI_2;

    double start_time = omp_get_wtime();
    double result = cosine_trap_integrate(interval, a, b, threads);
    double end_time = omp_get_wtime();

    printf("%.8f\n", end_time - start_time);  // Return the timing result
    return 0;
}

