import 'dart:io';

void main() {
  // Define the directory path of your Flutter project
  String projectDirectory = "D:\\a_biz\\abiz_pos_desktop\\lib";

  // Set of all Dart files in the project
  Set<File> dartFiles = Set();

  // Set of all Dart classes found in the project
  Set<String> dartClasses = Set();

  // Set of used Dart classes found in the project
  Set<String> usedClasses = Set();

  // Regular expression pattern to match Dart class definitions
  RegExp classPattern = RegExp(r'class\s+([^\s{]+)');

  // Regular expression pattern to match Dart imports
  RegExp importPattern = RegExp(r'import\s+([^\s;]+)');

  // Function to extract Dart classes from a Dart file
  Set<String> extractClasses(String content) {
    return classPattern
        .allMatches(content)
        .map((match) => match.group(1)!)
        .toSet();
  }

  // Function to extract Dart imports from a Dart file
  Set<String> extractImports(String content) {
    return importPattern
        .allMatches(content)
        .map((match) => match.group(1)!)
        .toSet();
  }

  // Function to process a Dart file and extract classes and imports
  void processDartFile(File file) {
    String content = file.readAsStringSync();
    Set<String> classes = extractClasses(content);
    Set<String> imports = extractImports(content);
    dartClasses.addAll(classes);
    // Exclude Dart classes from the 'dart:' library
    usedClasses.addAll(classes.intersection(imports));
  }

  // Function to recursively traverse the project directory and process Dart files
  void traverseDirectory(String directoryPath) {
    Directory directory = Directory(directoryPath);
    directory.listSync(recursive: true).forEach((FileSystemEntity entity) {
      if (entity is File && entity.path.endsWith('.dart')) {
        dartFiles.add(entity);
      }
    });
  }

  // Traverse the project directory and process Dart files
  traverseDirectory(projectDirectory);

  // Process each Dart file to extract classes and imports
  dartFiles.forEach(processDartFile);

  // Identify unused Dart classes
  Set<String> unusedClasses = dartClasses.difference(usedClasses);

  // Print the unused Dart classes
  print("Unused Dart Classes:");
  unusedClasses.forEach((unusedClass) => print(unusedClass));
}
