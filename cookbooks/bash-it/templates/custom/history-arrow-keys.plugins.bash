cite about-plugin
about-plugin 'Search backwards and fowards in history with arrow keys'

# If running in interactive terminal
if [ -t 1 ]; then
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'
fi
