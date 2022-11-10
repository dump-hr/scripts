#!/bin/sh
#
# pipe messages to slack

tokenlocation=~/.slack-pipe-token

_tokenset() {
	printf "%s" "Enter Slack user/bot token: "
	read -r token
	echo "$token" > $tokenlocation
}

_tokenget() {
	cat $tokenlocation
}

if [ $# -eq 0 ]; then
	echo "pipe messages to slack"
	exit 1
fi

if ! [ -s $tokenlocation ] && [ -z $MESSAGE ]; then
	_tokenset
fi

MESSAGE=$(</dev/stdin)

USERID=$(
	curl -s -H "Authorization: Bearer $(_tokenget)" https://slack.com/api/users.list \
	| jq -r ".members[]|select(.profile.display_name==\"$1\").id"
)
CHANNELID=$(
	curl -s -H "Authorization: Bearer $(_tokenget)" -F "limit=1000" https://slack.com/api/conversations.list \
	| jq -r ".channels[]|select(.name==\"$1\").id"
)
RECIPIENT=${USERID:-$CHANNELID}

curl -X POST -H "Authorization: Bearer $(_tokenget)" \
     -F "text=$MESSAGE" -F "channel=$RECIPIENT" \
     https://slack.com/api/chat.postMessage

echo
