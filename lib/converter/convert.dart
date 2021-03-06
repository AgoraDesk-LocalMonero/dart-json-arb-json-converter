import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const kJsonToArb = 'jsonToArb';
const kArbToJson = 'arbToJson';
const kDir = 'dir';

void convert(ArgResults argResults) async {
  List<String> paths = argResults.rest;
  stderr.writeln('working directory - ${argResults.rest}');
  if (paths.isEmpty || (argResults.arguments.isEmpty) || (argResults.arguments.length != 3)) {
    _printErrors(ErrorType.noParameters);
  } else {
    final List<FileSystemEntity> files = await _dirContents(Directory(paths[0]));
    if (files.isEmpty) {
      _printErrors(ErrorType.noFiles);
    } else {
      for (final FileSystemEntity file in files) {
        try {
          if (file.path.contains('.json') || file.path.contains('.arb')) {
            Map<String, dynamic> resMap = await _readFile(file.path);
            String newKey = '';
            Map<String, dynamic> arbMap = {};
            if (argResults.arguments.join(' ').contains(kJsonToArb)) {
              /// json => arb
              if (file.path.contains('.json')) {
                stderr.writeln('started file - ${file.path}');
                for (var k in resMap.keys) {
                  newKey = k;
                  for (final l in _replacementList) {
                    newKey = newKey.replaceAll(l[0], l[1]);
                  }
                  final firstLetterInt = int.tryParse(k[0]);
                  if (firstLetterInt != null) {
                    newKey = newKey.replaceFirst(k[0], 'numSb${k[0]}');
                  }
                  // arbMap[newKey] = resMap[k];
                  /// AgoraDesk uses name FRONT_TYPE in json - here we handle it
                  arbMap[newKey] = resMap[k].replaceAll('FRONT_TYPE', '{appName}');
                }
                await _writeToFile(arbMap, file.path.replaceAll('.json', '.arb'));
              }
            } else {
              /// arb => json
              if (file.path.contains('.arb')) {
                stderr.writeln('started file - ${file.path}');
                for (var k in resMap.keys) {
                  if (!k[0].contains('@')) {
                    newKey = k;
                    for (final l in _replacementList) {
                      newKey = newKey.replaceAll(l[1], l[0]);
                    }
                    newKey = newKey.replaceAll('numSb', '');
                    // arbMap[newKey] = resMap[k];
                    /// AgoraDesk uses name FRONT_TYPE in json - here we handle it
                    arbMap[newKey] = resMap[k].replaceAll('{appName}', 'FRONT_TYPE');
                  }
                }
                await _writeToFile(arbMap, file.path.replaceAll('.arb', '.json'));
              }
            }
          }
        } catch (e) {
          print('++++error -- $e');
        }
      }
    }
  }
}

Future<List<FileSystemEntity>> _dirContents(Directory dir) {
  var files = <FileSystemEntity>[];
  var completer = Completer<List<FileSystemEntity>>();
  var lister = dir.list(recursive: false);
  lister.listen((file) => files.add(file), onDone: () => completer.complete(files));
  return completer.future;
}

enum ErrorType { noParameters, noFiles }

const _replacementList = [
  ['.', '250Sb'],
  ['-', '8722Sb'],
  [':', '58Sb'],
  ['&', '38Sb'],
  ['/', '57Sb'],
];

Future<Map<String, dynamic>> _readFile(String filePath) async {
  final input = await File(filePath).readAsString();
  final map = jsonDecode(input);
  return map;
}

Future _writeToFile(Map<String, dynamic> res, String path) async {
  final f = File(path);
  await f.writeAsString(jsonEncode(res));
}

void _printErrors(ErrorType type) {
  switch (type) {
    case ErrorType.noParameters:
      stderr.writeln('''
    Error - no or wrong parameters. 
    Please input parameters:
      --jsonToArb or --arbToJson
      --path "path_to_the_directory_with_files"
    ''');
      break;

    case ErrorType.noFiles:
      stderr.writeln('''
    Error - no files in the given directory. 
    Please input parameters:
      --jsonToArb or --arbToJson
      --path "path_to_the_directory_with_files"
    ''');
      break;
  }
}
