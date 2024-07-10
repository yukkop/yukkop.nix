 { pkgs, lib, config, ... }: {
  options = {
    module.program.tmux = {
      enable =
        lib.mkEnableOption "enable tmux";
    };
  };

  config = lib.mkIf config.module.program.tmux.enable {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [ resurrect continuum ];
      extraConfig = ''
      # ressurect
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-capture-pane-contents 'on'

      resurrect_dir="$HOME/.tmux/resurrect"
      set -g @resurrect-dir $resurrect_dir
      set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'

      # continuum
      set -g @continuum-restore 'on'
      set -g @continuum-boot 'on'
      set -g @continuum-save-interval '10'
      '';
      keyMode = "vi";
      newSession = true; # Automatically spawn a session if trying to attach and none are running.
    };
  };
}
