A simple command-line application converting .json language files to .arb Flutter files and backward.

The reason of creating this tool is the difference in keys .json and .arb files.

While .json files can have in keys symbols like '-', '.', '/', '&', the .arb files can't.

In .arb file we have to use string that follows dart variables requirements
https://www.tutorialspoint.com/dart_programming/dart_programming_variables.htm

So, when we have ready .json file from other projects we should convert them.
And sometimes we need to convert files on other direction.

Script accepts 3 arguments:
- `--jsonToArb`
- `--arbToJson`
- `--dir "path_to_the_folder_with_files"`

and convert all files in the given directory.

`--jsonToArb` or `--arbToJson`, not together.

Command to run the script

```dart bin/dart_json_arb_json_converter.dart --arbToJson --dir "path_to_the_folder_with_files"```

## Credits

InstaImageViewer is a project by [Agoradesk](https://agoradesk.com/), P2P cryptocurrency trading platform.
Created by the team behind LocalMonero, the biggest and most trusted Monero P2P trading platform.
