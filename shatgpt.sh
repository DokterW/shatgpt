#!/bin/bash
# shatgpt
# Made by Dr. Waldijk
# ChatGPT CLI.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
GPTNAM="shatgpt"
GPTVER="0.3"
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
elif [[ ! -f $HOME/.shatgpt/api_key ]]; then
    read -p "Enter your ChatGPT API key: " GPTKEY
    echo "$GPTKEY" > $HOME/.shatgpt/api_key
fi
GPTKEY=$(cat $HOME/.shatgpt/api_key)
# Functions -------------------------------------------------------------------------
# curl https://api.openai.com/v1/chat/completions \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer $OPENAI_API_KEY" \
#   -d '{
#     "model": "gpt-3.5-turbo",
#     "messages": [{"role": "user", "content": "Hello!"}]
#   }'
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
    GPTRSP=$(chatgpt)
    GPTERR=$(echo $GPTRSP | jq -r .error.message)
    # echo $GPTRSP | jq -r
    # echo $GPTERR | jq -r
    if [[ "$GPTERR" != "null" ]]; then
        echo $GPTERR
    else
        echo $GPTRSP | sed -r 's/\"\\n\\n/\"/g' | jq -r .choices[].message.content
    fi
else
    echo "$GPTNAM v$GPTVER"
    echo ""
    echo "You need to enter a prompt..."
fi
