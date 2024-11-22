#include<stdio.h>
#include<math.h>

#define pi 3.14159265358979323846

double f(double x){
	return cos(x);
}

double cosine_trap_integrate(int interval, double a, double b){
	//to use trapazoidal method for caculating integral
	//formula for trapezoidal rule 
	//f(x) = cos(x)
	//integration of f(x) limits  a to b = ret
	//	ret = h/2 (f(a) + f(b) + 2(f(x1) + f(x2) + ...))
	//	h = (b-a)/2
	double h = (b-a)/interval;
	double sum = (f(a) + f(b))*0.5 ;

	for (int i=1; i< interval; i++){
		sum += f(a + i*h);
		//printf("sum %f\n",sum);
	}
	return h*sum;

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
	printf("%.10f\n", ans);
	return 0;
}

