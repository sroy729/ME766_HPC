#Compiler
CXX = g++

CXXFLAGS = -pg

#Target executable
TARGET_SERIAL = mul
TARGET_OPENMP = mul_openmp
TARGET_MPI = mul_mpi

SRCS_SERIAL = mul.c 
SRCS_OPENMP = mul_openMP.c 
SRCS_MPI = mul_mpi.c 

all: serial openmp mpi

#Rule to build the serial code
serial: 
	$(CXX) $(CXXFLAGS) -o $(TARGET_SERIAL) $(SRCS_SERIAL)

#rule to build the openmp code
openmp: CXXFLAGS += -fopenmp
openmp: 
	$(CXX) $(CXXFLAGS) -o $(TARGET_OPENMP) $(SRCS_OPENMP)

mpi:
	mpicc -pg $(SRCS_MPI) -o $(TARGET_MPI) #-pg flags for gprof
# clean up object files and the execution 
clean: 
	rm -f $(TARGET_SERIAL) $(TARGET_OPENMP) $(TARGET_MPI)

#phony targets to prevent issues with files named clean and all
.PHONY: clean all
