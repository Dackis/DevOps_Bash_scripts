#!/bin/bash


cat text.txt | while read -r row; do
echo "$row"
extraction="${row#*.}"
echo "extraction: $extraction"
done


echo "TEXT: "
cat text.txt 