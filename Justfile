# set options
set positional-arguments := true
set dotenv-load := true

# from .env
profile := "$PROFILE"

# List all the just commands
default:
  @just --list

# Calc Github Sha256
prefetch-gh owner repo rev="HEAD":
    #!/usr/bin/env bash
    json=$(nix-prefetch-github --no-deep-clone --quiet --rev {{ rev }} {{ owner }} {{ repo }})
    owner=$(echo "$json" | jq -r '.owner')
    repo=$(echo "$json" | jq -r '.repo')
    rev=$(echo "$json" | jq -r '.rev' | cut -c 1-8)
    hash=$(echo "$json" | jq -r '.hash')
    cat <<EOF
    pkgs.fetchFromGitHub {
      owner = "$owner";
      repo  = "$repo";
      rev   = "$rev";
      hash  = "$hash";
    };
    EOF

############################################################################
#
#  Darwin related commands
#
############################################################################
[group('darwin')]
darwin-build host=profile:
  nix build .#darwinConfigurations.{{host}}.system

  # ./result/sw/bin/darwin-rebuild switch --flake .#{{host}}

[group('darwin')]
darwin-debug host=profile:
  nix build .#darwinConfigurations.{{host}}.system --show-trace --verbose

  ./result/sw/bin/darwin-rebuild switch --flake .#{{host}} --show-trace --verbose

############################################################################
#
#  nix related commands
#
############################################################################

# Update all the flake inputs
[group('nix')]
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}}

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

[group('nix')]
fmt:
  # format the nix files in this repo
  nix fmt

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/


############################################################################
#
#  git related commands
#
############################################################################

# Stash & Pull & Pop
[group('git')]
git-temp:
  @git stash save 'temp'
  @git pull --rebase
  @git stash pop