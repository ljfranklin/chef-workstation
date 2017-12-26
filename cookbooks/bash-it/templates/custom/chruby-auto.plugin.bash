cite about-plugin
about-plugin 'load chruby + auto-switching (from /usr/local/share/chruby)'

if [ -d /usr/local/share/chruby/ ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
elif [ -d /usr/share/chruby/ ]; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi
