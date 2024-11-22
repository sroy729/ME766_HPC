## Profiling

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

