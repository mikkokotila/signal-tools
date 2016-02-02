while read HANDLE
  do
    curl -s https://www.twitteraudit.com/$HANDLE | grep data-value | cut -d '>' -f1 | cut -d '=' -f3 | tr '\n' '/' | sed 's/\/$//' | bc
  done <twitteraudit.input
