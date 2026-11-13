import 'package:flutter/material.dart';

class Gasto {
  final String titulo, categoria, pagador, dia;
  final double monto;
  const Gasto(this.titulo, this.categoria, this.pagador, this.dia, this.monto);
}

class AppState extends ChangeNotifier {
  // ----- Grupos -----
  final grupos = <String>['Viaje a Cancún', 'Depa', 'Oficina'];
  var grupoActivo = 0;

  String get nombreActivo => grupos[grupoActivo];

  void elegirGrupo(int i) {
    grupoActivo = i;
    notifyListeners(); // avisa a todas las pantallas
  }

  void agregarGrupo(String nombre) {
    grupos.add(nombre);
    grupoActivo = grupos.length - 1;
    notifyListeners();
  }

  // ----- Gastos -----
  final gastos = <Gasto>[
    const Gasto('Cena en la playa', 'Comida', 'Ana', 'Hoy', 2400),
    const Gasto('Hotel 3 noches', 'Hospedaje', 'Luis', 'Ayer', 6000),
    const Gasto('Taxi aeropuerto', 'Transporte', 'María', 'Hace 2 días', 850),
    const Gasto('Tour en lancha', 'Actividades', 'Sofía', 'Hace 3 días', 3200),
  ];

  double get total => gastos.fold(0.0, (suma, g) => suma + g.monto);

  void agregarGasto(Gasto g) {
    gastos.add(g);
    notifyListeners();
  }
}
