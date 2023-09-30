# dotfiles

My configs and some Bash scripts

## Auto-configure

```bash
git clone https://github.com/constellationz/dotfiles ~/.rep/dotfiles && bash ~/.rep/dotfiles/bin/configure --auto
```

## The `configure` script

The `configure` script automatically installs packages and copies configs.

```bash
configure [--auto]
```

- [x] Installs programs and copies configs
 - [x] Sources packages by operating system
 - [x] `auto` mode installs base programs automatically
- [x] Installs desktop environment

## Attribution

`constellationz/dotfiles` is licensed under the MIT license.
