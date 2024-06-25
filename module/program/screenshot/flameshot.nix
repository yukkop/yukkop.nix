{ ... }: {
  /*
    command to make a screenshot
    provide it to display manager module
  */
  callCommand = "flameshot";

  services.flameshot = {
    enable = true;
    settings.General = {
      showStartupLaunchMessage = false;
      saveLastRegion = true;
    };
  };
}
