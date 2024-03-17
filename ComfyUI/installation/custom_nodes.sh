#!/bin/bash

custom_nodes_list=$1
comfyui_dir="$HOME/ComfyUI"

if [ ! -f $custom_nodes_list ]; then
  echo "not found this list config: $custom_nodes_list"
  exit 1
fi


cd $comfyui_dir/custom_nodes

# Read the text file line by line
while IFS= read -r url; do
    # Clone the repository
    git clone --depth 1 "$url"

    # Check if the clone was successful
    if [ $? -eq 0 ]; then
        echo "Repository cloned successfully: $url"
    else
        echo "Failed to clone repository: $url"
    fi
done < "$custom_nodes_list"

for folder in */; do
  if [ -e "$folder/requirements.txt" ]; then
    pip install -r "$folder/requirements.txt"
  fi
done
