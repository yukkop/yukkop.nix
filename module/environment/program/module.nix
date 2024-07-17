{ outputs, ... }@args:
{
  imports = 
     with outputs.lib; 
     # moduleConfigs, common / shared configuration for programs
     (readSubModulesAsListWithArgs ./. (args // { moduleConfigs =  readModulesRecursive ./config; }));
}
