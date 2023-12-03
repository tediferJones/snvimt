#!/bin/bash

# If $NVIM exists, we are already in a neovim terminal, otherwise start nvim server
# If we are in a neovim terminal then do the following: 
#   alias cd so that it updates nvim working dir as we navigate around
#   alias nvim so that it sends the file to server instead of nesting it inside the terminal
#
# See: https://neovim.io/doc/user/remote.html for more info

# Use :diffthis to find difference between files

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
  # WE NEED TO RUN :tabdo :set relativenumber after nvimt, otherwise buffers opened after the first buffer wont have line numbers
  # alias nvimt="nvim --server ${NVIM} --remote-tab"
  # Need to either find a way to send server the -O flag, or just use nvimt command and then merge tabs into one window
  # alias nvimd="nvim -O +':windo diffthis' --server ${NVIM} --remote"
  nvimt() {
    # WORKING, but tabs dont get inserted in the right order
    # echo "$BASH_SOURCE"
    # echo realpath "$1"
    # DIR="$( cd "$( dirname "$1" )" && pwd )"
    # echo 'REAL PATH'
    # # THIS WORKS
    # DIR="$(dirname "$( realpath "$1" )")"
    # echo "${DIR}"
    # echo "$@"
    # echo "$(pwd)"

    # THIS WORKS BETWEEN DIRECTORIES
    # But if you open more than 1 tab the rest of the tabs get put at the end of the tablist
    # It also changes all directories that are currently open to the new directory, which seems very odd
    # nvim --server ${NVIM} --remote-tab "$@"

    # Apparently we dont need this?
    # nvim --server "$NVIM" --remote-send "<C-\><C-n><Esc><Esc><Esc>:tabdo set number relativenumber<CR>"
    #
    # TESTING
    # Exit terminal mode manually, using --remote-tab doesnt trigger TermLeave autocmd to set number and relativenumber

    DIR="$(pwd)"
    nvim --server "$NVIM" --remote-send "<Esc><Esc><Esc><C-\><C-n>"
    for filename in "$@"
    do
      # OLD BUT WORKING
      # nvim --server ${NVIM} --remote-tab "$filename"

      # This version doesnt break when you open files after switching directories
      nvim --server ${NVIM} --remote-tab "$filename"
      nvim --server ${NVIM} --remote-send "<Esc><Esc><Esc><C-\><C-n>:tcd $DIR<CR>"
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

  # SEND VIM CONFIG ADDITIONS SOMEWHERE HERE
  # nvim --server "$NVIM" --remote-send "<Esc><Esc><Esc><C-\><C-n>\
  #   :echo 'hello' | \
  #   :echo 'goodbye' \
  #   <CR>"
else 
  # You can insert a path instead of just a string, 
  # Then the server will create .pipe file and listen at that 'address'
  # nvim +term --listen "snvimt" && exit

  # WORKING
  # alias snvimt='nvim +term --listen "snvimt" && exit'

  #   +"autocmd TermOpen * startinsert" \
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

  # snvimt() {
  #   nvim +term --listen "snvimt" && exit
  # }
fi
# Maybe bind something to <C-\><C-n>:qa so it closes the window


