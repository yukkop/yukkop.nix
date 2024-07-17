{ outputs, config, ... }:
{
  imports = 
     with outputs.lib; (readSubModulesAsList ./.);
}
