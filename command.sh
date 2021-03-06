#!/bin/zsh
#taproot_path="../../Taproot/"
taproot_path="../materials/Taproot"
BUILDNUMBER_FILE='buildID.txt'
while true; do
    printf "working...                                              \r"
    echo "\n\n\nLog for attempt at $(date)" >> log.txt
    #git pull >> log.txt

    changes="$(git status --porcelain | cut -c4-)"

    if [[ -n "$changes" ]]; then
        echo "Log for attempt at $(date)" > recent_errors.txt
        find . -type f -name '*.md' -exec sed -i'' -e 's/\/Users\/houliu\/Documents\/School Work\/2020\-2021\/KnowledgeBase/./g' {} +

        for f in ${(@f)$(echo $changes |  grep -E '(\.md|\.org)$')}; do
            echo "Converting $f to ${f%.*}.{pdf, latex, html} failed"
            #pandoc -f markdown -t pdf   $f --pdf-engine=xelatex --mathjax -o "${f%.*}.pdf"   --template=./meta/templates/default.latex --resource-path=$(call SUBJECT,"${f%.*}")
            #pandoc -f markdown -t latex $f --pdf-engine=xelatex --mathjax -o "${f%.*}.latex" --template=./meta/templates/default.latex --resource-path=$(call SUBJECT,"${f%.*}")
            #pandoc -f latex    -t html  $f --pdf-engine=xelatex --mathjax -o "${f%.*}.html"  --template=./meta/templates/default.html --resource-path=$(call SUBJECT,"${f%.*}")
            pandoc -f markdown -t pdf   $f --pdf-engine=xelatex --mathjax -o "${f%.*}.pdf"
            pandoc -f markdown -t latex $f --pdf-engine=xelatex --mathjax -o "${f%.*}.latex"
            pandoc -f latex    -t html  $f --pdf-engine=xelatex --mathjax -o "${f%.*}.html"
        done

        #if make >> log.txt 2>>recent_errors.txt; then
        #    [[ -f $BUILDNUMBER_FILE ]] || echo 0 > $BUILDNUMBER_FILE;
        #    echo $(( $(cat $BUILDNUMBER_FILE) + 1 )) > $BUILDNUMBER_FILE
        #fi


        (git add -A >> log.txt && \
        git reset -- log.txt >> log.txt && \
        git commit -m "b$(cat buildID.txt): $(echo $changes | paste -sd ', ' -) $(printf "\n(\n")automated compilation $(cat buildID.txt))" >> log.txt && \
        git push --quiet) && \
        printf "Synced and commited at $(date)\r" || printf "Sync Failed!!! $(date)"
    else
        printf "Nothing to sync at $(date)         \r"
    fi

    sleep 20
done

