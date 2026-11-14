import 'dart:math';

import 'package:flutter/material.dart';

import 'tema.dart';

class Gasto {
  final String titulo, categoria, pagador, dia;
  final double monto;
  final String? ticketPath;
  const Gasto(
    this.titulo,
    this.categoria,
    this.pagador,
    this.dia,
    this.monto, {
    this.ticketPath,
  });
}

/// Pago real entre dos miembros (cuando se marca una deuda como saldada).
class Pago {
  final String de, para;
  final double monto;
  const Pago(this.de, this.para, this.monto);
}

class Transferencia {
  final String de, para;
  final double monto;
  const Transferencia(this.de, this.para, this.monto);
}

const categorias = <String, IconData>{
  'Comida': Icons.restaurant,
  'Hospedaje': Icons.hotel,
  'Transporte': Icons.local_taxi,
  'Actividades': Icons.directions_boat,
  'Otros': Icons.receipt_long,
};

IconData iconoDe(String categoria) =>
    categorias[categoria] ?? Icons.receipt_long;

const _paleta = [kPrimario, kIndigo, kAmbar, kRosa];

Color colorDe(int indice) =>
    _paleta[(indice < 0 ? 0 : indice) % _paleta.length];

class AppState extends ChangeNotifier {
  // ----- Perfil -----
  String yo = 'Ana';
  String correo = 'ana@correo.com';
  String? fotoPath;
  bool notificaciones = true;

  /// true si ningún otro miembro, en cualquier grupo, usa ese nombre.
  bool nombreLibre(String n) =>
      n == yo || !_miembrosPorGrupo.values.any((l) => l.contains(n));

  void actualizarPerfil({required String nombre, required String correo}) {
    if (nombre != yo) {
      final viejo = yo;
      for (final lista in _miembrosPorGrupo.values) {
        final i = lista.indexOf(viejo);
        if (i != -1) lista[i] = nombre;
      }
      for (final k in _gastosPorGrupo.keys.toList()) {
        _gastosPorGrupo[k] = [
          for (final g in _gastosPorGrupo[k]!)
            g.pagador == viejo
                ? Gasto(
                    g.titulo,
                    g.categoria,
                    nombre,
                    g.dia,
                    g.monto,
                    ticketPath: g.ticketPath,
                  )
                : g,
        ];
      }
      for (final k in _pagosPorGrupo.keys.toList()) {
        _pagosPorGrupo[k] = [
          for (final p in _pagosPorGrupo[k]!)
            Pago(
              p.de == viejo ? nombre : p.de,
              p.para == viejo ? nombre : p.para,
              p.monto,
            ),
        ];
      }
      yo = nombre;
    }
    this.correo = correo;
    notifyListeners();
  }

  void actualizarFoto(String? path) {
    fotoPath = path;
    notifyListeners();
  }

  void cambiarNotificaciones(bool v) {
    notificaciones = v;
    notifyListeners();
  }

  // ----- Grupos -----
  final grupos = <String>['Viaje a Cancún', 'Depa', 'Oficina'];
  var grupoActivo = 0;

  String get nombreActivo => grupos[grupoActivo];

  void elegirGrupo(int i) {
    grupoActivo = i;
    notifyListeners();
  }

  void agregarGrupo(String nombre) {
    grupos.add(nombre);
    _miembrosPorGrupo[nombre] = [yo];
    _gastosPorGrupo[nombre] = [];
    grupoActivo = grupos.length - 1;
    notifyListeners();
  }

  // ----- Miembros e invitación -----
  final _miembrosPorGrupo = <String, List<String>>{
    'Viaje a Cancún': ['Ana', 'Luis', 'María', 'Sofía'],
    'Depa': ['Ana', 'Carlos', 'Paola'],
    'Oficina': ['Ana', 'Jorge', 'Diego', 'Valeria', 'Rosa'],
  };

  List<String> get miembros =>
      _miembrosPorGrupo.putIfAbsent(nombreActivo, () => [yo]);

  final _codigos = <String, String>{};

  /// Código estable por grupo (se genera la primera vez que se pide).
  String get codigoInvitacion => _codigos.putIfAbsent(nombreActivo, () {
    const letras = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final r = Random();
    return List.generate(6, (_) => letras[r.nextInt(letras.length)]).join();
  });

  // ----- Gastos (uno por grupo) -----
  final _gastosPorGrupo = <String, List<Gasto>>{
    'Viaje a Cancún': [
      const Gasto('Cena en la playa', 'Comida', 'Ana', 'Hoy', 2400),
      const Gasto('Hotel 3 noches', 'Hospedaje', 'Luis', 'Ayer', 6000),
      const Gasto('Taxi aeropuerto', 'Transporte', 'María', 'Hace 2 días', 850),
      const Gasto(
        'Tour en lancha',
        'Actividades',
        'Sofía',
        'Hace 3 días',
        3200,
      ),
    ],
    'Depa': [
      const Gasto(
        'Renta de noviembre',
        'Hospedaje',
        'Carlos',
        'Hace 5 días',
        9000,
      ),
      const Gasto('Internet', 'Otros', 'Ana', 'Hace 4 días', 599),
      const Gasto('Súper de la semana', 'Comida', 'Paola', 'Ayer', 1350),
      const Gasto('Luz', 'Otros', 'Ana', 'Hoy', 720),
    ],
    'Oficina': [
      const Gasto('Comida de equipo', 'Comida', 'Jorge', 'Hoy', 1850),
      const Gasto('Café y galletas', 'Comida', 'Rosa', 'Ayer', 280),
      const Gasto('Uber a cliente', 'Transporte', 'Diego', 'Hace 2 días', 340),
      const Gasto(
        'Regalo de cumpleaños',
        'Otros',
        'Valeria',
        'Hace 6 días',
        650,
      ),
    ],
  };

  List<Gasto> get gastos => _gastosPorGrupo.putIfAbsent(nombreActivo, () => []);

  double get total => gastos.fold(0.0, (suma, g) => suma + g.monto);

  Map<String, double> get porCategoria {
    final m = <String, double>{};
    for (final g in gastos) {
      m[g.categoria] = (m[g.categoria] ?? 0) + g.monto;
    }
    return m;
  }

  Map<String, double> get porPagador {
    final m = <String, double>{};
    for (final g in gastos) {
      m[g.pagador] = (m[g.pagador] ?? 0) + g.monto;
    }
    return m;
  }

  void agregarGasto(Gasto g) {
    gastos.add(g); // se agrega al grupo activo
    notifyListeners();
  }

  // ----- Pagos (deudas ya saldadas, uno por grupo) -----
  final _pagosPorGrupo = <String, List<Pago>>{};

  List<Pago> get pagos => _pagosPorGrupo.putIfAbsent(nombreActivo, () => []);

  // ----- Saldos -----
  /// Calcula el saldo de cada miembro de un grupo.
  /// Saldo = lo que pagó - su parte equitativa (total / miembros) + lo que ya transfirió - lo que ya le transfirieron.
  /// Positivo = le deben, negativo = debe. Se redondea a centavos.
  Map<String, double> _calcularSaldos(
    List<String> ms,
    List<Gasto> gs,
    List<Pago> ps,
  ) {
    if (ms.isEmpty) return {};
    final totalG = gs.fold(0.0, (s, g) => s + g.monto);
    final parte = totalG / ms.length;
    final res = {for (final m in ms) m: -parte};
    for (final g in gs) {
      if (res.containsKey(g.pagador)) res[g.pagador] = res[g.pagador]! + g.monto;
    }
    for (final p in ps) {
      if (res.containsKey(p.de)) res[p.de] = res[p.de]! + p.monto;
      if (res.containsKey(p.para)) res[p.para] = res[p.para]! - p.monto;
    }
    return {
      for (final e in res.entries) e.key: (e.value * 100).roundToDouble() / 100,
    };
  }

  /// Saldo por persona en el grupo activo.
  Map<String, double> get saldos => _calcularSaldos(miembros, gastos, pagos);

  /// Registra como pagadas todas las transferencias pendientes del grupo
  /// activo, con lo que todos los saldos quedan en cero.
  void marcarComoSaldado() {
    final pendientes = transferencias;
    if (pendientes.isEmpty) return;
    pagos.addAll([for (final t in pendientes) Pago(t.de, t.para, t.monto)]);
    notifyListeners();
  }

  /// Lo que te deben a ti. Si estás en deuda, es 0.
  double get teDeben => max(0.0, saldos[yo] ?? 0);

  /// Mínimo de transferencias para dejar todo en cero (algoritmo voraz).
  List<Transferencia> get transferencias {
    final deudores = <MapEntry<String, double>>[];
    final acreedores = <MapEntry<String, double>>[];
    for (final e in saldos.entries) {
      if (e.value < -0.01) deudores.add(MapEntry(e.key, -e.value));
      if (e.value > 0.01) acreedores.add(MapEntry(e.key, e.value));
    }
    deudores.sort((a, b) => b.value.compareTo(a.value));
    acreedores.sort((a, b) => b.value.compareTo(a.value));

    final res = <Transferencia>[];
    var i = 0, j = 0;
    var deuda = deudores.isEmpty ? 0.0 : deudores[0].value;
    var credito = acreedores.isEmpty ? 0.0 : acreedores[0].value;

    while (i < deudores.length && j < acreedores.length) {
      final monto = min(deuda, credito);
      res.add(Transferencia(deudores[i].key, acreedores[j].key, monto));
      deuda -= monto;
      credito -= monto;
      if (deuda < 0.01) {
        i++;
        if (i < deudores.length) deuda = deudores[i].value;
      }
      if (credito < 0.01) {
        j++;
        if (j < acreedores.length) credito = acreedores[j].value;
      }
    }
    return res;
  }

  // ----- Estadísticas por grupo (perfil) -----
  int miembrosDe(String g) => (_miembrosPorGrupo[g] ?? const []).length;
  int gastosDe(String g) => (_gastosPorGrupo[g] ?? const []).length;

  /// Tu saldo en un grupo (incluye las deudas ya saldadas).
  double saldoEnGrupo(String g) =>
      _calcularSaldos(
        _miembrosPorGrupo[g] ?? const <String>[],
        _gastosPorGrupo[g] ?? const <Gasto>[],
        _pagosPorGrupo[g] ?? const <Pago>[],
      )[yo] ??
      0.0;

  double get balanceGeneral => grupos.fold(0.0, (s, g) => s + saldoEnGrupo(g));

  int get gastosPagadosPorMi => _gastosPorGrupo.values.fold(
    0,
    (s, l) => s + l.where((g) => g.pagador == yo).length,
  );
}
