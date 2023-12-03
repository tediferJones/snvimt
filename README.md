# snvimt

Is it a neovim plugin or just a bash config? Hard to say

# Installation
Clone this repo and add this line to your .bashrc  
`source /PATH/TO/SNVIMT/snvimt.sh`

# Description

It is meant to allow better use of the terminal in neovim, but it can also be used as a terminal manager

Starting snvimt from the terminal will put you into a terminal session nested inside neovim
- Once you have entered an snvimt session, the snvimt command will no longer be accessible, this prevents you from accidentally creating a nested instance of neovim
- The alias itself will launch nvim with some additional autocommands:
    - When a new tab or split is opened, open a terminal window
    - When in a terminal window, toggle relative numbers when user enters/exits terminal insert mode
    - Added two custom key maps to exit terminal mode
        - Ctrl + \ and Ctrl + Space

From here, there are a few special commands:
- the cd command has been aliased so that it updates the working dir of the current neovim buffer everytime the cd command is run
- the nvim command has been aliased so that nvim FILENAME will open the file in the current tab (closing the current terminal window)
- nvimt FILENAME1 FILENAME2 will open all given files new tabs
- nvimd FILENAME1 FILENAME2 will open all given files in diff mode

By default, when you close the last remaining buffer in a snvimt session, the terminal window will also close

Multiple sessions of snvimt can be run at the same time in separate terminal windows, each session will create it's own dedicated server

If you want your terminal to always launch in snvimt mode, just add a call to snvimt at the bottom of your .bashrc file

This work flow has a few specific benefits:
- You can use the terminal inside neovim to open files without creating a nested instance of neovim
    - Especially useful for opening files from an entirely different directory in the same window
- Having access to the full range of vim motions in the terminal is very handy
    - Easily copy/paste terminal outputs
    - Easily search through terminal output
- This allows you to essentially use neovim plugins from the terminal
    - For example: You can cd into a specific directory and then use telescope's fuzzy finder to find/open a specific file
- This allows you to have one set of key binds in mind when using the terminal or neovim
    - Very convenient if you need to manage multiple terminal windows

---

This is entirely dependent on Neovim Remote, for more click here: https://neovim.io/doc/user/remote.html
