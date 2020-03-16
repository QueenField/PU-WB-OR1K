# PU-OR1K WIKI

A Processing Unit (PU) is an electronic system within a computer that carries out instructions of a program by performing the basic arithmetic, logic, controlling, and I/O operations specified by instructions. Instruction-level parallelism is a measure of how many instructions in a computer can be executed simultaneously. The PU is contained on a single Metal Oxide Semiconductor (MOS) Integrated Circuit (IC).

The OpenRISC implementation has a 32/64 bit Microarchitecture, 5 stages data pipeline and an Instruction Set Architecture based on Reduced Instruction Set Computer. Compatible with Wishbone Bus. Only For Researching.


## Basic parameters

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|OPTION_OPERAND_WIDTH|Specify the CPU data and address widths|32|32, 64, etc| |
|OPTION_CPU0|Specify the CPU pipeline core|`CAPPUCCINO`|`CAPPUCCINO` `ESPRESSO` `PRONTO_ESPRESSO`|`CAPPUCCINO` for Linux|
|OPTION_RESET_PC|Specify the program counter upon reset|`0x100`|n| |


## Caching parameters

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_DATACACHE|Enable memory access data caching|`NONE`|`ENABLED` `NONE`| |
|OPTION_DCACHE_BLOCK_WIDTH|Specify the address width of a cache block|5|`n`| |
|OPTION_DCACHE_SET_WIDTH|Specify the set address width|9|`n`| |
|OPTION_DCACHE_WAYS|Specify the number of blocks per set|2|`n`| |
|OPTION_DCACHE_LIMIT_WIDTH|Specify the maximum address width|32|`n`|`31` for Linux to allow uncached device access|
|OPTION_DCACHE_SNOOP|Enable bus snooping for cache coherency|`NONE`|`ENABLED` `NONE`|Linux SMP|
|FEATURE_INSTRUCTIONCACHE|Enable memory access instruction caching|`NONE`|`ENABLED` `NONE`| |
|OPTION_ICACHE_BLOCK_WIDTH|Specify the address width of a cache block|5|`n`| |
|OPTION_ICACHE_SET_WIDTH|Specify the set address width|9|`n`| |
|OPTION_ICACHE_WAYS|Specify the number of blocks per set|2|`n`| |
|OPTION_ICACHE_LIMIT_WIDTH|Specify the maximum address width|32|`n`| |


## Memory Management Unit (MMU) parameters

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_DMMU|Enable the data bus MMU|`NONE`|`ENABLED` `NONE`|Linux expects `ENABLED`|
|FEATURE_DMMU_HW_TLB_RELOAD|Enable hardware TLB reload|`NONE`|`ENABLED` `NONE`|Linux expects `NONE`|
|OPTION_DMMU_SET_WIDTH|Specify the set address width|6|`n`| |
|OPTION_DMMU_WAYS|Specify the number of ways per set|1|`n`| |
|FEATURE_IMMU|Enable the instruction bus MMU|`NONE`|`ENABLED` `NONE`|Linux expects `ENABLED`|
|FEATURE_IMMU_HW_TLB_RELOAD|Enable hardware TLB reload|`NONE`|`ENABLED` `NONE`|Linux expects `NONE`|
|OPTION_IMMU_SET_WIDTH|Specify the set address width|6|`n`| |
|OPTION_IMMU_WAYS|Specify the number of ways per set|1|`n`| |


## System bus parameters

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_STORE_BUFFER|Enable the load store unit store buffer|`ENABLED`|`ENABLED` `NONE`|Large footprint|
|OPTION_STORE_BUFFER_DEPTH_WIDTH|Specify the load store unit store buffer depth|8|1-n| |
|BUS_IF_TYPE|Specify the bus interface type|`WISHBONE32`|`WISHBONE32`| |
|IBUS_WB_TYPE|Specify the Instruction bus interface type option|`B3_READ_BURSTING`|`B3_READ_BURSTING` `B3_REGISTERED_FEEDBACK` `CLASSIC`| |
|DBUS_WB_TYPE|Specify the Data bus interface type option|`CLASSIC`|`B3_READ_BURSTING` `B3_REGISTERED_FEEDBACK` `CLASSIC`| |


## Hardware unit configuration parameters

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_TRACEPORT_EXEC|Enable the traceport hardware interface|`NONE`|`ENABLED` `NONE`|Verilator|
|FEATURE_DEBUGUNIT|Enable hardware breakpoints and advanced debug unit interface|`NONE`|`ENABLED` `NONE`|OpenOCD|
|FEATURE_PERFCOUNTERS|Enable the performance counters unit|`NONE`|`ENABLED` `NONE`| |
|OPTION_PERFCOUNTERS_NUM|Specify the number of performance counters to generate|0|n| |
|FEATURE_TIMER|Enable the internal OpenRISC timer|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_PIC|Enable the internal OpenRISC PIC|`ENABLED`|`ENABLED` `NONE`| |
|OPTION_PIC_TRIGGER|Specify the PIC trigger mode|`LEVEL`|`LEVEL` `EDGE` `LATCHED_LEVEL`| |
|OPTION_PIC_NMI_WIDTH|Specify non maskable interrupts width, starting at 0, these interrupts will not be reset or maskable|0|0-32| |
|OPTION_RF_CLEAR_ON_INIT|Enable clearing all registers on initialization|0|0, 1| |
|OPTION_RF_NUM_SHADOW_GPR|Specify the number of shadow register files|0|0-16|Set `>=1` for Linux SMP|
|OPTION_RF_ADDR_WIDTH|Specify the address width of the register file|5|5| |
|OPTION_RF_WORDS|Specify the number of registers in the register file|32|32| |
|FEATURE_FASTCONTEXTS|Enable fast context switching of register sets|`NONE`|`ENABLED` `NONE`| |
|FEATURE_MULTICORE|Enable the `coreid` and `numcores` SPR registers|`NONE`|`ENABLED` `NONE`|Linux SMP|
|FEATURE_FPU|Enable the FPU, for cappuccino pipeline only|`NONE`|`ENABLED` `NONE`| |
|OPTION_FTOI_ROUNDING|Select rounding behavior for `lf.ftoi.s` instruction|`CPP`|`CPP` `IEEE`|GCC9|
|FEATURE_BRANCH_PREDICTOR|Select the branch predictor implementation|`SIMPLE`|`SIMPLE` `GSHARE` `SAT_COUNTER`| |

**Note:** *C/C++ double to integer conversion assumes truncation (rounding `toward zero`).
The default (`CPP`) value of OPTION_FTOI_ROUNDING forces `toward zero` rounding mode exclusively for
`lf.ftoi.s` instruction regardless of `rounding mode` bits of FPCSR. While with `IEEE` value
`lf.ftoi.s` performs conversion in according with `rounding mode` bits of FPCSR. And these bits are
`nearest-even` rounding mode by default. All other floating point instructions always perform rounding
in according with `rounding mode` bits of FPCSR.*


## Exception handling options

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_DSX|Enable setting the `SR[DSX]` flag when raising exceptions in a delay slot|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_RANGE|Enable checking and raising range exceptions|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_OVERFLOW|Enable checking and raising overflow exceptions|`ENABLED`|`ENABLED` `NONE`| |


## ALU configuration options

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_MULTIPLIER|Specify the multiplier implementation|`THREESTAGE`|`THREESTAGE` `PIPELINED` `SERIAL` `SIMULATION` `NONE`| |
|FEATURE_DIVIDER|Specify the divider implementation|`SERIAL`|`SERIAL` `SIMULATION` `NONE`| |
|OPTION_SHIFTER|Specify the shifter implementation|`BARREL`|`BARREL` `SERIAL`| |
|FEATURE_CARRY_FLAG|Enable checking and setting the carry flag|`ENABLED`|`ENABLED` `NONE`| |


## Instruction enabling options

|Parameter|Description|Default|Values|Usage?|
|---------|-----------|-------|------|------|
|FEATURE_MAC|Enable the `l.mac*` multiply accumulate instructions|`NONE`|`ENABLED` `NONE`| |
|FEATURE_SYSCALL|Enable the 'l.sys` OS syscall instruction|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_TRAP|Enable the `l.trap` instruction|`ENABLED`|`ENABLED` `NONE`|GDB|
|FEATURE_ADDC|Enable the `l.addc` add with `carry` flag instruction|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_SRA|Enable the `l.sra` shirt right arithmetic instruction|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_ROR|Enable the `l.ror*` rotate right instructions|`NONE`|`ENABLED` `NONE`| |
|FEATURE_EXT|Enable the `l.ext*` sign extend instructions|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CMOV|Enable the `l.cmov` conditional move instruction|`ENABLED`|`ENABLED` `NONE`| |
|FEATURE_FFL1|Enable the `l.f[fl]1` find first/last set bit instructions|`ENABLED`|`ENABLED` `NONE`|Linux|
|FEATURE_ATOMIC|Enable the `l.lwa` and `l.swa` atomic instructions|`ENABLED`|`ENABLED` `NONE`|Linux SMP|
|FEATURE_CUST1|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST2|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST3|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST4|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST5|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST6|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST7|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
|FEATURE_CUST8|Enable the `l.cust*` custom instruction|`NONE`|`ENABLED` `NONE`| |
