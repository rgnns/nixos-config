alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias q=exit
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias wget='wget -c'

alias mk=make
alias gurl='curl --compressed'

# An rsync that respects gitignore
rcp() {
  # -a = -rlptgoD
  #   -r = recursive
  #   -l = copy symlinks as symlinks
  #   -p = preserve permissions
  #   -t = preserve mtimes
  #   -g = preserve owning group
  #   -o = preserve owner
  # -z = use compression
  # -P = show progress on transferred file
  # -J = don't touch mtimes on symlinks (always errors)
  rsync -azPJ \
    --include=.git/ \
    --filter=':- .gitignore' \
    --filter=":- $XDG_CONFIG_HOME/git/ignore" \
    "$@"
}; compdef rcp=rsync
alias rcpd='rcp --delete --delete-after'
alias rcpu='rcp --chmod=go='
alias rcpdu='rcpd --chmod=go='

if (( $+commands[fasd] )); then
  unalias z 2>/dev/null
  function z {
    if [ $# -gt 0 ]; then
      fasd_cd -d "$*"
      return
    fi
    # interactive selection when given no args
    if (( $+commands[fzf] )); then
      local dir="$(fasd -l 2>&1 | fzf --reverse --inline-info +s --tac --query "${*##-* }")"
      [[ -n $dir ]] && cd $dir
    else
      fasd_cd -d -i
    fi
  }
fi

autoload -U zmv

function take {
  mkdir "$1" && cd "$1";
}; compdef take=mkdir

function zman {
  PAGER="less -g -I -s '+/^       "$1"'" man zshall;
}
