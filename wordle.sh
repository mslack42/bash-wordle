echo "Here's the game"
echo "You start off with 6 guesses and playing 5-letter Wordle"
echo "Each time you win a game of Wordle, whatever guesses you have left carry over, but the Wordle words get longer"
echo "How far can you go?"
read

remaining_guesses=6
current_word_length=5

while (( current_word_length < 16 )) 
do
    . game.sh $remaining_guesses $current_word_length
    if [ $code != 0 ];
    then 
        echo "That sucks"
        read
        exit
    fi
    ((current_word_length=current_word_length+1))
    ((remaining_guesses=remaining_guesses-guessed+current_word_length+1))
    echo $current_word_length
done

echo "GG."
read
