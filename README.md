# elec50010-mips-coursework

An implementation of a BUS MIPS CPU. 

## Folder structure:

```
elec50010-mips-coursework
│   README.md  
│
└───rtl                     
│   └───mips_cpu            
|   |   |    alu_ctrl.v     
|   |   |    alu.v          
|   |   |    ...            
|   └───module_tests        
|   |   |    alu_ctrl_tb.v  
|   |   |    alu_tb.v       
|   |   |    ...            
|   |   mips_cpu_bus.v      
│   │   module_test.sh      
│   |   test_alu_ctrl.sh    
|   |   ...                 
│   
└───test
    └───c_assemble
    └───cases
    └───output
    └───reference
    └───simulator
    |   test_mips_cpu_bus.sh
```
## How to use:
To test:\
Run from the base directory of the submission  `./test/test_mips_cpu_bus.sh [source_directory] [instruction]`.\
The output files can be used for debugging and will be stored in the /test/output folder.