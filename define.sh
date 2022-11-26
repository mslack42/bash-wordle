word=$1
url="https://api.dictionaryapi.dev/api/v2/entries/en/$word"
definitionJson=$(curl -s $url)
noDefinitionFound="No Definitions Found"
error=$(echo "$definitionJson" | jq '.title?')
if [ "$error" ];
then
    exit 1
fi

definitions=$(echo $definitionJson | jq -r '"\(.[0].meanings[].definitions[].definition)"')

printf "$definitions"