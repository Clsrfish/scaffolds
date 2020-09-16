function gitopen() {
    git remote get-url origin | awk -F '[@:]' '{print "http://" $2 "/" $3}' | xargs open
}

function git_tags() {
  git log --date-order --graph --tags --simplify-by-decoration --pretty=format:'%ai %h %d'
}
