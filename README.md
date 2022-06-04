# dotfiles

A collection of my dotfiles. Managed using a bare Git repository.

## Usage

1. Clone to a new computer

```sh
git clone --bare https://github.com/mikkoskela/dotfiles.git ~/.dotfiles
```

2. Set alias

```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

3. Hide untracked files

```sh
dotfiles config --local status.showUntrackedFiles no
```

