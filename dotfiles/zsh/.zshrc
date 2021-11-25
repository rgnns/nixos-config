source $ZDOTDIR/config.zsh

[ -d "$ZGEN_DIR" ] || git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
source $ZGEN_DIR/zgenom.zsh

zgenom autoupdate

if ! zgenom saved; then
  echo "Initializing zgenom"
  rm -f $ZDOTDIR/*.zwc(N) \
        $XDG_CACHE_HOME/zsh/*(N) \
        $ZGEN_INIT.zwc

  zgenom load junegunn/fzf shell
  zgenom load zdharma-continuum/fast-syntax-highlighting
  zgenom load zdharma/history-search-multi-word
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-completions src

  zgenom save
  zgenom compile $ZDOTDIR
fi

if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/keybinds.zsh
  source $ZDOTDIR/completion.zsh
  source $ZDOTDIR/aliases.zsh

  export PROMPT="%B%m %~ $%b%{$reset_color%} ";

  _source $ZDOTDIR/extra.zshrc
  _source $ZDOTDIR/local.zshrc

  _cache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}

  autoload -Uz compinit && compinit -u -d $ZSH_CACHE/zcompdump
fi
