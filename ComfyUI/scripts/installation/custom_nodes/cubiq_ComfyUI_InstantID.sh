working_dir=$comfyui_dir/models/insightface/models
mkdir -p $working_dir
if ! [ -d "$working_dir/antelopev2" ]; then
  cd $working_dir
  wget https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip
  unzip antelopev2.zip
  rm antelopev2
fi
