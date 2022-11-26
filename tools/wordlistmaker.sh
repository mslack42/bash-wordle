wordlength=$1
awk -v wordlength=$wordlength 'length($0) == wordlength' allwords > "./wordlists/$wordlength"