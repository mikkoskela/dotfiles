# dotfiles

A collection of my dotfiles. Managed using a bare Git repository.

Alias for managing the files: `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

When cloned to a new computer, hide untracked files with:

`dotfiles config --local status.showUntrackedFiles no`

