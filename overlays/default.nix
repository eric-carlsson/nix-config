{inputs, ...}: {
  # Shared overlays
  shared = {
    pins = final: prev: let
      nixpkgsConfig = {
        system = final.system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable nixpkgsConfig;
    in {
      vscode = pkgs-unstable.vscode;
      azure-cli = (import inputs.nixpkgs-e081643 nixpkgsConfig).azure-cli;
      terraform = pkgs-unstable.terraform;
      kind = pkgs-unstable.kind;
      clusterctl = pkgs-unstable.clusterctl;
      go_1_23 = pkgs-unstable.go_1_23;
      crossplane-cli = pkgs-unstable.crossplane-cli.overrideAttrs (old: {
        src = prev.fetchFromGitHub {
          owner = "crossplane";
          repo = "crossplane";
          rev = "release-1.17";
          hash = "sha256-Fr3lVVghnricQ5bOFVSQgbrJshC9r0159xsm0FLAiqQ=";
        };
      });
    };

    additions = final: prev: import ../pkgs final.pkgs;
  };
}
