#!/bin/bash

training_set="../../netflix_dataset/training_set/"
user_ids="./user_ids"
unique_user_ids="./unique_user_ids"

function get_unique_uesr_ids() {
  get_all_user_ids
  cat $user_ids | sort -n | uniq >> $unique_user_ids
}

function get_all_user_ids() {
  ls $training_set | while read movie_ratings; do fetch_user_id_and_append_it_to_user_ids $movie_ratings; done
}

function fetch_user_id_and_append_it_to_user_ids() {
  tail -n+2 $training_set$1 | cut -d ',' -f1 >> $user_ids
}

get_unique_uesr_ids
