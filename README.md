This will send out notifications if your Eth Validator will be on the Sync Committee today
or tomorrow (current|next).
Will send out an email thet is delivered as a text to the admin of the node(s).

Steps to implement:
copy checkSyncStatus_template.sh to checkSyncStatus.sh
Update the checkSyncStatus.sh with your phone number and the validators you are running
Can send text to mutiple people who are running different validators by adding new line
and each is read in and people will only be notified if their validators are in [current|next}
sync committee.
Verizon: use phone#@vtext.com
AT&T:    use phone#@att.net
Do a google search for other carriers

Gmail does not allow emails incoming emails inittiated from a script. 
You will need to set up a mail server on your machine that will allow you to call sendemail
I used sendgrid to set up email service. 

Make sure the *.sh files are executable

to run this use command:
./checkSyncStatus.sh

Uncomment the line in syncCommittee.sh search_committee() to see list of current and next valiaators. To test: add some of these validators to checkSyncStatus.sh to validate everything is set up right.
