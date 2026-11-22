# Dotfiles (Omarchy laptop + Ubuntu server `doc`)

One repo for several machines, installed with GNU Stow. Every top-level folder is a **stow package**: its contents mirror `$HOME` (`bashrc/.bashrc` becomes `~/.bashrc`).

Rule for this repo: anything machine-specific is guarded, so the same files work everywhere (`[ -f … ] && …`, `command -v … &&`, or a fallback). Examples: the `uv env` line in `bashrc`, and `nvim/.config/nvim/lua/plugins/theme.lua` (Omarchy theme if present, tokyonight otherwise).

---

## Packages per machine

| Package | Laptop (Omarchy) | Server (Ubuntu) | Notes |
| --- | --- | --- | --- |
| `bashrc` | yes | yes | Has an Omarchy block and a Debian/Ubuntu fallback. Already loads `.aliases`, starship, fzf and zoxide when installed. |
| `aliases` | yes | yes | Loaded from `bashrc`. |
| `nvim` | yes | yes | `theme.lua` falls back to tokyonight without Omarchy. |
| `tmux` | yes | yes | |
| `starship` | yes | yes | Optional, needs the binary. |
| `ghostty`, `kitty` | yes | no | Terminal emulators, GUI only. |
| `hyprland` | yes | no | Needs checking against `install-hyprland-overrides.sh` in `omarchy-supplement`. |
| `systemd` | yes | no | User units, check before stowing. |

> [!note] Current state on the laptop
> `~/.bashrc` is a stow link. `~/.config/nvim`, `~/.config/starship.toml` and `~/.config/tmux` are plain files there, not links into this repo. Check what Stow would do before changing that: `stow -n -v <package>` (dry run, changes nothing).

---

## Setup on the server (Ubuntu)

### 1) Packages

```bash
sudo apt update
sudo apt install -y git stow neovim tmux fzf zoxide
```
`starship` comes from its official installer if you want the same prompt.

Arch-based server instead: `sudo pacman -S --needed git stow neovim tmux starship fzf zoxide`.

### 2) Clone

```bash
cd ~
git clone https://github.com/deadi/dotfiles
cd dotfiles
```
Repo already there: `cd ~/dotfiles && git pull`.

### 3) Check, then stow

Always start with a dry run. It lists conflicts (existing files that are not links) without touching anything:

```bash
cd ~/dotfiles
stow -n -v bashrc aliases nvim tmux starship
```

If it reports no conflicts:

```bash
stow bashrc aliases nvim tmux starship
```

**Conflict on an existing file** (for example your old `~/.bashrc`): back it up, then stow.

```bash
mv ~/.bashrc ~/.bashrc.bak
stow bashrc
```
`stow --adopt <package>` instead moves the existing file **into the repo and overwrites the repo's version**. Only use it when the local file is the one you want, and read `git diff` afterwards (`git restore <file>` undoes it).

> [!warning] Neovim state
> Only if you really want a clean start, remove old Neovim data first: `rm -rf ~/.local/share/nvim ~/.cache/nvim`. Do **not** run this on the laptop without looking, it deletes plugins and caches. Back up `~/.config/nvim` (`mv`, not `rm`) before stowing `nvim`.

### 4) Reload and start

```bash
source ~/.bashrc
nvim        # first start installs the plugins, wait, then restart
```

---

## Setup on the laptop (Omarchy)

Run from `~/dotfiles` and always dry-run first:

```bash
stow -n -v bashrc aliases
stow bashrc aliases
```
Add `ghostty`, `kitty`, `hyprland`, `systemd` only after checking them with `stow -n -v`.

---

## Changing a file

Edit it **inside the repo** (or through the link, which is the same file), then:

```bash
cd ~/dotfiles
git diff
git commit -am "what changed"
git push
```
On the other machine: `cd ~/dotfiles && git pull`. Stowed files update immediately, a new shell picks up `.bashrc`.

If `git status` stays clean after editing `~/.bashrc`, it is probably not a link: `ls -l ~/.bashrc`.

---

## Troubleshooting

- **`stow` reports `cannot stow … over existing target`:** a normal file is in the way. Back it up (`mv`), then stow again.
- **`.bashrc` error `No such file or directory` at login:** a line sources a file that is missing on this machine. Guard it with `[ -f … ] &&`.
- **Neovim `failed to load plugins.theme`:** `theme.lua` must be a real file, not a link to Omarchy (see the top of this file).
- **Unsure what a command does:** add `-n -v` to `stow`, it only prints.
