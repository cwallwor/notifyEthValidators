#!/usr/bin/bash

BEACON_NODE="http://localhost:5052"
INPUT_STRING=$@
echo "INPUT_STRING is " $INPUT_STRING
VALIDATOR_LIST=$(echo "$@" | tr ' ' '|')

getNth()  { shift "$(( $1 + 1 ))"; echo "$1"; }
getLast() { getNth "$(( $(length "$@") - 1 ))" "$@"; }
length()  { echo "$#"; }

length 5 $VALIDATOR_LIST
EMAIL=$(getNth 0 $INPUT_STRING)
#echo "EMAIL = " $EMAIL

send_email(){
    if [ $WHICH_SC = 'next' ] 
        then
        echo “Validator " $RESULT "will be on Sync Committee tomorrow ” | sendmail $EMAIL
    elif [ $WHICH_SC = "current" ] 
        then    
        echo “Validator " $RESULT "is in Sync Committee today ” | sendmail $EMAIL 
    fi
    echo "Sent email to" $EMAIL "for Sync Committee" $WHICH_SC " validator = " $RESULT 
}

epoch_to_time(){
    expr 1606824000 + \( $1 \* 384 \)
}

time_to_epoch(){
    expr \( $1 - 1606824000 \) / 384
}

get_committee(){
    URLSTEM="${BEACON_NODE}/eth/v1/beacon/states/finalized"
    curl -X GET "${URLSTEM}/sync_committees?epoch=$1" 2> /dev/null \
    | sed -e 's/["]/''/g' | cut -d'[' -f2 | cut -d']' -f1 | tr ',' '\n'
    echo "URLSTEM = " $URLSTEM
}

search_committee(){
    CURRENT_ONES=$(get_committee $2)
#    uncomment following line to see the validators in [current|next] Sync Committee
#    echo "Validators for " $WHICH_SC" " Sync Committee are: "CURRENT_ONES = " $CURRENT_ONES 
    MY_LENGTH=$(length $INPUT_STRING)
    a=1
    while [ $a -lt $MY_LENGTH ]
    do
        RESULT=$(getNth $a $INPUT_STRING)
#        echo "RESULT $a=  $RESULT"
        (echo $CURRENT_ONES | grep -q $RESULT) && [ $? -eq 0 ] && send_email $RESULT
        a=`expr $a + 1`
    done
}

display_epoch(){
    echo "epoch: $1 : $(date -d@$(epoch_to_time $1)) <-- $2"
}

CURR_EPOCH=$(time_to_epoch $(date +%s))
CURR_START_EPOCH=`expr \( $CURR_EPOCH / 256 \) \* 256`
NEXT_START_EPOCH=`expr $CURR_START_EPOCH + 256`
NEXTB1_START_EPOCH=`expr $NEXT_START_EPOCH + 256`

#echo
#display_epoch $CURR_START_EPOCH   "current sync committee start"
#display_epoch $CURR_EPOCH         "now"
#display_epoch $NEXT_START_EPOCH   "next sync committee start"
#display_epoch $NEXTB1_START_EPOCH "future sync committee start"
#echo
#echo "VALIDATOR_LIST= " $VALIDATOR_LIST

WHICH_SC="current"
if [ "$#" -gt 0 ]
then
    search_committee $WHICH_SC $CURR_EPOCH
    WHICH_SC="next"
    search_committee $WHICH_SC $NEXT_START_EPOCH
fi

#echo "Validator for Current Epoch = " $CURR_EPOCH '\n'
#echo "Validator for Next Epoch = " $NEXT_START_EPOCH '\n'

echo
