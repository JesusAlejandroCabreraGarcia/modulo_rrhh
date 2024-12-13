import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0)),
              child: Text('Gestión', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Registrar Empleado'),
              onTap: () {
                Navigator.pushNamed(context, '/registerEmployee');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Registrar Área'),
              onTap: () {
                Navigator.pushNamed(context, '/registerArea');
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Registrar Horario'),
              onTap: () {
                Navigator.pushNamed(context, '/registerSchedule');
              },
            ),            
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Registrar Posición'),
              onTap: () {
                Navigator.pushNamed(context, '/register_position'); // Nueva opción
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services),
              title: const Text('Registrar Servicio al Cliente'),
              onTap: () {
                Navigator.pushNamed(context, '/register_service'); // Nueva opción
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Bienvenido a la gestión de empleados y áreas'),
      ),
    );
  }
}
