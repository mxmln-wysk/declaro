KEEPLISTFILE="/home/mwysk/.config/declarch/packages.list"
MODULELISTFILE="/home/mwysk/.config/declarch/modules.list"

# Command to uninstall a package and its dependencies (no confirm/user prompts)
UNINSTALL_COMMAND () {
  sudo pacman -Rns --noconfirm $@
}
# Command to install a package and its dependencies (no confirm/user prompts)
INSTALL_COMMAND () {
  paru -S --noconfirm $@
}
# Command to list all manually/explicitely installed packages
LIST_COMMAND () {
  pacman -Qqe
}
