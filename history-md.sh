#!/bin/bash

SAVEFILE="$HOME/$(hostname)_history.md"

## CUSTOM ERROR MESSAGES
ERROR_NO_INPUT='Usage:
  history | history-md.sh                    <-- writes last bash input command
  history | history-md.sh 10                 <-- writes the numbered command
  history | history-md.sh "# Shell Comment"  <-- adds shell comment
  history | history-md.sh "## header"        <-- adds header
  history | history-md.sh "Paragraph text"   <-- adds text

Customise the SAVEFILE variable of the script to specify path to a text file'
ERROR_UNWRITABLE_SAVEFILE="Error: Cannot write to ${SAVEFILE}"
ERROR_UNABLE_CREATE="Error: Unable to create ${SAVEFILE}"
ERROR_COMMAND_NOT_FOUND="Error: Command with number %d not found in history.\n"
ERROR_TOO_MANY_ARGS="Error: Too many arguments."

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"

## FUNC DECLARATION
save_record() {
    local record="$1"
    local printf_pattern="$2"
    local color="$3"

    if printf "$printf_pattern" "$record" >>"${SAVEFILE}"; then
        # echo -e "\033[1;35mNew record:\033[0m ${color}${record}\033[0m"
        printf "\033[1;35mNew record:\033[0m ${color}%s\033[0m\n" "${record}"
        exit 0
    else
        echo "${ERROR_UNWRITABLE_SAVEFILE}"
        exit 1
    fi
}

process_pipe() {
    if [ -n "$1" ]; then
        if [[ "$1" =~ ^#{2,5}\ .+$ ]]; then
            # add "## level 2 header"
            save_record "$1" "\n%s\n\n" "$YELLOW"
        elif [[ "$1" =~ ^#.+$ ]]; then
            # add "# bash comment"
            save_record "$1" "    %s\n" "$CYAN"
        elif [[ "$1" =~ ^[0-9]+$ ]]; then
            # add 1234
            while IFS= read -r line; do
                if [[ "$line" =~ ^\ +"$1".*$ ]]; then
                    ## Remove initial spaces
                    output_line=$(echo "$line" | awk -v num="$1" '$1 == num { $1 = ""; sub(/^[ \t]+/, ""); print }')
                    break
                fi
            done
            if [ -z "$output_line" ]; then
                # shellcheck disable=SC2059
                printf "${ERROR_COMMAND_NOT_FOUND}" "$1"
                exit 127
            fi
            save_record "$output_line" "    %s\n"
        elif [[ "$1" =~ ^format$ ]]; then
            if sed -i -z 's/\n\{3,\}/\n\n/g' "${SAVEFILE}"; then
                echo "${SAVEFILE} has been formated"
                exit 0
            else
                echo "${ERROR_UNWRITABLE_SAVEFILE}"
                exit 1
            fi
        else
            # add "text"
            save_record "$1" "\n%s\n\n" "$GREEN"
        fi
    else
        prev_line=""
        while IFS= read -r line; do
            if [[ -n $line ]]; then
                prev_line="$last_line"
                last_line="$line"
            fi
        done
        output_line=$(echo "$prev_line" | awk '{$1=""; sub(/^[ \t]+/, ""); print}')
        save_record "$output_line" "    %s\n"
    fi
}

## STARTS THE MAIN PROGRAM
if [ ! -f "${SAVEFILE}" ]; then
    touch "${SAVEFILE}" || {
        echo "${ERROR_UNABLE_CREATE}"
        exit 1
    }
    printf "# %s\n\n" "$(hostname)" >>"${SAVEFILE}"
    echo "File ${SAVEFILE} has been created."
fi

if [ ! -w "${SAVEFILE}" ]; then
    echo "${ERROR_UNWRITABLE_SAVEFILE}"
    exit 1
fi

## PIPELINE PROCESSING
if [ -t 0 ]; then
    ## Check if there is input data via pipeline
    echo "${ERROR_NO_INPUT}"
    exit 1
fi

if [ $# -le 1 ]; then
    ## If a command number is passed as an argument, extracts command under this number
    process_pipe "$*"  # needs to be improved for several numbered commands
    # exit 0
else
    echo "${ERROR_TOO_MANY_ARGS}"
    exit 1
fi
