import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../tema.dart';

const _miembros = 4;

const _categorias = [
  'Todos',
  'Comida',
  'Hospedaje',
  'Transporte',
  'Actividades',
];

Color _colorDe(String categoria) {
  switch (categoria) {
    case 'Comida':
      return kCoral;
    case 'Hospedaje':
      return kIndigo;
    case 'Transporte':
      return kAmbar;
    case 'Actividades':
      return kRosa;
    default:
      return kPrimario;
  }
}

IconData _iconoDe(String categoria) {
  switch (categoria) {
    case 'Comida':
      return Icons.restaurant;
    case 'Hospedaje':
      return Icons.hotel;
    case 'Transporte':
      return Icons.local_taxi;
    case 'Actividades':
      return Icons.directions_boat;
    default:
      return Icons.receipt_long;
  }
}

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  // El filtro es solo de esta pantalla, por eso se queda aquí
  var filtroActivo = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final gastos = appState.gastos;

    final filtro = _categorias[filtroActivo];
    final visibles = filtro == 'Todos'
        ? gastos
        : gastos.where((g) => g.categoria == filtro).toList();

    double total = 0;
    for (final g in visibles) {
      total += g.monto;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 44, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Encabezado(grupo: appState.nombreActivo),
            const SizedBox(height: 16),
            _TarjetaResumen(
              total: total,
              cantidad: visibles.length,
              filtro: filtro,
              gastos: visibles,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categorias.length,
                itemBuilder: (context, i) {
                  return _FiltroChip(_categorias[i], filtroActivo == i, () {
                    setState(() {
                      filtroActivo = i;
                    });
                  });
                },
              ),
            ),
            const SizedBox(height: 18),
            _Titulo(
              filtro == 'Todos' ? 'Todos los gastos' : filtro,
              '${visibles.length} registros',
            ),
            if (visibles.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'No hay gastos en esta categoría',
                    style: TextStyle(color: kGris),
                  ),
                ),
              ),
            // reversed: el último gasto agregado aparece primero
            for (final g in visibles.reversed) _TarjetaGasto(g),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

// ───────────── ENCABEZADO ─────────────

class _Encabezado extends StatelessWidget {
  final String grupo;
  const _Encabezado({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: kPrimario,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.receipt_long, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grupo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: kGris, fontSize: 13),
              ),
              const Text(
                'Gastos',
                style: TextStyle(
                  color: kGrafito,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: kBorde),
          ),
          icon: const Icon(Icons.search, color: kGrafito, size: 22),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: kBorde),
          ),
          icon: const Icon(Icons.tune, color: kGrafito, size: 22),
        ),
      ],
    );
  }
}

// ───────────── TARJETA DE RESUMEN (clara) ─────────────

class _TarjetaResumen extends StatelessWidget {
  final double total;
  final int cantidad;
  final String filtro;
  final List<Gasto> gastos;
  const _TarjetaResumen({
    required this.total,
    required this.cantidad,
    required this.filtro,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    final porCategoria = <String, double>{};
    for (final g in gastos) {
      porCategoria[g.categoria] = (porCategoria[g.categoria] ?? 0) + g.monto;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kClaro,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kPrimario.withAlpha(90), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filtro == 'Todos' ? 'Total gastado' : 'Total en $filtro',
            style: const TextStyle(
              color: kPrimario,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dinero(total),
            style: const TextStyle(
              color: kOscuro,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (porCategoria.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    for (final e in porCategoria.entries)
                      Expanded(
                        flex: e.value.round().clamp(1, 1000000),
                        child: ColoredBox(color: _colorDe(e.key)),
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Mini(
                  'Gastos',
                  '$cantidad registrados',
                  Icons.receipt_long_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Mini(
                  'Tu parte',
                  dinero(total / _miembros),
                  Icons.person_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String etiqueta, valor;
  final IconData icono;
  const _Mini(this.etiqueta, this.valor, this.icono);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icono, color: kPrimario, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(color: kGris, fontSize: 11),
                ),
                Text(
                  valor,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kGrafito,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── FILTROS ─────────────

class _FiltroChip extends StatelessWidget {
  final String texto;
  final bool activo;
  final VoidCallback onTap;
  const _FiltroChip(this.texto, this.activo, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activo ? kPrimario : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activo ? kPrimario : kBorde),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: activo ? Colors.white : kGrafito,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ───────────── TÍTULO DE SECCIÓN ─────────────

class _Titulo extends StatelessWidget {
  final String texto, accion;
  const _Titulo(this.texto, this.accion);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: kGrafito,
              ),
            ),
          ),
          Text(
            accion,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kPrimario,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────── TARJETA DE GASTO ─────────────

class _TarjetaGasto extends StatelessWidget {
  final Gasto gasto;
  const _TarjetaGasto(this.gasto);

  @override
  Widget build(BuildContext context) {
    final color = _colorDe(gasto.categoria);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: tarjeta(),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withAlpha(35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_iconoDe(gasto.categoria), color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gasto.titulo,
                  style: const TextStyle(
                    color: kGrafito,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pagó ${gasto.pagador} · entre $_miembros',
                  style: const TextStyle(color: kGris, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${gasto.categoria} · ${gasto.dia}',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dinero(gasto.monto),
                style: const TextStyle(
                  color: kGrafito,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tu parte ${dinero(gasto.monto / _miembros)}',
                style: const TextStyle(color: kGris, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
