# Omarchy Dotfiles (SSH + Neovim setup)

This repository is meant to make a remote Linux server feel like your Omarchy setup, especially for **Neovim** workflows over SSH.

If you already use an `install-dotfiles.sh` script with GNU Stow in your `omarchy-supplement` repo, this guide gives you a repeatable way to get the same editing experience on your doc server.

---

## Goal

After setup, when you SSH into your server and run `nvim`, you should get:

- your Omarchy Neovim config
- matching aliases and shell behavior
- tmux integration for persistent sessions
- starship prompt (optional but recommended)
- optional `fzf` + `zoxide` navigation workflow

---

## Prerequisites (on the remote server)

Install required packages first.

### Arch-based server

```bash
sudo pacman -S --needed git stow neovim tmux starship fzf zoxide
```

### Debian/Ubuntu-based server

```bash
sudo apt update
sudo apt install -y git stow neovim tmux fzf zoxide
```

(Install `starship` from its official installer if you want the same prompt there too.)

---

## Step-by-step setup

### 1) Clone this repository on the server

```bash
cd ~
git clone https://github.com/deadi/dotfiles
cd dotfiles
```

If the repo already exists:

```bash
cd ~/dotfiles
git pull
```

### 2) Clean old Neovim state (recommended)

This avoids plugin/cache conflicts from previous configs.

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim
```

Also clean old files you replace via stow:

```bash
rm -f ~/.config/starship.toml
```

### 3) Stow the packages

From inside `~/dotfiles`:

```bash
stow nvim
stow tmux
stow starship
stow aliases
```

If you use Ghostty on that machine too:

```bash
stow ghostty
```

### 4) Make sure aliases are loaded in Bash

Append once to `~/.bashrc`:

```bash
ALIAS_LINE='[ -f "$HOME/.aliases" ] && . "$HOME/.aliases"'
grep -Fxq "$ALIAS_LINE" "$HOME/.bashrc" || echo "$ALIAS_LINE" >> "$HOME/.bashrc"
```

Apply it immediately:

```bash
source ~/.bashrc
```

### 4.1) Enable `zoxide` in Bash (if installed)

Add this once to `~/.bashrc`:

```bash
grep -Fxq 'eval "$(zoxide init bash)"' ~/.bashrc || echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
```

Then reload shell:

```bash
source ~/.bashrc
```

### 5) Start Neovim and let plugins install

```bash
nvim
```

On first run, your plugin manager may bootstrap and install plugins. Wait for completion, then restart Neovim.

### 6) Verify `fzf` + `zoxide` are available

```bash
fzf --version
zoxide --version
```

Useful commands:

- `zi <partial-folder-name>`: jump quickly to frequently-used directories
- `z <partial-folder-name>`: classic jump command
- `Ctrl-r` in shell: fuzzy history search (`fzf`-powered in many setups)

---

## Recommended SSH workflow (Neovim + tmux)

For remote work, use `tmux` so your editing session survives network drops.

### First login

```bash
tmux new -s work
nvim
```

### Later logins

```bash
tmux attach -t work
```

### Useful tmux basics

- `Ctrl-b d` → detach from session (keeps programs running)
- `tmux ls` → list sessions
- `tmux kill-session -t work` → remove session

---

## Do you need tmux?

Short answer: **for SSH, yes (strongly recommended)**.

Use tmux when you want:

- persistent Neovim sessions after disconnects
- multiple terminals/windows on one SSH connection
- long-running jobs that continue in background

You can run `nvim` without tmux, but every disconnect ends your session.

## Can you use `fzf` and `zoxide` too?

Yes — absolutely. They are a great match for remote Neovim workflows:

- `fzf`: fuzzy-find files, command history, and grep results quickly.
- `zoxide`: jump to project folders instantly based on usage frequency.

If your Omarchy config/aliases already define shortcuts around these tools, they should work after installing the binaries and sourcing your aliases + `zoxide init` line in shell startup.

---

## Optional: automated install script

If you prefer your script-driven approach, keep using `install-dotfiles.sh` from `omarchy-supplement` and point it to this repo URL. A minimal safe flow is:

1. verify `stow` is installed
2. clone or update `~/dotfiles`
3. remove old conflicting config paths
4. run `stow` for needed packages (`nvim`, `tmux`, `starship`, `aliases`, ...)
5. ensure `~/.aliases` is sourced by your shell startup file

---

## Troubleshooting

- **`nvim` looks different than Omarchy:**
  - confirm `~/.config/nvim` is symlinked from this repo
  - remove old `~/.local/share/nvim` and `~/.cache/nvim`, then reopen `nvim`
- **`stow` conflicts:**
  - move or remove existing target files, then run stow again
- **aliases not loaded:**
  - verify the alias source line exists in `~/.bashrc`
  - run `source ~/.bashrc`

---

## Updating later

```bash
cd ~/dotfiles
git pull
stow nvim tmux starship aliases
```

Then restart tmux/Neovim if needed.
