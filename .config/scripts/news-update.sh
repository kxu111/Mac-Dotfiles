#!/bin/bash
# Check if Newsboat is available
if ! command -v newsboat &> /dev/null; then
    echo "Error: Newsboat is not installed or not in PATH" >&2
    exit 1
fi

# Function to get the current number of unread articles
get_unread_count() {
    newsboat -x print-unread 2>/dev/null | grep -oE '[0-9]+' || echo "0"
}

echo "Checking for new articles..."

# Get the unread count *before* reloading
unread_before=$(get_unread_count)

# The '-x reload' command fetches updates and exits without opening the interface
newsboat -x reload

# Get the unread count *after* reloading
unread_after=$(get_unread_count)

# Compare the counts and notify if there are new articles
if [ "$unread_after" -gt "$unread_before" ]; then
    new_articles=$((unread_after - unread_before))
    echo "New articles detected: $new_articles"
    
    osascript -e "display notification \"$new_articles new article(s)\" with title \"Newsboat\""
else
    echo "No new articles."
fi
