{
  description = "Nix configuration for wayjam";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    flake-utils.url = github:numtide/flake-utils;

    unstable-nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    unstable-home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };

    darwin-nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # darwin-nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    darwin = {
      url = github:LnL7/nix-darwin;
      # url = github:LnL7/nix-darwin/nix-darwin-24.11;
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
    # home-manager, used for managing user configuration
    home-manager = {
      url = github:nix-community/home-manager;
      # url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };

    rime-plum = {
      url = "github:rime/plum/master";
      flake = false;
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    flake-utils,
    # unstable-nixpkgs,
    # unstable-home-manager,
    nixpkgs,
    darwin-nixpkgs,
    darwin,
    home-manager,
    rime-plum,
    ...
  }: let
    mkHost = hostName: system: let
      isDarwin = builtins.elem system nixpkgs.lib.platforms.darwin;
      specifics =
        {
          nixos = {
            nixpkgs = nixpkgs;
            nixSystem = nixpkgs.lib.nixosSystem;
            modules = [
              home-manager.nixosModules.home-manager
              ./modules/nixos
            ];
          };
          darwin = {
            nixpkgs = darwin-nixpkgs;
            nixSystem = darwin.lib.darwinSystem;
            modules = [
              home-manager.darwinModules.home-manager
              ./modules/darwin
            ];
          };
        }
        .${
          if isDarwin
          then "darwin"
          else "nixos"
        };
    in let
      hostConfig = import ./hosts/${hostName}.nix {
        inherit (specifics) nixpkgs;
        inherit system hostName;
      };
      lib = specifics.nixpkgs.lib.extend (final: prev: {
        # …
      });
      freezeRegistry = {
        nix.registry = lib.mkForce (lib.mapAttrs (_: flake: {inherit flake;}) inputs);
      };
      hostRootModule =
        {
          system.configurationRevision =
            if (self ? rev)
            then self.rev
            else throw "refuse to build: git tree is dirty";
        }
        // hostConfig.root;
      homeManagerModules = [
        ({config, ...}: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${hostConfig.myvars.user} = import ./home;
            extraSpecialArgs = {
              inherit isDarwin;
              inherit (hostConfig) myvars;
              inherit rime-plum;
            };
          };
        })
      ];
    in
      specifics.nixSystem {
        inherit system;

        specialArgs = {
          inherit (specifics) nixpkgs;
          inherit isDarwin hostName lib;
          inherit (hostConfig) myvars;
        };

        modules =
          [
            ./modules/nix-core.nix
            freezeRegistry
          ]
          ++ specifics.modules
          ++ homeManagerModules
          ++ [
            hostRootModule
            hostConfig.module
          ];
      };
  in
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    })
    // {
      nixosConfigurations = {
      };
      darwinConfigurations = {
        jamjar-mb4 = mkHost "jamjar-mb4" "aarch64-darwin";
      };
    };
}
