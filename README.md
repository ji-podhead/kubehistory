
#
kubehistory is a little bashscript that helps you to find kubectl commands using the command history.
<br>
you can select the kubectl command by its index and edit it before executing.
#
![preview](https://github.com/ji-soft/kubehistory/blob/main/preview.png?raw=true)
<br>
<br>
`roadmap
`
<br>
- remove double entries not working

- scroll trough commands in edit mode using arrows, or mousewheel using dialog.


- send command output to a different tty/stdin using exsel or screen.


- fire functions that are not in the history using something like inspect in python. in python you can fire functions genericly and get the method descriptions etc. (but not sure how to do this in bash script.


- use some sort of multiplexer with the dialog method to make use of the mouse to click on nodes/pods/namespace etc to select and then choose one of the given functions and add  possible flags. then paste intoo console and let user edit it  


`diaglog approach:`
<br>

```

while true; do
  clear
  check_and_update_history
  echo "commands:"
  index=1
  commands=()
  while IFS= read -r line; do
    commands+=("$index: $line")
    index=$((index +   1))
  done < "$SHORTCUT_FILE"
  command_index=$(dialog --clear --menu "Choose a command:"   0   0   0 "${commands[@]}"   3>&1   1>&2   2>&3   3>&-)
  if [ -n "$command_index" ]; then
    selected_command=$(sed -n "${command_index}p" "$SHORTCUT_FILE")
    read -e -p "Edit and hit enter: " -i "$selected_command" edited_string
    eval "$edited_string"
  else
    read -e -p "New command: " edited_string
    eval "$edited_string"
  fi
  read -e -p "Hit enter to continue"
done
 ```
 

