#!/bin/bash

# PSQL variable for executing queries, suppressing "INSERT 0 1" output
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate a random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Prompt for username
echo -n "Enter your username: "
read USERNAME

# Truncate username to max 22 characters
USERNAME=${USERNAME:0:22}

# Check if the user exists and retrieve game stats
USER_DATA=$($PSQL "SELECT u.user_id, COUNT(g.game_id), MIN(g.no_of_guesses) FROM users u LEFT JOIN games g ON u.user_id = g.user_id WHERE u.name='$USERNAME' GROUP BY u.user_id;")

if [[ -z "$USER_DATA" ]]; then
    # New user: Insert into users table (suppress output)
    $PSQL "INSERT INTO users (name) VALUES ('$USERNAME');" >/dev/null
    echo "Welcome, $USERNAME! It looks like this is your first time here."
else
    # Existing user: Extract details
    USER_ID=$(echo "$USER_DATA" | cut -d '|' -f 1)
    GAMES_PLAYED=$(echo "$USER_DATA" | cut -d '|' -f 2)
    BEST_GAME=$(echo "$USER_DATA" | cut -d '|' -f 3)

    # Display the message
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Start the guessing game
echo "Guess the secret number between 1 and 1000:"
GUESS_COUNT=0

while true; do
    read GUESS

    # Check if input is an integer
    if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        continue
    fi

    GUESS=$((GUESS))  # Convert to integer
    ((GUESS_COUNT++))  # Increment guess count

    if [[ $GUESS -lt $SECRET_NUMBER ]]; then
        echo "It's higher than that, guess again:"
    elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
        echo "It's lower than that, guess again:"
    else
        echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
        break
    fi
done

# Get user ID again (in case it was just created)
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME';")

# Insert game result into the database (suppress output)
$PSQL "INSERT INTO games (user_id, no_of_guesses, secret_number) VALUES ($USER_ID, $GUESS_COUNT, $SECRET_NUMBER);" >/dev/null

exit 0
