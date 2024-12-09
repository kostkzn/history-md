# Bash History Saver

A simple script to save selected commands from Bash history to a **markdown** file. Designed and tested for **Ubuntu**.

## Features

- Saves the last executed command
- Saves a certain command by its number in `history` output
- Adds custom markdown text or shell comments
- Commands are saved to a customizable text file

## Usage

```bash
history | history-md.sh                    # writes last bash input command
history | history-md.sh 10                 # writes the numbered command
history | history-md.sh "# Shell Comment"  # adds shell comment
history | history-md.sh "## header"        # adds header
history | history-md.sh "Paragraph text"   # adds text
history | history-md.sh format             # deletes the redundant \n in markdown file
```

## Installation

```bash
git clone https://github.com/kostkzn/history-md.git
cd history-md
source ./alias_add.sh
```

`alias_add.sh` will:

- Create a `~/bin` directory if it doesn't exist
- Copy the script to your `~/bin` directory
- Add the `add` alias to your `.bashrc`
- Simplify usage to:

    ```bash
    add                 # Save the last executed command
    add 123             # Save command number 123 from history
    add "# My comment"  # Add a comment to the history saver file
    ```

The commands are saved by default to `~/hostname_history.md`.

## Requirements

- Basic Unix utilities (awk)
