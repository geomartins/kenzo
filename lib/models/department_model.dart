class DepartmentModel {
  final String name;
  final String description;

  DepartmentModel.fromFirestore(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        description = parsedJson['description'];
}
