trap clear EXIT

# game_start=$(date +%s%N)
guessed=0
max_guesses=$1
word_length=$2
game=

get_secret_word() {
    secret_word=$(shuf -n 1 "./wordlists/$word_length")
}
get_secret_word

#Display constants
red="\e[31m"
default="\e[97m"
yellow="\e[33m"
green="\e[92m"

redraw() {
    clear
    echo "Let's play Wordle! ($guessed/$max_guesses guesses, $word_length-letter words)"
    printf "$game"
    if [ ! -z "$warning" ]; then
        echo -e "$red$warning$default"
    fi
    warning=
    warning_reason=
}

is_valid () {
    test_string="$1"
    echo ${#test_string}
    echo $word_length
    if [[ ${#test_string} -ne $word_length ]];
    then
        warning_reason="Incorrect word length"
        false
        return
    fi
    if [[ ! "$test_string" =~ ^[a-zA-Z]*$ ]];
    then
        warning_reason="Letters only, please!"
        false
        return
    fi
    if [ $(echo "${test_string^}" | aspell list) ];
    then 
        warning_reason="Was that guess a word?"
        false
        return
    fi
    return
}

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

while (( guessed < max_guesses ))
do
    redraw
    read 
    new_guess=${REPLY}
    new_guess=$(echo $new_guess | tr '[:upper:]' '[:lower:]')
    if ! is_valid $new_guess;
    then
        warning="$new_guess isn't valid. $warning_reason"
        continue
    fi

    guessed=$((guessed+1))
    coloured_guess=$(colour_guess $new_guess)
    game+=${coloured_guess}
    game+=$'\n'

    if [ $new_guess = $secret_word ]; 
    then
        break
    fi
done

redraw
if [ $new_guess = $secret_word ];
then
    echo "Congrats, nerd."
    code=0
else
    echo "Aaaaand.... you lost."
    definitions=$(bash ./define.sh $secret_word)
    echo "It was $secret_word"
    if [ "$definitions" ];
    then
        echo 
        echo "$definitions"
        echo
    else
        echo
        echo "dw, we don't know what that means either"
        echo
    fi
    code=1
fi

# game_end=$(date +%s%N)
# printf "Time elapsed: %.7f seconds" "$(($game_end-$game_start))e-9"

read
return $code