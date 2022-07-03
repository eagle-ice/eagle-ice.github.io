#!/bin/bash

file_path=_posts
function help_fun()
{
    echo "ex:./create_blog.sh \"title\" \"categories\" \"tags\""
    exit
}

#categories_list=
#tags_list=
blog_head_template="---
title: 
date: 
link:
tags:
categories:
description:
---
"

blog_head_template1="---"
function create_blog_file()
{
    if [ ! -f ${1} ]; then
        echo "create ${1}"
        echo "$blog_head_template" > ${1}
    else
        #while read line
        #do
        #    echo "$line"
        #    if [ x$line != x"---" ];then
        #        sed -i "1 i ${blog_head_template[0]}" $1
        #    fi
        #    break
        #done < $1
        echo "Please re-enter the file if it already exists!!"
        echo "file_name = $1"
        exit -1
    fi
}
function create_blog_head()
{
    echo "title = $1"
    echo "categories = $2"
    echo "tags = $3"
    echo "file_name = $4"
    sed -i "s/title:.*/title: $1/g" $4
    sed -i "s/date:.*/date: $(date +"%Y-%m-%d %H:%M:%S")/g" $4
    sed -i "s/categories:.*/categories: $2/g" $4
    sed -i "s/tags:.*/tags: $3/g" $4
}

title=$1
categories=$2
tags=$3
echo "$# ${categories} ${tags}"
if [ $# -ne 3 ]; then
    help_fun
fi
file_name=`date +"%Y-%m-%d"`-${title}.md

create_blog_file "${file_path}/${file_name}"
create_blog_head "$title" "$categories" "$tags" "${file_path}/$file_name"
