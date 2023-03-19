#!/bin/bash
# shatgpt v0.1
# Made by Dr. Waldijk
# ChatGPT CLI.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
GPTNAM="shatgpt"
GPTVER="0.1"
GPTCON=$@
# Dependency ------------------------------------------------------------------------
if [[ ! -e /usr/bin/jq ]]; then
    echo "You need to install jq."
    exit
fi
if [[ ! -e /usr/bin/curl ]]; then
    echo "You need to install curl."
    exit
fi
# API Key ---------------------------------------------------------------------------
if [[ ! -d $HOME/.shatgpt ]]; then
    mkdir $HOME/.shatgpt
    read -p "Enter your ChatGPT API key: " GPTKEY
    echo "$GPTKEY" > $HOME/.shatgpt/api_key
fi
GPTKEY=$(cat $HOME/.shatgpt/api_key)
# Functions -------------------------------------------------------------------------
chatgpt() {
    curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GPTKEY" \
        -d "$(shatgpt)"
}
shatgpt () {
cat <<EOF
    {
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "user", "content": "$GPTCON"}]
    }
EOF
}
# -----------------------------------------------------------------------------------
if [[ -n $GPTCON ]]; then
    # echo -n "$GPTCON"
    # chatgpt | jq -r .choices[].message.content | tr -d '\n' | sed -r 's/(.*)/\1\n/'
    #chatgpt | jq -r
    echo $(chatgpt | jq -r .choices[].message.content)
else
    echo "$GPTNAM v$GPTVER"
    echo ""
    echo "You need to enter a prompt..."
fi
