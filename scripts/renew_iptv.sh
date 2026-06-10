#!/bin/bash

echo "::notice::Download $original_file"
curl -v -m 30 --connect-timeout 10 -A "$ua" "$original_file_url" > $original_file

if [ -e $original_file ]
then
   if [ "$(stat -c%s $original_file)" -gt "$smallest_file_size" ] && grep -q $test_channel $original_file
   then
      echo "::notice::Move MCP channels of cctv, 卫视, and channels of 测试 to $temp_file"
      sed -n '1p' $original_file > $temp_file
      sed -n '/cctv\([0-9]\+\)\([p]\?\)-MCP$/,/https:/p' $original_file >> $temp_file
      sed -n '/卫视-MCP$/,/https:/p' $original_file >> $temp_file
      sed -n '/五星体育/,/https:/p' $original_file >> $temp_file
      sed -n '/测试$/,/https:/p' $original_file >> $temp_file
      echo "::notice::Add tvg-id to $temp_file for enabling EPG"
      sed -i -E 's/tvg\-name=\"cctv[0-9]+[a-z]*\"/& &/' $temp_file
      LANG=C sed -i -E 's/tvg\-name=\"[\x81-\xFE]+\"/& &/' $temp_file
      sed -i -E 's/tvg\-name=\"4K60PSDR-H264-AAC测试\"/& &/' $temp_file
      sed -i -E 's/tvg\-name=\"4K60PHLG-HEVC-EAC3测试\"/& &/' $temp_file
      sed -i 's/\-1 tvg-name/\-1 tvg-id/' $temp_file
      echo "::notice::Encrypt $temp_file as $target_file"
      openssl enc -in $temp_file -out $target_file -e -$algorithm -iv $ivHex -pbkdf2 -pass pass:$password -S $saltHex -iter $iterations -md $diggest
      echo "::notice::Rmove $temp_file"
      rm $temp_file
   else
      echo "::warning::Either $original_file is smaller than $smallest_file_size or $test_channel was not found in $original_file, skip handling"
      cat $original_file
      exit 1
   fi
   echo "::notice::Rmove $original_file"
   rm $original_file
else
   echo "::error::Download failed"
   exit 1
fi
