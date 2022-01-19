#!/bin/bash
command_name=`basename "$0"`
. conf.ini

url="$BASE_URL/$WORKSPACE/arian/notif/admin-notifications"
file="$BASE_PATH/shared/sites/$WORKSPACE/log/"
config_path="$BASE_PATH/workflow/engine/config/env.ini"
maxsize=$(awk -v RS='\r\n' -F "=" '/max_log_file_size/ {print $2}' $config_path)

while inotifywait -r -e close_write "$file"; do
      actualsize=$(du -sh -k "$file" | cut -f1)
      diff=$(( ${actualsize} - ${maxsize}))
      echo "actualsize=$actualsize" 
      echo "maxsize=$maxsize" 
      echo "diff=$diff"         
      if [ ${diff} -ge 0 ]; then
        echo size is over $maxsize kilobytes
        curl --location --request POST "$url" --header ''
    else
        echo size is under $maxsize kilobytes
    fi
done
./$command_name "$WORKSPACE" "$file"
