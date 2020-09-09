#!/bin/zsh
#taproot_path="../../Taproot/"
taproot_path="../materials/Taproot"
while true; do
    echo "\n\n\nLog for attempt at $(date)" >> log.txt
    git pull >> log.txt

    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Log for attempt at $(date)" > recent_errors.txt
        make >> log.txt 2>>recent_errors.txt

        (git add -A >> log.txt && \
        git reset -- log.txt >> log.txt && \
        git commit -m "automated compilation" >> log.txt && \
        git push --quiet) && \
        printf "Synced and commited at $(date)\r" || printf "Sync Failed!!! $(date)"
    else
        echo "Nothing to sync at $(date)        \r"
    fi

    sleep 18
done
