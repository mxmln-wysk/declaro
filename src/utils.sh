#!/usr/bin/env bash

SUDO=${SUDO:-"sudo"}
ETC_DECLARCH_DIR=${ETC_DECLARCH_DIR:-"/home/mwysk/.config/declarch"}
DECLARCHCONFFILE=${DECLARCHCONFFILE:-"${ETC_DECLARCH_DIR}/config.sh"}
SHRDIR=$(realpath "$(dirname $BASH_SOURCE)/../..")

function LOAD_DECLARCHCONFFILE {
  if [ ! -f "$DECLARCHCONFFILE" ] && [ "$DECLARCHCONFFILE" = "/home/mwysk/.config/declarch.config.sh" ]; then
    echo "Error: Missing config file at \"/home/mwysk/.config/declarch/config.sh\"." >&2
    echo "To fix this, either install the correct configuration:" >&2
    echo -e "\tsudo install -Dm644 $SHRDIR/declarch/config/<your-config-file>.sh /home/mwysk/.config/declarch/config.sh" >&2
    echo "Or if there isn't a correct one, create one based on our provided template:" >&2
    echo -e "\tsudo install -Dm644 $SHRDIR/declarch/config/template-config.sh /home/mwysk/.config/declarch/config.sh" >&2
    exit 1
  else
    # If the config file exists or is a custom path, use it
    source "$DECLARCHCONFFILE" 2>/dev/null
  fi
}

# If KEEPLISTFILE is not set, use the default /etc location
KEEPLISTFILE=${KEEPLISTFILE:-"${ETC_DECLARCH_DIR}/packages.list"}
MODULELISTFILE=${MODULELISTFILE:-"${ETC_DECLARCH_DIR}/modules.list"}

# Set locale to C to make sort consider '-' and '+' as characters
export LC_COLLATE=C

function ASSERT_KEEPFILE_EXISTS {
  if [ ! -f $KEEPLISTFILE ]; then
    echo "Error: Missing packages.list at \"$KEEPLISTFILE\"." >&2
    echo "To fix this error, run 'declarch generate' to create a new packages.list." >&2
    exit 1
  fi
}

function parse_keepfile {
  # Remove comments, remove whitespace and remove empty lines, then sort
  sed -e 's/#.*$//' -e 's/[ \t]*//g' -e '/^\s*$/d' $1 | sort
}

function combine_keepfiles {
  # read modulelist and combine all lists
  while read -r line; do parse_keepfile  "$ETC_DECLARCH_DIR$line"; done <<< $(parse_keepfile $MODULELISTFILE)
}

# Prints the packages in one and not the other, and vice-versa
function diff_keepfile_installed {
  diff -u <(LIST_COMMAND | sort) <(combine_keepfiles | sort) | sed -n "/^[-+][^-+]/p" | sort
  
}

# Get KEEPLIST pkgs that are not installed
function get_missing_pkgs {
  #have to use same sorting because of hyphens)
  diff_keepfile_installed | sed -n '/^+/s/^+//p'
}

# Get installed pkgs not in keeplist.
function get_stray_pkgs {
  diff_keepfile_installed | sed -n '/^-/s/^-//p'
}

# Queries the packages list for the ARGV packages, and returns their state
# Prints only the packages either in both (space) or only in input (plus)
function query_pkgslist {
  diff -u <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort) | sed -n "/^[ +][^+]/p"
}

# Get input pkgs that are not in KEEPLIST
function filter_undeclaredpkgs {
  comm -13 <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort)
}

# Get input pkgs that are in KEEPLIST
function filter_declaredpkgs {
  comm -12 <(parse_keepfile $KEEPLISTFILE) <(echo $@ | tr ' ' '\n' | sort)
}
