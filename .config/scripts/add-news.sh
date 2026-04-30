#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 <url_to_append>"
	exit 1
fi

text="$1"
echo "$text" >> ~/.config/newsboat/urls

echo "Text appended to ~/.config/newsboat/urls"
