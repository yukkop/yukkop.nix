{ inputs, outputs, ... }: {
  imports = (outputs.lib.readSubModulesAsList ./.);


  home-manager.users.root = {
    imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

    home.stateVersion = "24.05";
  };
}
