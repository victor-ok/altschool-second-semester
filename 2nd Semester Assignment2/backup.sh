#!/bin/bash
# backup a directory with timestamp

echo "altschool assignment submission for Victor Okafor mail: vua.okafor@gmail.com"

src_dir=$1
dest_dir=$2

if [ "$#" -ne 2]; 
then
    echo "two inputs required: <source_dir> <dest_dir>"
    exit 1
fi

if [ ! -d "$src_dir" ];
then 
    echo "dir does not exist: $1"
    exit 1
fi

timestamp=$(date +"%Y%m%d%H%M%S")
backup_file="$dest_dir/backup_$timestamp.tar.gz"

if [ ! -d "$dest_dir" ];
then
    mkdir -p "$dest_dir"
fi

tar -czf "$backup_file" -C "$src_dir" .

if [ $? -eq 0 ]; then
    echo "backup saved as: $backup_file"
else
    echo "Backup failed."
    exit 1
fi
