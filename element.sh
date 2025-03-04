#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query the database for the element
RESULT=$($PSQL "
  SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
  FROM elements
  INNER JOIN properties USING(atomic_number)
  INNER JOIN types USING(type_id)
  WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name ILIKE '$1';
")

# Check if the query returned a result
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse the result
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

# Round atomic mass to 3 decimal places
ROUNDED_MASS=$(printf "%.3f" "$MASS")

# Output the formatted result
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ROUNDED_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
