{ pkgs, ... }: {
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

  bind-key    -T copy-mode-vi v                  send-keys -X begin-selection
  bind-key    -T copy-mode-vi C-v                send-keys -X rectangle-toggle
  '';
  keyMode = "vi";
  escapeTime = 500; # mili sec
  historyLimit = 50000;
  newSession = true; # Automatically spawn a session if trying to attach and none are running.
}
