import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_json_arb_json_converter/converter/convert.dart';

Future<void> main(List<String> arguments) async {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag(kJsonToArb)
    ..addFlag(kArbToJson)
    ..addFlag(kDir);

  ArgResults argResults = parser.parse(arguments);
  convert(argResults);
}
