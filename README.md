# declarch - a simple declarative wrapper for any package manager

## Important Note
This is a Fork of [declaro](https://github.com/mantinhas/declaro) from [@mantinhas](https://github.com/mantinhas). So all Credit goes to mantinhas. In this Version there are minor Changes. To better to be able to distinguish it better I renamed all from declaro to declarch. But this repo will be shut down in the near future.

## Why This Project Exists

- **The Problem:** Desktop Linux systems accumulate unnecessary packages over time — apps installed briefly, forgotten, and left to clutter your system. This is a nightmare for small disks and system hygiene (run `pacman -Qq | wc -l` to see how many packages you have installed).

- **Why Current Solutions Fall Short:** Tools like NixOS are powerful but overly complex for users who don’t need complete reproducibility - just a clutter-free system.

- **Our Solution:** A powerful declarative package manager wrapper that:
    - Lets you define a clean "reset state" for your system
    - Provides tools to manage and reset your system back to that declarative state
    - Forces you to explicitly define what you want to keep, rather than what you want to remove

## Usage

### Define Your Clean System State

First, start by generating the packages list from the current list of explicitly installed packages:

```bash
declarch generate
```

This will create the `packages.list` file in `~/.config/declarch/packages.list` (you can change this location in the config file). Then, you may edit this file either manually:

```bash
sudo nano ~/.config/declarch/packages.list
```

Or by running:

```bash
declarch edit
```

Here, you can add packages you want to keep permanently, or delete packages you no longer require. The `packages.list` file format is one package per line, with optional comments:

```bash
# Creative Software
gimp
audacity # This one is for audio
blender

# Programming
bash
gcc
neovim # My favorite text editor
```

### Main Commands

- **`declarch clean`**: Removes all stray packages (installed packages not declared in `packages.list`) and installs all missing packages (packages declared in `packages.list` but not installed)
- **`declarch diff`**: Shows the difference between your current system and your `packages.list`
- **`declarch edit`**: Opens `packages.list` in your default editor (defined by `$VISUAL`)
- **`declarch export <file>`**: Export the configurations and `packages.list` to a tar.gz file
- **`declarch import <source>`**: Import a declared state from a .tar.gz file or Git repository
- **`declarch status <pkg1> [pkg2...]`**: Shows the status of packages

## Configuration

`declarch` was written to be package manager agnostic. As such, integrating with a package manager is as simple as defining three functions in a config file at `/home/mwysk/.config/declarch/config.sh`. Consider our [`apt-config.sh`](config/apt-config.sh) for Ubuntu systems:

```bash
# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo apt-get remove $@ -y
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  sudo apt-get install $@ -y
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  apt-mark showmanual
}
```

### Available Configurations

Currently, we provide config files for `apt`, `dnf`, `pacman`, `pacman-paru` and `pacman-yay` package managers, and we will keep adding more as we go. After installing, you can find these configs at:
- `/usr/local/share/declarch/config`
- `/usr/share/declarch/config`
- Or browse the repository [here](config)

### Configurations for non-supported distros

If your package manager has no configuration available, you can:

1. Copy the template config file:
```bash
sudo install -Dm644 /usr/local/share/declarch/config/template-config.sh /home/mwysk/.config/declarch/config.sh
```
2. Edit the functions to match your package manager's commands.
```bash
sudo nano /home/mwysk/.config/declarch/config.sh
```

If you would like to help us and add official support for your package manager, please open an issue or a pull request.

## Installation

### Automatic Installation

- For **Arch Linux**, you can download `declarch` from the AUR:
```bash
git clone https://aur.archlinux.org/declarch-git.git && cd declarch-git && makepkg -si
```

### Manual Installation

1. Make sure you have the following the dependencies installed:
```git bash diffutils sed findutils make sudo coreutils tar```

2. Clone the repository and install declarch:
```bash
git clone https://github.com/mantinhas/declarch.git && cd declarch && make install
```

3. Install the config file:

    - **For supported distros (Arch Linux, Ubuntu, Fedora/RHEL)**:

        - Use the script to detect and install the correct config:
        ```bash
        make install-config
        ```

    - **For non-supported distros**:

        - Copy the template config file:
        ```bash
        sudo install -Dm644 /usr/local/share/declarch/config/template-config.sh ~/.config/declarch/config.sh
        ```
        - Edit the config file to match your package manager's commands. Refer to the [Configuration Section](#configuration) for more details. 
        ```bash
        sudo nano ~/.config/declarch/config.sh
        ```

