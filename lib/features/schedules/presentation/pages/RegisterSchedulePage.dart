import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterSchedulePage extends StatefulWidget {
  const RegisterSchedulePage({Key? key}) : super(key: key);

  @override
  _RegisterSchedulePageState createState() => _RegisterSchedulePageState();
}

class _RegisterSchedulePageState extends State<RegisterSchedulePage> {
  final List<Map<String, dynamic>> schedules = [];

  final Color buttonColor = Colors.red;
  final Color textColor = Colors.white;

  final TextEditingController userController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController employeeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String schedulesString = jsonEncode(schedules);
    await prefs.setString('schedules', schedulesString);
  }

  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schedulesString = prefs.getString('schedules');
    if (schedulesString != null) {
      List<dynamic> decodedData = jsonDecode(schedulesString);
      setState(() {
        schedules.clear();
        schedules.addAll(List<Map<String, dynamic>>.from(decodedData));
      });
    }
  }

  void _addSchedule() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      schedules.add({
        'ID': schedules.length + 1,
        'Usuario': userController.text,
        'Tipo': typeController.text,
        'Fecha_Inicio': startDateController.text,
        'Fecha_Fin': endDateController.text,
        'Fecha_Registro': formattedDate,
        'Estatus': true,
        'Empleado': employeeController.text,
        'Sucursal': branchController.text,
        'Servicio': serviceController.text,
      });
    });

    _saveSchedules();

    userController.clear();
    typeController.clear();
    startDateController.clear();
    endDateController.clear();
    employeeController.clear();
    branchController.clear();
    serviceController.clear();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario registrado')),
    );
  }

  void _showScheduleForm({Map<String, dynamic>? schedule}) {
    if (schedule != null) {
      userController.text = schedule['Usuario'];
      typeController.text = schedule['Tipo'];
      startDateController.text = schedule['Fecha_Inicio'];
      endDateController.text = schedule['Fecha_Fin'];
      employeeController.text = schedule['Empleado'];
      branchController.text = schedule['Sucursal'];
      serviceController.text = schedule['Servicio'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(schedule == null ? 'Registrar Horario' : 'Editar Horario'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: userController, decoration: const InputDecoration(labelText: 'Usuario')),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Tipo')),
              TextField(controller: startDateController, decoration: const InputDecoration(labelText: 'Fecha Inicio')),
              TextField(controller: endDateController, decoration: const InputDecoration(labelText: 'Fecha Fin')),
              TextField(controller: employeeController, decoration: const InputDecoration(labelText: 'Empleado')),
              TextField(controller: branchController, decoration: const InputDecoration(labelText: 'Sucursal')),
              TextField(controller: serviceController, decoration: const InputDecoration(labelText: 'Servicio')),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (schedule == null) {
                _addSchedule();
              } else {
                _updateSchedule(schedule['ID']);
              }
              Navigator.of(context).pop();
            },
            child: Text(schedule == null ? 'Guardar' : 'Actualizar'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        ],
      ),
    );
  }

  void _updateSchedule(int id) {
    setState(() {
      int index = schedules.indexWhere((schedule) => schedule['ID'] == id);
      if (index != -1) {
        schedules[index] = {
          'ID': id,
          'Usuario': userController.text,
          'Tipo': typeController.text,
          'Fecha_Inicio': startDateController.text,
          'Fecha_Fin': endDateController.text,
          'Fecha_Registro': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'Estatus': true,
          'Empleado': employeeController.text,
          'Sucursal': branchController.text,
          'Servicio': serviceController.text,
        };
      }
    });

    _saveSchedules();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario actualizado')),
    );
  }

  void _deleteSchedule(int id) {
    setState(() {
      schedules.removeWhere((schedule) => schedule['ID'] == id);
    });

    _saveSchedules();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horario eliminado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Horario')),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => _showScheduleForm(),
            child: const Text('Registrar Horario'),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Tipo')),
              DataColumn(label: Text('Fecha Inicio')),
              DataColumn(label: Text('Fecha Fin')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: schedules.map((schedule) {
              return DataRow(cells: [
                DataCell(Text(schedule['ID'].toString())),
                DataCell(Text(schedule['Usuario'])),
                DataCell(Text(schedule['Tipo'])),
                DataCell(Text(schedule['Fecha_Inicio'])),
                DataCell(Text(schedule['Fecha_Fin'])),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showScheduleForm(schedule: schedule),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteSchedule(schedule['ID']),
                      ),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
