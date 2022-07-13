command_not_found_handler() {
  local pkgs cmd="$1"

  pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
  if [[ -n "$pkgs" ]]; then
    printf 'The application %s is not installed. It may be found in the following packages:\n' "$cmd"
    printf '  %s\n' $pkgs[@]
    setopt shwordsplit
    pkg_array=($pkgs[@])
    pkgname="${${(@s:/:)pkg_array}[2]}"
    printf 'Do you want to Install package %s? (y/N) ' $pkgname
    if read -q "choice? "; then
    		echo
            if command -v pamac &> /dev/null; then
                echo "Executing command: pamac install $pkgname"
                pamac install $pkgname
            elif command -v yay &> /dev/null; then
                echo "Executing command: yay -Sy $pkgname"
                yay -Sy $pkgname
            else
                echo "Executing command: pacman -Sy $pkgname"
                pacman -Sy $pkgname
            fi
    else
    		echo " "
    fi
  else
    printf 'zsh: command not found: %s\n' "$cmd"
  fi 1>&2

  return 127
}

