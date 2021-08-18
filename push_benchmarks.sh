#!/bin/bash

julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c '**Starting benchmarks!**'

julia benchmark/$1 $repo

if [ "$?" -eq "0" ] ; then
    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "Benchmark results" -g "gist.json"
else
    ERROR_LOGS="/home/jenkins/benchmarks/$org/$repo/${pullrequest}_bmark_error.log"
    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "**An error occured while running $1**" -g $ERROR_LOGS
fi
