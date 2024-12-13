// models/schedule.dart
class Schedule {
  final int? id;
  final String usuario;
  final String tipo;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final DateTime fechaRegistro;
  final bool estatus;
  final String empleado;
  final String sucursal;
  final String servicio;

  Schedule({
    this.id,
    required this.usuario,
    required this.tipo,
    required this.fechaInicio,
    required this.fechaFin,
    required this.fechaRegistro,
    required this.estatus,
    required this.empleado,
    required this.sucursal,
    required this.servicio,
  });

  // Deserializar desde JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['ID'],
      usuario: json['Usuario'],
      tipo: json['Tipo'],
      fechaInicio: DateTime.parse(json['Fecha_Inicio']),
      fechaFin: DateTime.parse(json['Fecha_Fin']),
      fechaRegistro: DateTime.parse(json['Fecha_Registro']),
      estatus: json['Estatus'],
      empleado: json['Empleado'],
      sucursal: json['Sucursal'],
      servicio: json['Servicio'],
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Usuario': usuario,
      'Tipo': tipo,
      'Fecha_Inicio': fechaInicio.toIso8601String(),
      'Fecha_Fin': fechaFin.toIso8601String(),
      'Fecha_Registro': fechaRegistro.toIso8601String(),
      'Estatus': estatus,
      'Empleado': empleado,
      'Sucursal': sucursal,
      'Servicio': servicio,
    };
  }
}
