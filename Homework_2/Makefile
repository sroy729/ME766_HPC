#Compiler
CXX = g++

CXXFLAGS =

#Target executable
TARGET = mul

SRCS = $(wildcard *.c)

#Object file
OBJS = $(SRCS:.c=.o)

#Rule to build the target executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Rule to compile .c file into .o files
%.o: %.c
	$(CXX) $(CXXFLAGS) -c $< -o $@

# clean up object files and the execution 
clean: 
	rm -f $(OBJS) $(TARGET)

#phony targets to prevent issues with files named clean and all
.PHONY: clean all
