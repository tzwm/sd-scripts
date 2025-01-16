for folder in */; do
  if [ -e "$folder/requirements.txt" ]; then
    pip install -r "$folder/requirements.txt"
  fi
done
