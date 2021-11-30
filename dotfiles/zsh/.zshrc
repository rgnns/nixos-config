source $ZDOTDIR/config.zsh

[ -d "$ZGEN_DIR" ] || git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
source $ZGEN_DIR/zgenom.zsh

if ! zgenom saved; then
  echo "Initializing zgenom"
  rm -rf $ZDOTDIR/*.zwc(N) \
         $XDG_CACHE_HOME/zsh/*(N) \
         $ZGEN_INIT.zwc

  zgenom load hlissner/zsh-autopair autopair.zsh
  zgenom load junegunn/fzf shell
  zgenom load marlonrichert/zsh-autocomplete zsh-autocomplete.plugin.zsh
  zgenom load zdharma-continuum/fast-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions src
  zgenom load zsh-users/zsh-history-substring-search

  zgenom save
  zgenom compile $ZDOTDIR
fi

if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/keybinds.zsh
  source $ZDOTDIR/completion.zsh
  source $ZDOTDIR/aliases.zsh

  export PROMPT="%B%~ $%b%{$reset_color%} "
  export RPROMPT=""

  _source $ZDOTDIR/extra.zshrc
  _source $ZDOTDIR/local.zshrc

  _cache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}

  autoload -Uz compinit && compinit -u -d $ZSH_CACHE/zcompdump
  autopair-init

  eval "$(direnv hook zsh)"
fi
