#!/bin/bash


################################################################################
# Description:
#   This script compares the sha256 checksums of files (optionally, of a 
#   specific type) in two specified directories. It outputs the relative 
#   paths and filenames (with the base directory removed) along with their 
#   sha256 checksums.
#
#   If there are differences in the checksums of files with the same relative 
#   path, it displays those differences.
#
#   The aim is to identify if files in the two directories are identical 
#   in content even if the directories have different absolute paths.
#
# Usage:
#   ./sha256compare.sh /path/to/directory1 /path/to/directory2 [pattern]
#   Example: ./sha256compare.sh /dir1 /dir2 *.tar
#
# Author: ChatGPT @ OpenAI, Roland Ulbricht
# Date: 2023-09-30
################################################################################


# Debug variable. Set to true to retain and display tmp files, set to false to remove them.
DEBUG=false

# Ensure at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 /path/to/directory1 /path/to/directory2 [pattern]"
    exit 1
fi

# Directories provided as arguments
DIR1="$1"
DIR2="$2"

# Filename pattern, default to all files if not provided
PATTERN="${3:-*}"

# Ensure the directories end with a '/'
[[ "$DIR1" != */ ]] && DIR1="$DIR1/"
[[ "$DIR2" != */ ]] && DIR2="$DIR2/"

# Temporary files for the results
TMP1=$(mktemp)
TMP2=$(mktemp)

# Cleanup temp files on exit
trap "rm -f $TMP1 $TMP2" EXIT

# Generate sha256sum results with only relative filenames
find "$DIR1" -type f -name "$PATTERN" -print0 | while IFS= read -r -d '' file; do
    sum=$(sha256sum "$file" | cut -d' ' -f1)
    relpath="${file#$DIR1}"
    printf "%s %s\n" "$sum" "$relpath" >> "$TMP1"
done

find "$DIR2" -type f -name "$PATTERN" -print0 | while IFS= read -r -d '' file; do
    sum=$(sha256sum "$file" | cut -d' ' -f1)
    relpath="${file#$DIR2}"
    printf "%s %s\n" "$sum" "$relpath" >> "$TMP2"
done

sort "$TMP1" -o "$TMP1"
sort "$TMP2" -o "$TMP2"

# Compare the results
if diff "$TMP1" "$TMP2" > /dev/null; then
    echo "The directories have files with matching sha256sums."
else
    echo "The sha256sums of files in the directories differ. Displaying differences:"
    diff "$TMP1" "$TMP2"
fi

# If debugging is on, display the contents of the tmp files
if $DEBUG; then
	echo
	echo $DIR1:
	cat $TMP1
	echo
	echo $DIR2:
	cat $TMP2
fi

