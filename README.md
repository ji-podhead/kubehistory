kubehistory is a little bashscript that helps you to find kubectl commands using the command history.
you can select the kubectl command by its index and edit it before executing.
#
TODO:
-scroll trough commands in edit mode using arrows, or mousewheel using dialog
-send command output to a different tty/stdin using exsel or screen
#

diaglog approach:
#!/bin/bash
# ...
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
# ...


