import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../tema.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              SizedBox(height: 14),
              _AccionesRapidas(),
              SizedBox(height: 16),
              _Titulo('Saldar cuentas', 'Optimizado'),
              _Transferencias(),
              SizedBox(height: 16),
              _Titulo('Saldos del grupo', 'Ver todo'),
              _Saldos(),
              SizedBox(height: 16),
              _Titulo('Gastos recientes', 'Ver todo'),
              _Gastos(),
              SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kPrimario,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.balance, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${context.watch<AppState>().yo} 👋',
                      style: const TextStyle(color: kGris, fontSize: 13),
                    ),
                    const Text(
                      'CuentasClaras',
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
                icon: const Icon(
                  Icons.notifications_none,
                  color: kGrafito,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 45, child: _Grupos()),
          const SizedBox(height: 12),
          const _TarjetaResumen(),
        ],
      ),
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pagado = appState.porPagador;
    final total = appState.total;
    final miembros = appState.miembros;
    final nTransf = appState.transferencias.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kOscuro,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total gastado · ${appState.nombreActivo}',
                      style: const TextStyle(color: kMenta, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dinero(total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const _AvatarStack(),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: total == 0
                  ? const ColoredBox(color: Colors.white24)
                  : Row(
                      children: [
                        for (int i = 0; i < miembros.length; i++)
                          if ((pagado[miembros[i]] ?? 0) > 0)
                            Expanded(
                              flex: ((pagado[miembros[i]]! / total) * 1000)
                                  .round()
                                  .clamp(1, 1000),
                              child: ColoredBox(color: colorDe(i)),
                            ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quién pagó cada parte',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Mini(
                  'Te deben',
                  '+${dinero(appState.teDeben)}',
                  kMenta,
                  Icons.south_west_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Mini(
                  'Por saldar',
                  nTransf == 0
                      ? 'Todo al día'
                      : '$nTransf ${nTransf == 1 ? 'pago' : 'pagos'}',
                  Colors.white,
                  Icons.swap_horiz_rounded,
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
  final Color color;
  final IconData icono;
  const _Mini(this.etiqueta, this.valor, this.color, this.icono);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(24),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
                Text(
                  valor,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
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

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    final visibles = context.watch<AppState>().miembros.take(4).toList();
    return SizedBox(
      width: 18.0 * (visibles.length - 1) + 32,
      height: 32,
      child: Stack(
        children: [
          for (int i = 0; i < visibles.length; i++)
            Positioned(
              left: i * 18.0,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: kOscuro,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: colorDe(i),
                  child: Text(
                    visibles[i][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Transferencias extends StatelessWidget {
  const _Transferencias();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lista = appState.transferencias;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: lista.isEmpty ? kVerde : kCoral),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: lista.isEmpty
                        ? const Row(
                            children: [
                              Icon(Icons.check_circle, color: kVerde, size: 18),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Todo saldado, nadie debe nada',
                                  style: TextStyle(
                                    color: kGrafito,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: kCoral,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Solo ${lista.length} '
                                      '${lista.length == 1 ? 'transferencia' : 'transferencias'}'
                                      ' para quedar en cero',
                                      style: const TextStyle(
                                        color: kGrafito,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              for (int i = 0; i < lista.length; i++) ...[
                                if (i > 0) const Divider(height: 16),
                                _Transferencia(
                                  lista[i].de[0].toUpperCase(),
                                  lista[i].de,
                                  lista[i].para,
                                  dinero(lista[i].monto),
                                  colorDe(
                                    appState.miembros.indexOf(lista[i].de),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => _confirmarSaldado(context),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: kPrimario,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    'Marcar como saldado',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pide confirmación y registra todas las transferencias como pagadas.
Future<void> _confirmarSaldado(BuildContext context) async {
  final appState = context.read<AppState>();
  final n = appState.transferencias.length;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('¿Marcar como saldado?'),
      content: Text(
        'Se registrarán $n ${n == 1 ? 'pago' : 'pagos'} en '
        '"${appState.nombreActivo}" y los saldos de todos quedarán en cero.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(backgroundColor: kPrimario),
          child: const Text('Saldar'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  appState.marcarComoSaldado();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('¡Listo! Las cuentas quedaron saldadas')),
  );
}

class _Transferencia extends StatelessWidget {
  final String inicial, de, para, monto;
  final Color color;
  const _Transferencia(
    this.inicial,
    this.de,
    this.para,
    this.monto,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: color,
          child: Text(
            inicial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          de,
          style: const TextStyle(
            color: kGrafito,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward_rounded, color: kGris, size: 18),
        const SizedBox(width: 6),
        Text(
          para,
          style: const TextStyle(
            color: kGrafito,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          monto,
          style: const TextStyle(
            color: kGrafito,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto, accion;
  const _Titulo(this.texto, this.accion);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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

class _AccionesRapidas extends StatelessWidget {
  const _AccionesRapidas();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: tarjeta(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Accion(Icons.add, 'Gasto', () => _abrirNuevoGasto(context)),
            _Accion(
              Icons.document_scanner_outlined,
              'Ticket',
              () => _escanearTicket(context),
            ),
            _Accion(
              Icons.person_add_alt_1_outlined,
              'Invitar',
              () => _abrirInvitar(context),
            ),
            _Accion(
              Icons.pie_chart_outline,
              'Reporte',
              () => _abrirReporte(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  const _Accion(this.icono, this.texto, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: kClaro,
                shape: BoxShape.circle,
              ),
              child: Icon(icono, color: kPrimario, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kGrafito,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Saldos extends StatelessWidget {
  const _Saldos();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final saldos = appState.saldos;
    final miembros = appState.miembros;

    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (int i = 0; i < miembros.length; i++)
            _Saldo(
              miembros[i] == appState.yo ? '${miembros[i]} (tú)' : miembros[i],
              miembros[i][0].toUpperCase(),
              colorDe(i),
              '${saldos[miembros[i]]! >= 0 ? '+' : '-'}'
              '${dinero(saldos[miembros[i]]!.abs())}',
              saldos[miembros[i]]! >= 0,
            ),
        ],
      ),
    );
  }
}

class _Saldo extends StatelessWidget {
  final String nombre, inicial, monto;
  final Color color;
  final bool aFavor;
  const _Saldo(this.nombre, this.inicial, this.color, this.monto, this.aFavor);

  @override
  Widget build(BuildContext context) {
    final c = aFavor ? kVerde : kCoral;
    return Container(
      width: 124,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: tarjeta(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color,
                child: Text(
                  inicial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nombre,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kGrafito,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          Text(
            aFavor ? 'Le deben' : 'Debe',
            style: const TextStyle(color: kGris, fontSize: 11),
          ),
          Text(
            monto,
            style: TextStyle(
              color: c,
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _Gastos extends StatelessWidget {
  const _Gastos();

  @override
  Widget build(BuildContext context) {
    final recientes = context
        .watch<AppState>()
        .gastos
        .reversed
        .take(4)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: tarjeta(),
        child: Column(
          children: [
            for (int i = 0; i < recientes.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _Gasto(
                iconoDe(recientes[i].categoria),
                recientes[i].titulo,
                '${recientes[i].pagador} · ${recientes[i].dia}',
                dinero(recientes[i].monto),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Gasto extends StatelessWidget {
  final IconData icono;
  final String titulo, subtitulo, monto;
  const _Gasto(this.icono, this.titulo, this.subtitulo, this.monto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: kClaro,
              shape: BoxShape.circle,
            ),
            child: Icon(icono, color: kPrimario, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: kGrafito,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitulo,
                  style: const TextStyle(color: kGris, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            monto,
            style: const TextStyle(
              color: kGrafito,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _Grupos extends StatelessWidget {
  const _Grupos();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (int i = 0; i < appState.grupos.length; i++)
          _ChipGrupo(
            appState.grupos[i],
            appState.grupoActivo == i,
            () => appState.elegirGrupo(i),
          ),
      ],
    );
  }
}

class _ChipGrupo extends StatelessWidget {
  final String texto;
  final bool activo;
  final VoidCallback onTap;
  const _ChipGrupo(this.texto, this.activo, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
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

// ===================== Helpers =====================

Future<T?> _hoja<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20 + MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: SafeArea(top: false, child: child),
    ),
  );
}

Widget _tituloHoja(String texto) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Text(
    texto,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: kGrafito,
    ),
  ),
);

// ===================== Gasto + =====================

void _abrirNuevoGasto(BuildContext context, {String? ticketPath}) {
  _hoja(context, _FormGasto(ticketPath: ticketPath));
}

class _FormGasto extends StatefulWidget {
  final String? ticketPath;
  const _FormGasto({this.ticketPath});

  @override
  State<_FormGasto> createState() => _FormGastoState();
}

class _FormGastoState extends State<_FormGasto> {
  final _titulo = TextEditingController();
  final _monto = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _categoria = categorias.keys.first;
  late String _pagador;

  @override
  void initState() {
    super.initState();
    _pagador = context.read<AppState>().miembros.first;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _monto.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final monto = double.parse(_monto.text.replaceAll(',', '.'));
    context.read<AppState>().agregarGasto(
      Gasto(
        _titulo.text.trim(),
        _categoria,
        _pagador,
        'Hoy',
        monto,
        ticketPath: widget.ticketPath,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gasto "${_titulo.text.trim()}" agregado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final miembros = context.read<AppState>().miembros;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloHoja('Nuevo gasto'),
            if (widget.ticketPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        widget.ticketPath!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.ticketPath!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _titulo,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Escribe una descripción'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _monto,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                return (n == null || n <= 0) ? 'Monto inválido' : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final c in categorias.keys)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) => setState(() => _categoria = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _pagador,
              decoration: const InputDecoration(
                labelText: 'Pagó',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final m in miembros)
                  DropdownMenuItem(value: m, child: Text(m)),
              ],
              onChanged: (v) => setState(() => _pagador = v!),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardar,
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimario,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Guardar gasto',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== Ticket =====================

Future<void> _escanearTicket(BuildContext context) async {
  final fuente = await _hoja<ImageSource>(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloHoja('Agregar ticket'),
        ListTile(
          leading: const Icon(Icons.photo_camera_outlined, color: kPrimario),
          title: const Text('Tomar foto'),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined, color: kPrimario),
          title: const Text('Elegir de la galería'),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ],
    ),
  );
  if (fuente == null) return;

  try {
    final foto = await ImagePicker().pickImage(
      source: fuente,
      imageQuality: 80,
    );
    if (foto == null || !context.mounted) return;
    _abrirNuevoGasto(context, ticketPath: foto.path);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir la cámara o galería')),
    );
  }
}

// ===================== Invitar =====================

void _abrirInvitar(BuildContext context) {
  final appState = context.read<AppState>();
  final codigo = appState.codigoInvitacion;
  final enlace =
      'https://cuentasclaras.app/unirse/$codigo'; // cambia por tu dominio

  _hoja(
    context,
    Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloHoja('Invitar a ${appState.nombreActivo}'),
        const Text(
          'Comparte este código para que otros se unan al grupo.',
          style: TextStyle(color: kGris, fontSize: 13),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: kClaro,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            codigo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              letterSpacing: 6,
              fontWeight: FontWeight.w800,
              color: kPrimario,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copiar código'),
                onPressed: () => _copiar(context, codigo, 'Código copiado'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: kPrimario),
                icon: const Icon(Icons.link),
                label: const Text('Copiar enlace'),
                onPressed: () => _copiar(context, enlace, 'Enlace copiado'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> _copiar(BuildContext context, String texto, String mensaje) async {
  await Clipboard.setData(ClipboardData(text: texto));
  if (!context.mounted) return;
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
}

// ===================== Reporte =====================

void _abrirReporte(BuildContext context) {
  final appState = context.read<AppState>();
  final total = appState.total;

  List<Widget> barras(Map<String, double> datos, {bool conIcono = false}) {
    final orden = datos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return [
      for (final e in orden)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (conIcono) ...[
                    Icon(iconoDe(e.key), size: 16, color: kPrimario),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        color: kGrafito,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${dinero(e.value)}  ·  ${total == 0 ? 0 : (e.value / total * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: kGris, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : e.value / total,
                  minHeight: 8,
                  color: kPrimario,
                  backgroundColor: kClaro,
                ),
              ),
            ],
          ),
        ),
    ];
  }

  _hoja(
    context,
    SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloHoja('Reporte · ${appState.nombreActivo}'),
          Text(
            dinero(total),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: kGrafito,
            ),
          ),
          Text(
            '${appState.gastos.length} gastos',
            style: const TextStyle(color: kGris, fontSize: 12),
          ),
          const SizedBox(height: 18),
          const Text(
            'Por categoría',
            style: TextStyle(fontWeight: FontWeight.w800, color: kGrafito),
          ),
          const SizedBox(height: 10),
          ...barras(appState.porCategoria, conIcono: true),
          const SizedBox(height: 8),
          const Text(
            'Quién pagó',
            style: TextStyle(fontWeight: FontWeight.w800, color: kGrafito),
          ),
          const SizedBox(height: 10),
          ...barras(appState.porPagador),
        ],
      ),
    ),
  );
}
