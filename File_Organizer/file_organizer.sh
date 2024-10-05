#!/bin/bash

downloads=./downloads

#----------------Check if folders exist-------------

echo "Checking if folder text_files exists "
    if [ -d $downloads/text_files ] ; then
        echo "exist text_files folder exist"
    else
        mkdir $downloads/text_files
        echo "text_files folder in $downloads created"
    fi
    

echo "Checking if folder images exists "
    if [ -d $downloads/images ] ; then
        echo "exist images folder exist"
    else
        mkdir $downloads/images
        echo "images folder in $downloads created"
    fi
    

echo "Checking if folder scripts exists "
    if [ -d $downloads/scripts ] ; then
        echo "exist scripts folder exist"
    else
        mkdir $downloads/scripts
        echo "scripts folder in $downloads created"
    fi
    

echo "Checking if folder other exists "
    if [ -d $downloads/other ] ; then
        echo "exist other folder exist"
    else
        mkdir $downloads/other
        echo "other folder in $downloads created"
    fi

#-------Check downloads folder for files------------

find "$downloads" -type f | while read -r item; do
    echo "Processing $item"
    
    # Extract file extension
    ext="${item##*.}"

    case "$ext" in
        txt)
            echo "Moving $item to text_files"
            mv "$item" "$downloads/text_files/"
            ;;
        jpg|png)
            echo "Moving $item to images"
            mv "$item" "$downloads/images/"
            ;;
        sh)
            echo "Moving $item to scripts"
            mv "$item" "$downloads/scripts/"
            ;;
        *)
            echo "Moving $item to other"
            mv "$item" "$downloads/other/"
            ;;
    esac
done




    

