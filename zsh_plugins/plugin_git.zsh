function gitopen() {
    git remote get-url origin | awk -F '[@:]' '{print "http://" $2 "/" $3}' | xargs open
}
