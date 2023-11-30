copy checkSyncStatus_template.sh to checkSyncStatus.sh
Update the checkSyncStatus.sh with your phone number and the validators you are running
Verizon: use phone#@vtext.com
AT&T:    use phone#@att.net
Do a google search for other carriers

Gmail does not allow emails from this script
You will need to set up a mail server on your machine that will allow you to call sendemail

Make sure the *.sh files are executable

to run this use command:
./checkSyncStatus.sh

Uncomment the line in syncCommittee.sh search_committee() to see list of current and next valiaators. To test: add some of these validators to checkSyncStatus.sh to validate everything is set up right.
