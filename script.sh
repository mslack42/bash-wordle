secret_word="$1"
guess="$2"
word_length=5

default="\e[97m"
yellow="\e[33m"
green="\e[92m"

colour_guess() {
    uncoloured="$1"
    coloured=
    ungreens=
    for (( i=0; i<word_length; i++)); do
        guess_char=${uncoloured:$i:1}
        answer_char=${secret_word:$i:1}
        if [ "$guess_char" != "$answer_char" ]; 
        then
            ungreens+=$answer_char
        fi
    done
    for (( i=0; i<word_length; i++)); do
        guess_char=${uncoloured:$i:1}
        answer_char=${secret_word:$i:1}
        if [ "$guess_char" == "$answer_char" ]; 
        then
            coloured+="$green$guess_char$default"
            continue
        fi
        if [[ "$ungreens" == *"$guess_char"* ]];
        then
            coloured+="$yellow$guess_char$default"
            ungreens=${ungreens/"$guess_char"/}
            continue
        fi
        coloured+="$guess_char"
    done
    coloured+="$default"
    echo $coloured
}

output=$(colour_guess $guess)
printf "$output"