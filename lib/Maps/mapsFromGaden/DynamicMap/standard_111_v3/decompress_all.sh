#!/bin/bash 

for file in Filament*
do
     ./decompress $file out_$file
     sed -i '1,7d' out_$file
done
