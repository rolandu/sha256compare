# sha256compare

`sha256compare.sh` is a script designed to compare files in two directories based on their sha256 checksums. It can be used to ensure that files in different directories have identical contents, even if the directories themselves are located at different paths.

The script outputs the relative paths and filenames (with the base directory removed) along with their sha256 checksums. If there are differences in the checksums of files with the same relative path, those differences will be displayed.

## Usage

### Basic usage:

To compare all files in two directories:

```
./sha256compare.sh /path/to/directory1 /path/to/directory2
```

### Specific file types:

To limit the comparison to a specific file type (for example, `.tar` files):

```
./sha256compare.sh /path/to/directory1 /path/to/directory2 *.tar
```

## Debugging

Inside the script, there is a `DEBUG` variable. By default, this is set to `false`, meaning the script will automatically delete the temporary files it creates during its operation. 

If you set this variable to `true`, the script will not only keep these temporary files but will also display their contents at the end of the comparison. This can be useful for debugging purposes or for a more detailed analysis of the comparison results.



