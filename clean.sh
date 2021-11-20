#!/usr/bin/env bash

mkdir -p cleaned

# Fork-Awesome
URL="https://raw.githubusercontent.com/ForkAwesome/Fork-Awesome/master/css/fork-awesome.css"
curl -sL "$URL" |\
  perl -0777 -pe 's|(\.fa-.+?),\n|\1 |g' |\
  perl -0777 -pe 's|:before {.*?content: "\\(.+?)".+?}|:before \\u\1|gs' |\
  perl -0777 -pe 's|\.fa-(.+?):before|\1|g' |\
  grep '\\u' |\
  perl -0777 -pe 's|(.+) (\\u.+)|\2 \1|g' |\
  xargs -0 printf "%b" > cleaned/forkawesome-list

# Font-Awesome
URL="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/v4.7.0/css/font-awesome.css"
curl -sL "$URL" |\
  perl -0777 -pe 's|(\.fa-.+?),\n|\1 |g' |\
  perl -0777 -pe 's|:before {.*?content: "\\(.+?)".+?}|:before \\u\1|gs' |\
  perl -0777 -pe 's|\.fa-(.+?):before|\1|g' |\
  grep '\\u' |\
  perl -0777 -pe 's|(.+) (\\u.+)|\2 \1|g' |\
  xargs -0 printf "%b" > cleaned/fontawesome-list

# Emojis
URL="https://www.unicode.org/Public/emoji/latest/emoji-test.txt"
curl -sL "$URL" |\
  grep -E '^[[:alnum:]]{4,5}\s+; fully-qualified.*$' |\
  perl -pe 's|^[^#].*fully\-qualified.*# ([^ ]+) ([^ ]+) (.*)|\1 \3|g' > cleaned/emoji-list

# concat
#cat cleaned/* > symbols
cat cleaned/* | awk -e '{print NR, $0}' | sort -t ' ' -k 3 -u | sort -g -t ' ' -k 1 | cut -d ' ' --complement -f 1 > symbols
