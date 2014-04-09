#!/bin/bash

user_ids="./random_sample_users"

function create_user_ratings_files() {
  cat $user_ids | while read user_id; do echo $user_id >> $user_ratings_dir$user_id\_ratings && get_user_ratings_for_user $user_id; done
}

function get_user_ratings_for_user() {
  ls $training_set | while read movie_ratings; do grep -m 1 "\b$1," $training_set$movie_ratings /dev/null | append_to_user_movie_ratings $1; done
}

function append_to_user_movie_ratings() {
  while read movie_and_rating; do
    movie=$(echo $movie_and_rating | cut -d ':' -f1)
    rating=$(echo $movie_and_rating | cut -d ':' -f2)
  done

  if [[ ! -z $movie ]] || [[ ! -z $rating ]];
  then
    movie=$(echo $movie | cut -d '/' -f5 | cut -d '.' -f1 | sed 's/mv_\(.*\)/\1/')
    rating=$(echo $rating | cut -d ',' -f2)

    echo "$movie:$rating" >> $user_ratings_dir$1\_ratings
  fi

}

training_set=$1
user_ratings_dir=$2
create_user_ratings_files
