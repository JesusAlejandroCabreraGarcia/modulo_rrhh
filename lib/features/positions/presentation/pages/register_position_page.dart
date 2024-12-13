import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterPositionPage extends StatefulWidget {
  const RegisterPositionPage({Key? key}) : super(key: key);

  @override
  _RegisterPositionPageState createState() => _RegisterPositionPageState();
}

class _RegisterPositionPageState extends State<RegisterPositionPage> {
  final List<Map<String, dynamic>> positions = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70);
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170);
  final Color buttonColor = Colors.red;
  final Color textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadPositions();
  }

  Future<void> _loadPositions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPositions = prefs.getString('positions');
    if (savedPositions != null) {
      List<dynamic> decodedPositions = jsonDecode(savedPositions);
      setState(() {
        positions.clear();
        positions.addAll(List<Map<String, dynamic>>.from(decodedPositions));
      });
    }
  }

  Future<void> _savePositions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedPositions = jsonEncode(positions);
    await prefs.setString('positions', encodedPositions);
  }

  void _addPosition() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      positions.add({
        'ID': positions.length + 1,
        'Nombre': nameController.text,
        'Descripcion': descriptionController.text,
        'Salario': double.tryParse(salaryController.text) ?? 0.0,
        'Requisitos': requirementsController.text,
        'Estatus': true,
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
      });
    });

    _savePositions();

    nameController.clear();
    descriptionController.clear();
    salaryController.clear();
    requirementsController.clear();

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posición registrada')),
    );
  }

  void _showPositionForm({Map<String, dynamic>? position}) {
    if (position != null) {
      nameController.text = position['Nombre'];
      descriptionController.text = position['Descripcion'];
      salaryController.text = position['Salario'].toString();
      requirementsController.text = position['Requisitos'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(position == null ? 'Registrar Posición' : 'Editar Posición'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Salario'),
              ),
              TextField(
                controller: requirementsController,
                decoration: const InputDecoration(labelText: 'Requisitos'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (position == null) {
                _addPosition();
              } else {
                _updatePosition(position['ID']);
              }
              Navigator.of(context).pop();
            },
            child: Text(position == null ? 'Guardar' : 'Actualizar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _updatePosition(int id) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      int index = positions.indexWhere((pos) => pos['ID'] == id);
      if (index != -1) {
        positions[index] = {
          'ID': id,
          'Nombre': nameController.text,
          'Descripcion': descriptionController.text,
          'Salario': double.tryParse(salaryController.text) ?? 0.0,
          'Requisitos': requirementsController.text,
          'Estatus': true,
          'Fecha_Registro': positions[index]['Fecha_Registro'],
          'Fecha_Actualizacion': formattedDate,
        };
      }
    });
    _savePositions();
  }

  void _deletePosition(int id) {
    setState(() {
      positions.removeWhere((position) => position['ID'] == id);
    });
    _savePositions();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posición eliminada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posiciones'),
        backgroundColor: Colors.black,
        foregroundColor: textColor,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _showPositionForm(),
            child: const Text('Registrar Posición'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: positions.length,
              itemBuilder: (context, index) {
                var position = positions[index];
                return ListTile(
                  title: Text(position['Nombre']),
                  subtitle: Text('Salario: ${position['Salario']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showPositionForm(position: position),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePosition(position['ID']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
