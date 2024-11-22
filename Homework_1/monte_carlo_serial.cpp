#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>


double f(double x) {
    return cos(x);
}

double monte_carlo_serial(int N, double a, double b) {
    double sum = 0.0;
    double range = b - a;

    // Generate N random points and sum the function values
    for (int i = 0; i < N; i++) {
        double x = a + (double)rand() / RAND_MAX * range;
        sum += f(x);
    }

    // Return the Monte Carlo estimate of the integral
    return range * sum / N;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: ./monte_carlo_serial <number_of_samples>\n");
        return 1;
    }

    int samples = atoi(argv[1]); // Number of random samples
    double a = -M_PI_2;
    double b = M_PI_2;

    // Seed the random number generator
    srand(time(NULL));

    // Perform the Monte Carlo integration
    double result = monte_carlo_serial(samples, a, b);
    printf("Monte Carlo Serial Result: %.10f\n", result);

    return 0;
}

