import 'package:flutter/material.dart';
import '../features/areas/presentation/pages/RegisterAreaPage.dart';
import '../features/employees/presentation/pages/register_employee_page.dart';
import '../features/schedules/presentation/pages/RegisterSchedulePage.dart';
import '../features/positions/presentation/pages/register_position_page.dart';
import '../features/client_services/presentation/pages/register_service_page.dart'; // Nueva importación
import '../features/employees/presentation/pages/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomeScreen(),
    '/registerEmployee': (context) => const RegisterEmployeePage(),
    '/registerArea': (context) => const RegisterAreaPage(),
    '/registerSchedule': (context) => const RegisterSchedulePage(),
    '/register_position': (context) => const RegisterPositionPage(), // Nueva ruta
    '/register_service': (context) => const RegisterServicePage(), // Nueva ruta
  };
}
