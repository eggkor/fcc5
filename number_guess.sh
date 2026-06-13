#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")

if [[ ! $USER_ID ]]; then
  ($PSQL "INSERT INTO users(name) VALUES ('$USERNAME')")>/dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  RESULT=$($PSQL "SELECT COUNT(g.game_id), MIN(g.score) FROM games g JOIN users u ON g.user_id = u.user_id WHERE u.name = '$USERNAME'")
  echo $RESULT | while IFS="|" read -r games_played best_game; do
    echo "Welcome back, $USERNAME! You have played $games_played games, and your best game took $best_game guesses."
  done
fi

SECRET_NUM=$(( RANDOM % 1000 + 1 ))
COUNTER=1

echo "Guess the secret number between 1 and 1000:"
read guess

while [[ $guess != $SECRET_NUM ]]; do
  if [[ ! $guess =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif (( $guess > $SECRET_NUM )); then
    echo "It's lower than that, guess again:"
  elif (( $guess < $SECRET_NUM )); then
    echo "It's higher than that, guess again:" 
  fi
  read guess
  (( COUNTER++ ))
done

($PSQL "INSERT INTO games(user_id, score) VALUES ($USER_ID, $COUNTER)")>/dev/null
echo "You guessed it in $COUNTER tries. The secret number was $SECRET_NUM. Nice job!"