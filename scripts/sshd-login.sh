#!/bin/bash
# add to /sbin/, chmod +x and chown root:root
# add the following to the bottom of /etc/pam.d/sshd
# session   optional   pam_exec.so /sbin/sshd-login.sh

# Comma delimited list of IPs
WHITELIST=""
# Webhook URL to send the alert to
WEBHOOK_URL=""
# Discord user to notify and date format to use in alert
DISCORDUSER=""
DATE=$(date +"%d/%m/%y - %r")

# If the source IP is local or on the whitelist, exit early
[[ "$PAM_RHOST" = 192.168.* ]] && exit
[[ ",$WHITELIST," = *",$PAM_RHOST,"* ]] && exit

[[ "$PAM_TYPE" = "open_session" ]] && TYPE="OPENED"
[[ "$PAM_TYPE" = "close_session" ]] && TYPE="CLOSED"

if [[ -n "$TYPE" ]]; then
	PAYLOAD="{\"content\": \"$DISCORDUSER $TYPE\nUsername: \`$PAM_USER\`\nIP: \`$PAM_RHOST\`\nTime: \`$DATE\`\"}"
	curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
fi
