#include<stdio.h>
#include<math.h>

#define pi 3.14159265358979323846

double f(double x){
	return cos(x);
}

double cosine_trap_integrate(int interval, double a, double b){
	//to use trapazoidal method for caculating integral
	}

int main (int argc, char* argv[]){
	int interval;
	if(argc !=2){
		printf("Usage ./trap_serial <interval>");
		exit(1);
	}
	else{
		interval = atoi(argv[1]);
	}
	double a = -M_PI_2;
	double b = M_PI_2;

	//printf("cos -pi/2 %f cos(pi/2) %f ", f(a), f(b));
	double ans = cosine_trap_integrate(interval, a, b);
	return 0;
}

