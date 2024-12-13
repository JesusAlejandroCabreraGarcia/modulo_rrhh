import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({Key? key}) : super(key: key);

  @override
  _RegisterEmployeePageState createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  final List<Map<String, dynamic>> employees = [];

  final TextEditingController areaController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController personaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70);
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170);
  final Color buttonColor = Colors.red;
  final Color textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _saveEmployees() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(employees);
    await prefs.setString('employees', encodedData);
  }

  void _loadEmployees() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('employees');
    if (data != null) {
      List<dynamic> decodedData = jsonDecode(data);
      setState(() {
        employees.clear();
        employees.addAll(List<Map<String, dynamic>>.from(decodedData));
      });
    }
  }

  void _addEmployee() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      employees.add({
        'ID': employees.length + 1,
        'Area_ID': areaController.text,
        'Fecha_Contratacion': formattedDate,
        'Puesto_ID': puestoController.text,
        'Persona_ID': personaController.text,
        'Numero_Empleado': numeroController.text,
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
        'Estatus': true,
      });
    });

    _saveEmployees();

    areaController.clear();
    puestoController.clear();
    personaController.clear();
    numeroController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Empleado registrado')),
    );

    Navigator.of(context).pop();
  }

  void _deleteEmployee(int id) {
    setState(() {
      employees.removeWhere((employee) => employee['ID'] == id);
    });
    _saveEmployees();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Empleado eliminado')),
    );
  }

  void _editEmployee(Map<String, dynamic> employee) {
    areaController.text = employee['Area_ID'];
    puestoController.text = employee['Puesto_ID'];
    personaController.text = employee['Persona_ID'];
    numeroController.text = employee['Numero_Empleado'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Empleado'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área del Empleado'),
              ),
              TextField(
                controller: puestoController,
                decoration: const InputDecoration(labelText: 'Puesto'),
              ),
              TextField(
                controller: personaController,
                decoration: const InputDecoration(labelText: 'Persona'),
              ),
              TextField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Número de Empleado'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                employee['Area_ID'] = areaController.text;
                employee['Puesto_ID'] = puestoController.text;
                employee['Persona_ID'] = personaController.text;
                employee['Numero_Empleado'] = numeroController.text;
                employee['Fecha_Actualizacion'] =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              });
              _saveEmployees();
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showEmployeeForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Empleado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área del Empleado'),
              ),
              TextField(
                controller: puestoController,
                decoration: const InputDecoration(labelText: 'Puesto'),
              ),
              TextField(
                controller: personaController,
                decoration: const InputDecoration(labelText: 'Persona'),
              ),
              TextField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: 'Número de Empleado'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _addEmployee,
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Empleado'),
        backgroundColor: Colors.black,
        foregroundColor: textColor,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showEmployeeForm,
            child: const Text('Registrar Empleado'),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Área')),
                    DataColumn(label: Text('Puesto')),
                    DataColumn(label: Text('Persona')),
                    DataColumn(label: Text('Número')),
                    DataColumn(label: Text('Editar')),
                    DataColumn(label: Text('Eliminar')),
                  ],
                  rows: employees.map((employee) {
                    return DataRow(
                      cells: [
                        DataCell(Text(employee['ID'].toString())),
                        DataCell(Text(employee['Area_ID'])),
                        DataCell(Text(employee['Puesto_ID'])),
                        DataCell(Text(employee['Persona_ID'])),
                        DataCell(Text(employee['Numero_Empleado'])),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editEmployee(employee),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteEmployee(employee['ID']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
