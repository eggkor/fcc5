#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_EXISTS=$($PSQL "SELECT name FROM users WHERE name = '$USERNAME'")

if [[ ! $USER_EXISTS ]]; then
  echo "Welcome, $USERNAME It looks like this is your first time here."
else
  RESULT=$($PSQL "SELECT COUNT(g.game_id), MAX(g.score) FROM games g JOIN users u ON g.user_id = u.user_id WHERE u.name = '$USERNAME'")
  echo $RESULT | while IFS="|" read -r games_played best_game; do
    echo "Welcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."
  done
fi