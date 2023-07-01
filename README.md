# NixOS and Home Manager Configuration

## Usage

Applying the configuration of a host:

```bash
sudo nixos-rebuild switch --flake ".#annie"
```

## Structure

The structure is split up into a host-independent part and a host-specific part. Containers are *not* handled by Nix,
but simply linked to ~/containers and then invoked with docker-compose.

```
.
├── nixos
│   ├── myhost
│   │   ├── containers
│   │   │   └── docker-compose1.yml
│   │   ├── default.nix # Configuration specific to myhost
│   │   ├── hardware-configuration.nix # Hardware configuration as per installer
│   │   └── home.nix # Home configuration specific to myhost
│   ├── configuration.nix # General configuration for all hosts
│   ├── default.nix # Setup for easier usage
│   ├── home # Home Manager setup for all hosts
│   │   ├── default.nix
│   │   ├── neovim.nix
│   │   └── ...
```
