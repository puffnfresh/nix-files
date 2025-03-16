#!/usr/bin/env bash

set -e

listgpg () {
	mapfile -d '' pw_list < <(find -L . -name '*.gpg' -print0)
	pw_list=("${pw_list[@]#./}")
	printf '%s\n' "${pw_list[@]}" | sort -n
}

list_passwords() {
	cd "$PASSWORD_STORE_DIR" || exit
	mapfile -t pw_list < <(listgpg)
	printf '%s\n' "${pw_list[@]%.gpg}" | sort -n
}

selection="$(list_passwords | wofi -di)"
pass -c "$selection" >/dev/null
