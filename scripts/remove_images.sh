#!/bin/bash

# Tell the user how to use this script
INSTRUCTIONS='Choose a line number or a range, i.e. "start end", from the docker images listed:'

# Add line numbers to docker images output
DOCKER_LINES=`docker images | awk '{print NR-1 "\t" $0}'`

# Compare line numbers chosen to indices of the array
IMAGES=`docker images | tail -n +2 | awk '{print $3}'`

echo "$INSTRUCTIONS"
echo "$DOCKER_LINES"

# Text to remind the image lines to be removed
REMOVING="OK, removing line(s):"
LINES_CHOSEN=""

echo ""
read -p "Enter line or range: " LINES_CHOSEN

echo
read -p "Proceeding to remove image $LINES_CHOSEN, PRESS ENTER TO CONTINUE"

echo
echo "$REMOVING $LINES_CHOSEN"

# Experiment with this later
#START=`echo $LINES_CHOSEN | awk '{print $1}'`
#END=`echo $LINES_CHOSEN | awk '{print $2}'`
#LINE=""
#for (( i=$START; i<=$END; i++ )); do
#  echo $i
#done


i=1
for IMAGE_ID in $IMAGES; do
  if [ $i -eq $LINES_CHOSEN ]; then
    # Last word of the output is either the Docker image ID or its related container ID
    OUTPUT=`(docker image rm $IMAGE_ID 2>&1 > /dev/null)` 
    OUTPUT=`echo $OUTPUT | awk '{print $NF}'`
    echo "value of OUTPUT is $OUTPUT"
    if [ "$OUTPUT" == "$IMAGE_ID" ]; then
      echo "OK! Removed $IMAGE_ID!"    
    else
      # Remove output first
      docker stop "$OUTPUT"
      docker rm "$OUTPUT"
      docker image rm $IMAGE_ID
      echo "OK! Removed $IMAGE_ID!"
    fi
  fi
  ((i++))
done
