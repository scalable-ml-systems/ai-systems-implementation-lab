    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2063499
    Memory Throughput                 %        95.20
    DRAM Throughput                   %        95.20
    Duration                         us       819.30
    L1/TEX Cache Throughput           %         8.13
    L2 Cache Throughput               %        33.32
    SM Active Cycles              cycle   2050934.70
    Compute (SM) Throughput           %         6.36
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.41
    Achieved Active Warps Per SM           warp        41.48
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.59%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.4%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   7987841.33
    Total DRAM Elapsed Cycles        cycle    100685824
    Average L1 Active Cycles         cycle   2050934.70
    Total L1 Elapsed Cycles          cycle    263615204
    Average L2 Active Cycles         cycle   1738479.83
    Total L2 Elapsed Cycles          cycle     62778024
    Average SM Active Cycles         cycle   2050934.70
    Total SM Elapsed Cycles          cycle    263615204
    Average SMSP Active Cycles       cycle   2049955.36
    Total SMSP Elapsed Cycles        cycle   1054460816
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2069402
    Memory Throughput                 %        95.19
    DRAM Throughput                   %        95.19
    Duration                         us       821.28
    L1/TEX Cache Throughput           %         8.13
    L2 Cache Throughput               %        32.78
    SM Active Cycles              cycle   2055521.09
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.44
    Achieved Active Warps Per SM           warp        41.49
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.56%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.4%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle      8006256
    Total DRAM Elapsed Cycles        cycle    100933632
    Average L1 Active Cycles         cycle   2055521.09
    Total L1 Elapsed Cycles          cycle    263461200
    Average L2 Active Cycles         cycle   1740185.69
    Total L2 Elapsed Cycles          cycle     62964864
    Average SM Active Cycles         cycle   2055521.09
    Total SM Elapsed Cycles          cycle    263461200
    Average SMSP Active Cycles       cycle   2054024.14
    Total SMSP Elapsed Cycles        cycle   1053844800
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2068266
    Memory Throughput                 %        95.20
    DRAM Throughput                   %        95.20
    Duration                         us       821.15
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        32.91
    SM Active Cycles              cycle   2049239.22
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.18
    Achieved Active Warps Per SM           warp        41.37
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.82%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.2%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8006109.33
    Total DRAM Elapsed Cycles        cycle    100914176
    Average L1 Active Cycles         cycle   2049239.22
    Total L1 Elapsed Cycles          cycle    263374152
    Average L2 Active Cycles         cycle   1736468.89
    Total L2 Elapsed Cycles          cycle     62921736
    Average SM Active Cycles         cycle   2049239.22
    Total SM Elapsed Cycles          cycle    263374152
    Average SMSP Active Cycles       cycle   2048614.05
    Total SMSP Elapsed Cycles        cycle   1053496608
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2073322
    Memory Throughput                 %        95.16
    DRAM Throughput                   %        95.16
    Duration                         us       822.85
    L1/TEX Cache Throughput           %         8.12
    L2 Cache Throughput               %        32.21
    SM Active Cycles              cycle   2056064.84
    Compute (SM) Throughput           %         6.36
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.50
    Achieved Active Warps Per SM           warp        41.52
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.5%                                                                                     
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.5%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8018577.33
    Total DRAM Elapsed Cycles        cycle    101122048
    Average L1 Active Cycles         cycle   2056064.84
    Total L1 Elapsed Cycles          cycle    263799704
    Average L2 Active Cycles         cycle   1740811.36
    Total L2 Elapsed Cycles          cycle     63086076
    Average SM Active Cycles         cycle   2056064.84
    Total SM Elapsed Cycles          cycle    263799704
    Average SMSP Active Cycles       cycle   2054905.23
    Total SMSP Elapsed Cycles        cycle   1055198816
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2067000
    Memory Throughput                 %        95.20
    DRAM Throughput                   %        95.20
    Duration                         us       820.64
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        33.18
    SM Active Cycles              cycle   2049597.33
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.34
    Achieved Active Warps Per SM           warp        41.44
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.66%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.3%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8001321.33
    Total DRAM Elapsed Cycles        cycle    100854784
    Average L1 Active Cycles         cycle   2049597.33
    Total L1 Elapsed Cycles          cycle    263267426
    Average L2 Active Cycles         cycle   1736585.14
    Total L2 Elapsed Cycles          cycle     62882316
    Average SM Active Cycles         cycle   2049597.33
    Total SM Elapsed Cycles          cycle    263267426
    Average SMSP Active Cycles       cycle   2048641.95
    Total SMSP Elapsed Cycles        cycle   1053069704
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2067716
    Memory Throughput                 %        95.19
    DRAM Throughput                   %        95.19
    Duration                         us       820.86
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        33.22
    SM Active Cycles              cycle   2051528.77
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.58
    Achieved Active Warps Per SM           warp        41.56
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.42%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.6%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8002206.67
    Total DRAM Elapsed Cycles        cycle    100879360
    Average L1 Active Cycles         cycle   2051528.77
    Total L1 Elapsed Cycles          cycle    263405556
    Average L2 Active Cycles         cycle   1738134.11
    Total L2 Elapsed Cycles          cycle     62903592
    Average SM Active Cycles         cycle   2051528.77
    Total SM Elapsed Cycles          cycle    263405556
    Average SMSP Active Cycles       cycle   2050897.40
    Total SMSP Elapsed Cycles        cycle   1053622224
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2067385
    Memory Throughput                 %        95.20
    DRAM Throughput                   %        95.20
    Duration                         us       820.42
    L1/TEX Cache Throughput           %         8.15
    L2 Cache Throughput               %        32.52
    SM Active Cycles              cycle   2052385.32
    Compute (SM) Throughput           %         6.38
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.69
    Achieved Active Warps Per SM           warp        41.61
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.31%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.7%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   7999106.67
    Total DRAM Elapsed Cycles        cycle    100827136
    Average L1 Active Cycles         cycle   2052385.32
    Total L1 Elapsed Cycles          cycle    263014624
    Average L2 Active Cycles         cycle   1738261.28
    Total L2 Elapsed Cycles          cycle     62907156
    Average SM Active Cycles         cycle   2052385.32
    Total SM Elapsed Cycles          cycle    263014624
    Average SMSP Active Cycles       cycle   2051544.95
    Total SMSP Elapsed Cycles        cycle   1052058496
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2068688
    Memory Throughput                 %        95.18
    DRAM Throughput                   %        95.18
    Duration                         us       821.28
    L1/TEX Cache Throughput           %         8.15
    L2 Cache Throughput               %        32.89
    SM Active Cycles              cycle   2050960.52
    Compute (SM) Throughput           %         6.38
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.57
    Achieved Active Warps Per SM           warp        41.55
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.43%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.6%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8005861.33
    Total DRAM Elapsed Cycles        cycle    100933632
    Average L1 Active Cycles         cycle   2050960.52
    Total L1 Elapsed Cycles          cycle    263064254
    Average L2 Active Cycles         cycle   1738422.14
    Total L2 Elapsed Cycles          cycle     62935380
    Average SM Active Cycles         cycle   2050960.52
    Total SM Elapsed Cycles          cycle    263064254
    Average SMSP Active Cycles       cycle   2050315.00
    Total SMSP Elapsed Cycles        cycle   1052257016
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2070629
    Memory Throughput                 %        95.13
    DRAM Throughput                   %        95.13
    Duration                         us       822.14
    L1/TEX Cache Throughput           %         8.15
    L2 Cache Throughput               %        32.61
    SM Active Cycles              cycle   2047465.01
    Compute (SM) Throughput           %         6.38
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        87.05
    Achieved Active Warps Per SM           warp        41.78
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 12.95%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (87.1%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8009938.67
    Total DRAM Elapsed Cycles        cycle    101036032
    Average L1 Active Cycles         cycle   2047465.01
    Total L1 Elapsed Cycles          cycle    263003354
    Average L2 Active Cycles         cycle   1735384.22
    Total L2 Elapsed Cycles          cycle     62996940
    Average SM Active Cycles         cycle   2047465.01
    Total SM Elapsed Cycles          cycle    263003354
    Average SMSP Active Cycles       cycle   2046827.72
    Total SMSP Elapsed Cycles        cycle   1052013416
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2065859
    Memory Throughput                 %        95.22
    DRAM Throughput                   %        95.22
    Duration                         us       820.16
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        33.28
    SM Active Cycles              cycle   2048290.08
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.64
    Achieved Active Warps Per SM           warp        41.59
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.36%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.6%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle      7997372
    Total DRAM Elapsed Cycles        cycle    100790272
    Average L1 Active Cycles         cycle   2048290.08
    Total L1 Elapsed Cycles          cycle    263352046
    Average L2 Active Cycles         cycle   1736607.61
    Total L2 Elapsed Cycles          cycle     62839980
    Average SM Active Cycles         cycle   2048290.08
    Total SM Elapsed Cycles          cycle    263352046
    Average SMSP Active Cycles       cycle   2047583.75
    Total SMSP Elapsed Cycles        cycle   1053408184
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2067670
    Memory Throughput                 %        95.15
    DRAM Throughput                   %        95.15
    Duration                         us       820.99
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        32.93
    SM Active Cycles              cycle   2050599.20
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.58
    Achieved Active Warps Per SM           warp        41.56
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.42%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.6%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8000150.67
    Total DRAM Elapsed Cycles        cycle    100893696
    Average L1 Active Cycles         cycle   2050599.20
    Total L1 Elapsed Cycles          cycle    263427338
    Average L2 Active Cycles         cycle   1738175.86
    Total L2 Elapsed Cycles          cycle     62908092
    Average SM Active Cycles         cycle   2050599.20
    Total SM Elapsed Cycles          cycle    263427338
    Average SMSP Active Cycles       cycle   2049718.64
    Total SMSP Elapsed Cycles        cycle   1053709352
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2069961
    Memory Throughput                 %        95.10
    DRAM Throughput                   %        95.10
    Duration                         us       821.76
    L1/TEX Cache Throughput           %         8.15
    L2 Cache Throughput               %        33.11
    SM Active Cycles              cycle   2047813.28
    Compute (SM) Throughput           %         6.38
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.99
    Achieved Active Warps Per SM           warp        41.76
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.01%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (87.0%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle   8003153.33
    Total DRAM Elapsed Cycles        cycle    100990976
    Average L1 Active Cycles         cycle   2047813.28
    Total L1 Elapsed Cycles          cycle    262970588
    Average L2 Active Cycles         cycle   1735065.39
    Total L2 Elapsed Cycles          cycle     62974764
    Average SM Active Cycles         cycle   2047813.28
    Total SM Elapsed Cycles          cycle    262970588
    Average SMSP Active Cycles       cycle   2047021.37
    Total SMSP Elapsed Cycles        cycle   1051882352
    -------------------------- ----------- ------------

  vector_add(const float *, const float *, float *, unsigned long) (262144, 1, 1)x(256, 1, 1), Context 1, Stream 7, Device 0, CC 8.9
    Section: GPU Speed Of Light Throughput
    ----------------------- ----------- ------------
    Metric Name             Metric Unit Metric Value
    ----------------------- ----------- ------------
    DRAM Frequency                  Ghz        10.24
    SM Frequency                    Ghz         2.52
    Elapsed Cycles                cycle      2067885
    Memory Throughput                 %        95.19
    DRAM Throughput                   %        95.19
    Duration                         us       821.15
    L1/TEX Cache Throughput           %         8.14
    L2 Cache Throughput               %        33.41
    SM Active Cycles              cycle   2056225.91
    Compute (SM) Throughput           %         6.37
    ----------------------- ----------- ------------

    INF   This workload is utilizing greater than 80.0% of the available compute or memory performance of this device.  
          To further improve performance, work will likely need to be shifted from the most utilized to another unit.   
          Start by analyzing DRAM in the Memory Workload Analysis section.                                              

    Section: Launch Statistics
    -------------------------------- --------------- ---------------
    Metric Name                          Metric Unit    Metric Value
    -------------------------------- --------------- ---------------
    Block Size                                                   256
    Function Cache Configuration                     CachePreferNone
    Grid Size                                                 262144
    Registers Per Thread             register/thread              16
    Shared Memory Configuration Size           Kbyte           16.38
    Driver Shared Memory Per Block       Kbyte/block            1.02
    Dynamic Shared Memory Per Block       byte/block               0
    Static Shared Memory Per Block        byte/block               0
    # SMs                                         SM             128
    Stack Size                                                  1024
    Threads                                   thread        67108864
    # TPCs                                                        64
    Enabled TPC IDs                                              all
    Uses Green Context                                             0
    Waves Per SM                                              341.33
    -------------------------------- --------------- ---------------

    Section: Occupancy
    ------------------------------- ----------- ------------
    Metric Name                     Metric Unit Metric Value
    ------------------------------- ----------- ------------
    Block Limit SM                        block           24
    Block Limit Registers                 block           16
    Block Limit Shared Mem                block           16
    Block Limit Warps                     block            6
    Theoretical Active Warps per SM        warp           48
    Theoretical Occupancy                     %          100
    Achieved Occupancy                        %        86.47
    Achieved Active Warps Per SM           warp        41.51
    ------------------------------- ----------- ------------

    OPT   Est. Local Speedup: 13.53%                                                                                    
          The difference between calculated theoretical (100.0%) and measured achieved occupancy (86.5%) can be the     
          result of warp scheduling overheads or workload imbalances during the kernel execution. Load imbalances can   
          occur between warps within a block as well as across blocks of the same kernel. See the CUDA Best Practices   
          Guide (https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/index.html#occupancy) for more details on     
          optimizing occupancy.                                                                                         

    Section: GPU and Memory Workload Distribution
    -------------------------- ----------- ------------
    Metric Name                Metric Unit Metric Value
    -------------------------- ----------- ------------
    Average DRAM Active Cycles       cycle      8005372
    Total DRAM Elapsed Cycles        cycle    100915200
    Average L1 Active Cycles         cycle   2056225.91
    Total L1 Elapsed Cycles          cycle    263459400
    Average L2 Active Cycles         cycle   1742073.17
    Total L2 Elapsed Cycles          cycle     62911080
    Average SM Active Cycles         cycle   2056225.91
    Total SM Elapsed Cycles          cycle    263459400
    Average SMSP Active Cycles       cycle   2055485.86
    Total SMSP Elapsed Cycles        cycle   1053837600
    -------------------------- ----------- ------------

riftuser@riftvm:~/nvidia-cuda-lab$ 
