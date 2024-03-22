# NixOS and Home Manager Configuration

A way more complete and documented version of this can be found at [MatthiasBenaets/nixos-config](https://github.com/MatthiasBenaets/nixos-config), who inspired this setup.

## Usage

Applying the configuration of a host:

```bash
sudo nixos-rebuild switch --flake . 
```

Applying the home-manager config for a user:

```bash
home-manager switch --flake . 
```

## Structure

The structure is split up into a host-independent part and a host-specific part. Containers are *not* handled by Nix,
but simply linked to ~/containers and then invoked with docker-compose.

```
.
├── home
│   ├── config.nix # general config
│   ├── default.nix
│   ├── myHost.nix # host specific config
│   └── home # dotfiles and modules
├── nixos # NixOS configuration
│   ├── myHost # host specific config
│   ├── configuration.nix # general config
│   ├── default.nix
│   └── otherHost # host specific config
└── README.md
```
