#!/bin/bash
HISTORY_FILE="./kubectl_command_history.txt"
SHORTCUT_FILE="./shortcut_command_history.txt"
check_and_update_history() {
  update_command_history
  temp_file="./temp_command_history.txt"  > "$temp_file"
  index=1# Erstellen Sie eine temporäre Datei und speichern Sie die eindeutigen Zeilen aus der HISTORY_FILE
temp_file="./temp_command_history.txt"
> "$temp_file"
while IFS= read -r line; do
  # Entfernen Sie führende und abschließende Leerzeichen
  trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  # Überprüfen Sie, ob die Zeile bereits in der SHORTCUT_FILE vorhanden ist
  if ! grep -qF "$trimmed_line" "$SHORTCUT_FILE"; then
    # Wenn die Zeile nicht vorhanden ist, fügen Sie sie zur temp_file hinzu
    echo "$trimmed_line" >> "$temp_file"
  fi
done < "$HISTORY_FILE"

# Fügen Sie die eindeutigen Zeilen aus der temporären Datei zur SHORTCUT_FILE hinzu
while IFS= read -r line; do
  # Überprüfen Sie, ob die Zeile bereits in der SHORTCUT_FILE vorhanden ist
  if ! grep -qF "$line" "$SHORTCUT_FILE"; then
    # Wenn die Zeile nicht vorhanden ist, fügen Sie sie zur SHORTCUT_FILE hinzu
    echo "$line" >> "$SHORTCUT_FILE"
  fi
done < "$temp_file"

# Löschen Sie die temporäre Datei
rm "$temp_file"
}
update_command_history() {
  if [ -f "$HISTORY_FILE" ]; then
    rm "$HISTORY_FILE"
  fi
  grep "kubectl" ~/.bash_history  | sed 's/^[[:space:]]*//' > "$HISTORY_FILE" 
  if [ -f "$SHORTCUT_FILE" ]; then
  grep "kubectl" ~/.bash_history  | sed 's/^[[:space:]]*//' >"$SHORTCUT_FILE"
  fi
}

while true; do
  clear
  check_and_update_history
  echo "commands:"
  index=1
  while IFS= read -r line; do
    echo "$index: $line"
    index=$((index +   1))
  done < "$SHORTCUT_FILE"
  echo "choose by nr to edit:"
  read -r command_index
if [ -n "$command_index" ] && [ "$command_index" -ne   0 ]; then
  selected_command=$(sed -n "${command_index}p" "$SHORTCUT_FILE")
  read -e -p "edit and hit enter :" -i "$selected_command" edited_string
  eval "$edited_string"
else
  if [ "$command_index" -eq   0 ]; then
read -e -p "new command: " edited_string
eval "$edited_string"
  fi
fi
read -e -p "hit enter to continue" 
done
