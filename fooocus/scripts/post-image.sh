#! /bin/bash

model_dir="/root/autodl-tmp/checkpoints"
target_dir="/root/Fooocus/models/checkpoints"

rm $target_dir
mkdir $target_dir

cp $model_dir/sd_xl_base_1.0_0.9vae.safetensors $target_dir/
cp $model_dir/sd_xl_refiner_1.0_0.9vae.safetensors $target_dir/
