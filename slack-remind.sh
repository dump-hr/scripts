#!/bin/sh
#
# slack remind cli

tokenlocation=~/.slack-remind-token

_tokenset() {
	printf "%s" "Enter Slack user token: "
	read -r token
	echo "$token" > $tokenlocation
}

_tokenget() {
	cat $tokenlocation
}

if [ $# -eq 0 ]; then
	echo "slack remind cli"
	echo
	echo "  -m --message"
	echo "  -t --time"
	echo "  -u --user"
	exit 1
fi

while test $# -gt 0; do
	case "$1" in
		-m|--message) shift; MESSAGE="$1";;
		-t|--time) shift; TIME="$1";;
		-u|--user) shift; USER="$1";;
	esac
	shift
done

[ -s $tokenlocation ] || _tokenset

if [ -n "$USER" ]; then
	USERID=$(
		curl -s -H "Authorization: Bearer $(_tokenget)" https://slack.com/api/users.list \
		| jq -r ".members[]|select(.profile.display_name==\"$USER\").id"
	)
fi

curl -X POST -H "Authorization: Bearer $(_tokenget)" \
     -F "text=$MESSAGE" -F "time=$TIME" -F "user=$USERID" \
     https://slack.com/api/reminders.add

echo
