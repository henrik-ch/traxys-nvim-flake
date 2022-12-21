{
  description = "A very basic flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      #url = "github:pta2002/nixvim";
      url = "/home/traxys/Documents/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    "plugin:nvim-osc52" = {
      url = "github:ojroques/nvim-osc52";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
    neovim-flake,
    ...
  } @ inputs:
    with builtins;
      flake-utils.lib.eachDefaultSystem (system: let
        configuration = {
          imports = [
            ./config.nix
            ./plugins/osc52.nix
          ];
          package = neovim-flake.packages."${system}".neovim;
        };

        plugins = filter (s: (match "plugin:.*" s) != null) (attrNames inputs);
        plugName = input:
          substring
          (stringLength "plugin:")
          (stringLength input)
          input;

        buildPlug = pkgs: name:
          pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = plugName name;
            version = "master";
            src = getAttr name inputs;
          };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: let
              buildPlugPkg = buildPlug prev;
            in {
              vimPlugins =
                prev.vimPlugins
                // (listToAttrs (map (plugin: {
                    name = plugName plugin;
                    value = buildPlugPkg plugin;
                  })
                  plugins));
            })
          ];
        };

        nixvim' = nixvim.legacyPackages."${system}";
        nvim = nixvim'.makeNixvim {inherit configuration pkgs;};
      in {
        packages = {
          inherit nvim;
          default = nvim;
        };
      });
}