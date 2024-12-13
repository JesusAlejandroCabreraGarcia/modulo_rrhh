import 'dart:convert'; // Para convertir la lista a JSON
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterAreaPage extends StatefulWidget {
  const RegisterAreaPage({Key? key}) : super(key: key);

  @override
  _RegisterAreaPageState createState() => _RegisterAreaPageState();
}

class _RegisterAreaPageState extends State<RegisterAreaPage> {
  final List<Map<String, dynamic>> areas = [];
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController sucursalController = TextEditingController();

  final Color primaryColor = const Color.fromARGB(255, 14, 40, 70); // Azul oscuro
  final Color secondaryColor = const Color.fromARGB(255, 170, 170, 170); // Gris oscuro
  final Color buttonColor = Colors.red; // Botón rojo
  final Color textColor = Colors.white; // Texto blanco

  @override
  void initState() {
    super.initState();
    _loadAreas(); // Cargar áreas al iniciar
  }

  Future<void> _loadAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? areasData = prefs.getString('areas');

    if (areasData != null) {
      final List<dynamic> decodedData = jsonDecode(areasData);
      setState(() {
        areas.clear();
        areas.addAll(decodedData.map((item) => Map<String, dynamic>.from(item)));
      });
    }
  }

  Future<void> _saveAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(areas);
    await prefs.setString('areas', encodedData);
  }

  void _addArea() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    setState(() {
      areas.add({
        'ID': areas.length + 1,
        'Nombre': nombreController.text,
        'Descripcion': descripcionController.text,
        'Sucursal': sucursalController.text,
        'Estatus': true,
        'Fecha_Registro': formattedDate,
        'Fecha_Actualizacion': formattedDate,
      });
    });

    _saveAreas();

    nombreController.clear();
    descripcionController.clear();
    sucursalController.clear();

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Área registrada')),
    );
  }

  void _editArea(int id) {
    final areaToEdit = areas.firstWhere((area) => area['ID'] == id);

    nombreController.text = areaToEdit['Nombre'];
    descripcionController.text = areaToEdit['Descripcion'];
    sucursalController.text = areaToEdit['Sucursal'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Área'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: sucursalController,
              decoration: const InputDecoration(labelText: 'Sucursal'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: textColor,
            ),
            onPressed: () {
              setState(() {
                areaToEdit['Nombre'] = nombreController.text;
                areaToEdit['Descripcion'] = descripcionController.text;
                areaToEdit['Sucursal'] = sucursalController.text;
                areaToEdit['Fecha_Actualizacion'] =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              });

              _saveAreas();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Área editada')),
              );
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _deleteArea(int id) {
    setState(() {
      areas.removeWhere((area) => area['ID'] == id);
    });
    _saveAreas();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Área eliminada')),
    );
  }

  void _showAreaForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrar Área'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: sucursalController,
                decoration: const InputDecoration(labelText: 'Sucursal'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _addArea,
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
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
        title: const Text('Registrar Área'),
        backgroundColor: Colors.black,
        foregroundColor: textColor,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showAreaForm,
            child: const Text('Registrar Área'),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => primaryColor,
                  ),
                  headingTextStyle: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  dataRowColor: MaterialStateProperty.resolveWith(
                    (states) => secondaryColor,
                  ),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Descripción')),
                    DataColumn(label: Text('Sucursal')),
                    DataColumn(label: Text('Estatus')),
                    DataColumn(label: Text('Fecha Registro')),
                    DataColumn(label: Text('Fecha Actualización')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: areas.map((area) {
                    return DataRow(
                      cells: [
                        DataCell(Text(area['ID'].toString())),
                        DataCell(Text(area['Nombre']!)),
                        DataCell(Text(area['Descripcion']!)),
                        DataCell(Text(area['Sucursal']!)),
                        DataCell(Text(area['Estatus']! ? 'Activo' : 'Inactivo')),
                        DataCell(Text(area['Fecha_Registro']!)),
                        DataCell(Text(area['Fecha_Actualizacion']!)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editArea(area['ID']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteArea(area['ID']),
                              ),
                            ],
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
