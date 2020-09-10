#!/bin/zsh
#taproot_path="../../Taproot/"
taproot_path="../materials/Taproot"
while true; do
    printf "working...                                              \r"
    echo "\n\n\nLog for attempt at $(date)" >> log.txt
    git pull >> log.txt

    changes="$(git status --porcelain | cut -c4- | paste -sd ' ' -)"

    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Log for attempt at $(date)" > recent_errors.txt
        make >> log.txt 2>>recent_errors.txt

        #	echo "<option value='$(call TARGET,$@)'>$(call TAG,$@)</option>" >> tags.html
#	echo "<option value='$(call TAG,$@)'>$(call TARGET,$@)</option>" >> backtrack.html


        (git add -A >> log.txt && \
        git reset -- log.txt >> log.txt && \
        git commit -m "b$(cat buildID.txt): $changes $(printf "\n(\n")automated compilation $(cat buildID.txt))" >> log.txt && \
        git push --quiet) && \
        printf "Synced and commited at $(date)\r" || printf "Sync Failed!!! $(date)"
    else
        printf "Nothing to sync at $(date)         \r"
    fi

    sleep 20
done

