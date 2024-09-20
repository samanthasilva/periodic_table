#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # Argument is a number
    QUERY="SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
           FROM elements e 
           JOIN properties p ON e.atomic_number=p.atomic_number 
           JOIN types t ON p.type_id=t.type_id 
           WHERE e.atomic_number = $1"
  else
    # Argument is a string (symbol or name)
    QUERY="SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
           FROM elements e 
           JOIN properties p ON e.atomic_number=p.atomic_number 
           JOIN types t ON p.type_id=t.type_id 
           WHERE e.symbol = '$1' OR e.name = '$1'"
  fi

  ELEMENT=$($PSQL "$QUERY")

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi