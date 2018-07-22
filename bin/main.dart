import 'dart:io';

import 'package:args/args.dart';
import 'package:csv_parser/csv_parser.dart';

const String PROGRAM_NAME = "dart dup-remove.dart";

main(List<String> arguments) {
  if (arguments.length == 0) {}

  ArgParser parser = new ArgParser()
    ..addOption("file", abbr: "f", help: "Path to CSV file")
    ..addFlag("help", abbr: "h", negatable: false);

  ArgResults args = parser.parse(arguments);
  bool help = args["help"];
  String pathToCSV = args["file"];

  if (help) {
    printOut("Usage ${PROGRAM_NAME} [OPTIONS]");
    stdout.writeln(parser.usage);
    exit(1);
  }

  if (pathToCSV == null || pathToCSV.isEmpty) {
    printError("No CSV file specified");
    printOut(parser.usage);
    exit(1);
  }

  File file = new File(pathToCSV);
  CSVFile originalFile = CSVFile.fromString(file.readAsStringSync());
  CSVFile noDuplicatesFile = CSVFile(originalFile.header);

  Set<String> addressSet = new Set();

  for (CSVRow row in originalFile.rows) {
    String address = row["address"];
    if (!addressSet.contains(address)) {
      noDuplicatesFile.add(row);
      addressSet.add(address);
    }
  }

  print(noDuplicatesFile.export());
}

printError(String error) {
  stderr.writeln("${PROGRAM_NAME}: $error");
}

printOut(String out) {
  stdout.writeln("${PROGRAM_NAME}: $out");
}
