#!/bin/bash

user_ratings_1000="./user_ratings_1000/"
user_ratings_2000="./user_ratings_2000/"
user_ratings="./user_ratings/"

function merge_user_ratings() {
  ls $user_ratings_1000 | while read rating_file; do write_merged_ratings_to_new_file $rating_file; done
}

function write_merged_ratings_to_new_file() {
  cat $user_ratings_1000$1 | while read line; do echo $line >> $user_ratings$1; done
  tail -n+2 $user_ratings_2000$1 | while read line; do echo $line >> $user_ratings$1; done
}

merge_user_ratings
