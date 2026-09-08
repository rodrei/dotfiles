# Docker Desktop installs CLI completions into ~/.docker/completions.
# Adding the dir to fpath here (before compinit runs) is all that's needed.
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)
