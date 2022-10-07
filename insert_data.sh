#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNC=$($PSQL "truncate table games, teams")
echo $TRUNC

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
    then
    #table games
    #insert into table teams first, since teams is referenced by games
    #check if winner already inserted
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INS_WINNER=$($PSQL "insert into teams(name) values('$WINNER')")
      #add descriptive insert message
      if [[ $INS_WINNER == "INSERT 0 1" ]]
      then
        echo inserted $WINNER into teams
      fi

    #get new winner_id if newly inserted
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi #end -z winner_id if

    #check if opponent already inserted
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INS_OPP=$($PSQL "insert into teams(name) values('$OPPONENT')")
      #add descriptive insert message
      if [[ $INS_OPP == "INSERT 0 1" ]]
      then
        echo inserted $OPPONENT into teams
      fi
      #get opponent_id if newly inserted
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi #end -z opponent_id if    
    #done with games table

    #insert year, round, winner id, opponent id, winner goals, opponent goals
    INS_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INS_GAMES == "INSERT 0 1" ]]
    then
      echo inserted into games successfully
    else
      echo error
    fi
    
  fi # end $1 != year if
done