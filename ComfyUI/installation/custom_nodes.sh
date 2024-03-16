#!/bin/bash

custom_nodes_list=$1
comfyui_dir="~/ComfyUI"

if [ ! -e $custom_nodes_list ]; then
  echo "not found this list config: $custom_nodes_list"
  exit 1
fi

# Parse the YAML and get the string array
custom_nodes_url=$(cat $custom_nodes_list)

cd $comfyui_dir/custom_nodes
# Loop through the array and print each value
for url in $custom_nodes_url; do
  echo "installing $url"

  git clone --depth 1 $url
done

for folder in */; do
  if [ -e "$folder/requirements.txt" ]; then
    pip install -r "$folder/requirements.txt"
  fi
done
