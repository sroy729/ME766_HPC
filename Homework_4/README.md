## Profiling

### Profiling a CUDA program 

To profile the exeuctable, you need `nvidia-nsight-system`. Use the latest version [2024](https://developer.nvidia.com/nsight-systems/get-started). After download use the following
command to install 

```
sudo apt install <./name of the download>
```

To profile a executable you have multiple opiton to do it using nsight-system. To run a basic profiling do the following.

```
nsys nvprof <executable> <input to the executable>
```

To run a comprehensive profiling including CUDA, memory and system events run the following command

```
nsys profile --trace=cuda,osrt,nvtx <./executable> <input to the executable>
```

To open the report in terminal use the follwing command.

```
nsys stats <stat file.nsys-rep>
```

### Profiling a OpenMP and OpenMPI program

To profile a openMP executable you need `gprof`. For profiling follow the steps mentioned below.

First compile the executable with `-pg` flags in `gcc`. After that when you run the executable
you will get `gmon.out` file. Run the following command to extract
the information for `gmon.out` file.

```
gprof <executable> gmon.out > profile_report.txt
```
You can extract the tables that are profile_report.txt by running
the following scripts.

```
gprof_to_csv.sh
```


