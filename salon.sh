#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"


MAIN_MENU() {
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done
read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
  1) SERVICE ;;
  2) SERVICE ;;
  3) SERVICE ;;
  *) MAIN_MENU "I could not find that service. What would you like today?"
esac
}
SERVICE() {
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE';")
#if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
  #get new customer name
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  #insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
fi
echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
read SERVICE_TIME
# get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE';")
#insert new appointment
INSERT_SERVICE_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}


MAIN_MENU