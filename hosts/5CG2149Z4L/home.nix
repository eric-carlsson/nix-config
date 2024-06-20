{
  pkgs,
  pkgs-e49db01,
  pkgs-2bf9669,
  ...
}: {
  imports = [
    ../../modules/home-manager/default.nix
  ];

  config = {
    home.username = "ecarls18";
    home.homeDirectory = "/home/ecarls18";
    home.stateVersion = "24.05";

    home.packages =
      (with pkgs; [
        gnome-extension-manager
        azure-cli
        kubelogin
        fluxcd
        kubernetes-helm
        kubectl
        slack
      ])
      ++ (with pkgs-e49db01; [
        gnomeExtensions.pop-shell
      ])
      ++ (with pkgs-2bf9669; [
        terraform
      ]);

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };

    programs.bash.shellAliases = {
      t = "terraform";
      k = "kubectl";
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Yaru-dark";
      };

      # Customizations to Ubuntu flavoured dash-to-dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        show-trash = false;
        dock-position = "BOTTOM";
        extend-height = false;
        dock-fixed = false;
        multi-monitor = true;
        show-show-apps-button = false;
      };

      # DING is enabled by default
      "org/gnome/shell".disabled-extensions = ["ding@rastersoft.com"];

      "org/gnome/settings-daemon/plugins/media-keys" = {
        terminal = ["<Super>t"];
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [];
        toggle-tiled-right = [];
      };
    };

    # Extra bash configuration derived from Ubuntu defaults
    programs.bash.initExtra = ''
      # make less more friendly for non-text input files, see lesspipe(1)
      [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

      # set variable identifying the chroot you work in (used in the prompt below)
      if [ -z "''${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
          debian_chroot=$(cat /etc/debian_chroot)
      fi

      # set a fancy prompt (non-color, unless we know we "want" color)
      case "$TERM" in
          xterm-color|*-256color) color_prompt=yes;;
      esac

      # uncomment for a colored prompt, if the terminal has the capability; turned
      # off by default to not distract the user: the focus in a terminal window
      # should be on the output of commands, not on the prompt
      #force_color_prompt=yes

      if [ -n "$force_color_prompt" ]; then
          if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
          else
        color_prompt=
          fi
      fi

      if [ "$color_prompt" = yes ]; then
          PS1="''${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
      else
          PS1="''${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "
      fi
      unset color_prompt force_color_prompt

      # If this is an xterm set the title to user@host:dir
      case "$TERM" in
      xterm*|rxvt*)
          PS1="\[\e]0;''${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
          ;;
      *)
          ;;
      esac

      # enable color support of ls and also add handy aliases
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
          alias ls='ls --color=auto'
          #alias dir='dir --color=auto'
          #alias vdir='vdir --color=auto'

          alias grep='grep --color=auto'
          alias fgrep='fgrep --color=auto'
          alias egrep='egrep --color=auto'
      fi
    '';
  };
}
