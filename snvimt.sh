#!/bin/bash

# See: https://neovim.io/doc/user/remote.html for more info

if [[ $NVIM ]]; then
  updateCurDir() {
    # If arg starts with / its an absolute path
    if [[ $1 =~ ^[\/].* ]]; then
      newPath=$1
    else
      newPath="$(pwd)/$1"
    fi

    # Consider using :lcd instead of :tcd, its more specific
    nvim --server "$NVIM" --remote-send "<C-\><C-n><Esc><Esc><Esc>:tcd $newPath<CR>i"
    cd "$newPath"
  }
  alias cd=updateCurDir
  alias nvim="nvim --server ${NVIM} --remote"
  nvimt() {
    # nvim --server ${NVIM} --remote-tab "$@"
    DIR="$(pwd)"
    nvim --server "$NVIM" --remote-send "<Esc><Esc><Esc><C-\><C-n>"
    for filename in "$@"
    do
      # This version doesnt break when you open files after switching directories
      # nvim --server ${NVIM} --remote-tab "$filename"
      # nvim --server ${NVIM} --remote-send "<Esc><Esc><Esc><C-\><C-n>:tcd $DIR<CR>"
      # THIS DOES THE SAME THING IN ONE LINE
      # And it doesnt rely on the remote-tab command which has proven to be very goofy
      # nvim --server ${NVIM} --remote-send "<Esc><Esc><Esc><C-\><C-n>:tabnew $filename<CR>"
      nvim --server ${NVIM} --remote-send "<Esc><Esc><Esc><C-\><C-n>:tab new $filename<CR>"
    done
  }
  nvimd() {
    nvim --server ${NVIM} --remote $1
    nvim --server "$NVIM" --remote-send "<Esc><Esc><Esc>:diffthis<CR>"
    for arg in "${@:2}"
    do 
      nvim --server "$NVIM" --remote-send "<Esc><Esc><Esc>:vsplit $arg<CR>:diffthis<CR>"
    done
  }
  # echo $NVIM
  echo -e "\nWelcome to Super-NVIM-Term\n"
else 
  # WORKING
  # alias snvimt='nvim +term --listen "snvimt" && exit'

  # Add special config when snvimt starts
  # But if a user start nvim instead of snvimt, none of these changes will be applied
  # and that's not ideal
  alias snvimt='nvim +term \
    +"autocmd TabNewEntered * :term" \
    +"autocmd WinNew * :term" \
    +"autocmd TermEnter * :set nonumber norelativenumber" \
    +"autocmd TermLeave * :set number relativenumber" \
    +"tnoremap <C-\> <C-\><C-n>" \
    +"tnoremap <C-Space> <C-\><C-n>" \
    --listen "snvimt" && exit'
fi
