fpath+=( $ZDOTDIR/completions )

# zsh-autocomplete config
zstyle ':autocomplete:*' min-delay 0.18
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' list-lines 12
zstyle ':autocomplete:*' recent-dirs fasd

# Expand partial paths, i.e. cd f/b/z == cd foo/bar/baz
zstyle ':completion:*:paths' path-completion yes

# Fix slow 1-by-1 character pasting when bracketed-paste-magic is on.
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# Options
setopt COMPLETE_IN_WORD
setopt PATH_DIRS
setopt AUTO_MENU
setopt AUTO_LIST
setopt FLOW_CONTROL
unsetopt MENU_COMPLETE
unsetopt COMPLETE_ALIASES
unsetopt CASE_GLOB

# Group matches and describe
zstyle ':completion:*:corrections' format '%B%F{green}%d (errors: %e)%f%b'
zstyle ':completion:*:messages' format '%B%F{yellow}%d%f%b'
zstyle ':completion:*:warnings' format '%B%F{red}No such %d%f%b'
zstyle ':completion:*:errors' format '%B%F{red}No such %d%f%b'
zstyle ':completion:*:descriptions' format $'%{\e[35;1m%}%d%{\e[0m%}'
zstyle ':completion:*:default' format '%S%M matches%s'

# Don't complete unavailable commands
zstyle ':completion:*:functions' ignored-patterns '(_*|.*|pre(cmd|exec))'

# Populate hostname completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteressting users
zstyle ':completion:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody 'nixbld*' nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync 'systemd-*' uucp vcsa xfs '_*'
zstyle '*' single-ignored show

# Ignore multiple entries
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# SSH, SCP, Rsync
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
