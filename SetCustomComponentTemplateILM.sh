!/bin/bash

username="username"
password="password"

getTemplateName=$(curl -u $username:$password "https://192.168.1.1:9200/_component_template/*@custom?filter_path=component_templates.name")

# Remove the front and back parts of the input text
trimmed_text=$(echo "$getTemplateName" | sed 's/{"component_templates":\[//; s/\]}//')

# Loop through each component template and add it to an array
declare -a array=()
while read -r line; do
    if [[ "$line" =~ "name" ]]; then
        array+=("$line")
    fi
done <<< "$(echo "$trimmed_text" | sed 's/{/{\n/g; s/}/}\n/g')"

# Add {"name":"value"} to each element of the array
names=$(echo "$getTemplateName" | sed 's/.*\[\(.*\)\].*/\1/' | grep -o '"name":"[^"]\+"' | sed 's/"name":"\(.*\)"/\1/' | sed 's/{\|,{//g')
for i in "${!array[@]}"; do
    name=$(echo "$names" | sed -n "${i}p" | cut -d'.' -f2- | tr -d '[:space:]')
    array[$i]=$(echo "${array[$i]}" | sed "s/\({.*\)\}/\1,\"name\":\"$name\"}/")
done

# Extract only the component template names from the "name" key
for i in "${!array[@]}"; do
    name=$(echo "${array[$i]}" | sed 's/.*"name":"\([^"]*\)".*/\1/' | sed 's/{\|,{//g' | tr -d '[:space:]')
    array[$i]="$name"
done

# Print each array value with a counter
#for i in "${!array[@]}"; do
#    echo "$((i+1)). ${array[$i]}"
#done

for i in "${array[@]}";
do
stringarray=($i)
template=${stringarray[0]}
#echo $template

text=$(curl -u $username:$password "https://192.168.1.1:9200/_component_template/$template")

removepackage=$(echo $text | sed -e 's/^.*"package":{"name":"//g')
package=$(echo $removepackage | sed -e 's/"},"managed_by".*//g' )
#echo $package
removemanageby=$(echo $text | sed -e 's/^.*"managed_by":"//g')
manageby=$(echo $removemanageby | sed -e 's/","managed".*//g')
#echo $manageby

command=$(curl -u $username:$password -XPUT "https://192.168.1.1:9200/_component_template/$template" -H "kbn-xsrf: reporting" -H "Content-Type: application/json" -d'
{
  "template": {
    "settings": {
      "index": {
        "lifecycle": {
          "name": "Policy_ILM"
        }
      }
    }
  },
  "_meta": {
    "package": {
      "name": "'$package'"
    },
    "managed_by": "'$manageby'",
    "managed": true
  }
}')

done
