import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee_model.dart';

class EmployeeRepository {
  final String apiUrl = 'https://api.example.com/employees';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
}
