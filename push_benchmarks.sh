#!/bin/bash
git checkout $BRANCH_NAME --

julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c '**Starting benchmarks!**'

if [ "$?" -ne "0" ] ; then
    LOCAL_BRANCH_NAME="temp_bmark"
    git fetch origin pull/$pullrequest/head:$LOCAL_BRANCH_NAME
    git checkout $LOCAL_BRANCH_NAME --
fi

julia benchmark/$1 $repo

if [ "$?" -eq "0" ] ; then
    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "Benchmark results" -g gist.json
else
    ERROR_LOGS="/home/jenkins/benchmarks/$org/$repo/${pullrequest}_bmark_error.log"
    julia benchmark/send_comment_to_pr.jl -o $org -r $repo -p $pullrequest -c "**An error occured while running the benchmark script $1**" -g ERROR_LOGS
fi

git checkout main

git branch -D $LOCAL_BRANCH_NAME
