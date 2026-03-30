# Omarchy Dotfiles (SSH + Neovim setup)

If you already use an `install-dotfiles.sh` script with GNU Stow in your `omarchy-supplement` repo, this guide gives you a repeatable way to get the same editing experience on other servers.

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
stow bashrc
```

If you use Ghostty on that machine too:

```bash
stow ghostty
```


# Needs checking with `install-hyprland-overrides.sh` from repo `omarchy-supplement`

(currently with stow) 
```bash
stow hyprland
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

### 4.2) Enable `starship` prompt in Bash (if installed)

If `which starship` returns a binary path but your prompt never changes, you're likely
missing the shell init line.

Add this once to `~/.bashrc`:

```bash
grep -Fxq 'eval "$(starship init bash)"' ~/.bashrc || echo 'eval "$(starship init bash)"' >> ~/.bashrc
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
