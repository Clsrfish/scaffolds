#!/bin/bash
source $(dirname $0)/notify.sh

title="Off Work"
subtitle="该下班惹~~~"
content="Hi,Pikachu. Are you off work?"
notify "${title}" "${subtitle}" "${content}"
# say "${content}"
