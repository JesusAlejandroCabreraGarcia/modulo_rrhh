class Employee {
  final int id;
  final String name;
  final String position;

  Employee({required this.id, required this.name, required this.position});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
