import 'package:flutter/material.dart';

class RegisterEmployeePage extends StatelessWidget {
  const RegisterEmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Empleado'),
        backgroundColor: Colors.black, // Cambia el color de la parte superior
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Botón rojo
                foregroundColor: Colors.white, // Texto blanco
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const EmployeeFormDialog(),
                );
              },
              child: const Text('Registrar Empleado'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Área')),
                  DataColumn(label: Text('Puesto')),
                  DataColumn(label: Text('Número')),
                  DataColumn(label: Text('ID de Persona')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Tecnología')),
                    DataCell(Text('Desarrollador')),
                    DataCell(Text('001')),
                    DataCell(Text('12345')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Ventas')),
                    DataCell(Text('Ejecutivo')),
                    DataCell(Text('002')),
                    DataCell(Text('54321')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeFormDialog extends StatelessWidget {
  const EmployeeFormDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar Empleado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(
            decoration: InputDecoration(labelText: 'Área del Empleado'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Puesto'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Número de Empleado'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'ID de Persona'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Botón rojo
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Empleado registrado')),
            );
            Navigator.of(context).pop();
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
    );
  }
}
