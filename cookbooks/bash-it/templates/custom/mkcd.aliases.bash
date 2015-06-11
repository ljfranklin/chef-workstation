cite 'about-alias'
about-alias 'mkcd -> mkdir then cd'

function mkcd_func() { mkdir -p "$@" && cd "$@"; }
alias mkcd='mkcd_func'
