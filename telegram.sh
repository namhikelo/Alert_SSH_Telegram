#!/bin/bash
TOKEN="<TOKEN>"
CHAT_ID="<ID>"
TIMEOUT="10"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
DATE_EXEC="$(date "+%d-%b-%Y || %H:%M")"

if [ -n "$SSH_CLIENT" ]; then
    IP=$(echo $SSH_CLIENT | awk '{print $1}')
    PORT=$(echo $SSH_CLIENT | awk '{print $3}')
    HOSTNAME=$(hostname -f)
    USER=$(whoami)
    TIME=${DATE_EXEC}
    LOCATION=$(curl http://ipinfo.io/$IP -s | jq -r '.org , .city, .country' | sed 's/"//g' | paste -sd, -)

    if [ -n "$LOCATION" ]; then
        LOCATION="🌍 Location: $LOCATION"
    fi

    TEXT=$(echo -e "🆘 New SSH login 🆘\n🖥 Server: $HOSTNAME\n🥷 User: $USER\n⌚ Time: $TIME\n🌐 IP: $IP\n🔒 Port (SSH): $PORT\n$LOCATION")

    curl -s -X POST --max-time $TIMEOUT $URL -d "chat_id=$CHAT_ID" -d text="$TEXT" > /dev/null
fi
