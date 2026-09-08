# Homebrew ships zsh completions for brew itself and many installed formulae.
# Put site-functions on fpath (before compinit) so those are picked up instead
# of vendored copies going stale in this repo.
for dir in /opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions; do
  [[ -d $dir ]] && fpath=($dir $fpath)
done
unset dir
