import 'package:flutter/material.dart';
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, Ana 👋',
                      style: TextStyle(color: kGris, fontSize: 13),
                    ),
                    Text(
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
    var appState = context.watch<AppState>(); // <-- nuevo

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
                      dinero(appState.total),
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
            child: const SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: 24, child: ColoredBox(color: kPrimario)),
                  Expanded(flex: 60, child: ColoredBox(color: kIndigo)),
                  Expanded(flex: 9, child: ColoredBox(color: kAmbar)),
                  Expanded(flex: 32, child: ColoredBox(color: kRosa)),
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
          const Row(
            children: [
              Expanded(
                child: _Mini(
                  'Te deben',
                  '+\$1,850.00',
                  kMenta,
                  Icons.south_west_rounded,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _Mini(
                  'Por saldar',
                  '2 pagos',
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
    const colores = [kPrimario, kIndigo, kAmbar, kRosa];
    const letras = ['A', 'L', 'M', 'S'];
    return SizedBox(
      width: 84,
      height: 32,
      child: Stack(
        children: [
          for (int i = 0; i < 4; i++)
            Positioned(
              left: i * 18.0,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: kOscuro,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: colores[i],
                  child: Text(
                    letras[i],
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
                Container(width: 6, color: kCoral),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: kCoral, size: 18),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Solo 2 transferencias para quedar en cero',
                                style: TextStyle(
                                  color: kGrafito,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const _Transferencia(
                          'L',
                          'Luis',
                          'Ana',
                          '\$1,200.00',
                          kIndigo,
                        ),
                        const Divider(height: 16),
                        const _Transferencia(
                          'S',
                          'Sofía',
                          'Ana',
                          '\$650.00',
                          kRosa,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: kPrimario,
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Accion(Icons.add, 'Gasto'),
            _Accion(Icons.document_scanner_outlined, 'Ticket'),
            _Accion(Icons.person_add_alt_1_outlined, 'Invitar'),
            _Accion(Icons.pie_chart_outline, 'Reporte'),
          ],
        ),
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _Accion(this.icono, this.texto);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _Saldos extends StatelessWidget {
  const _Saldos();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          _Saldo('Ana (tú)', 'A', kPrimario, '+\$1,850', true),
          _Saldo('Luis', 'L', kIndigo, '-\$1,200', false),
          _Saldo('María', 'M', kAmbar, '+\$350', true),
          _Saldo('Sofía', 'S', kRosa, '-\$1,000', false),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: tarjeta(),
        child: const Column(
          children: [
            _Gasto(
              Icons.restaurant,
              'Cena en la playa',
              'Ana · Hoy',
              '\$2,400.00',
            ),
            Divider(height: 1),
            _Gasto(Icons.hotel, 'Hotel 3 noches', 'Luis · Ayer', '\$6,000.00'),
            Divider(height: 1),
            _Gasto(
              Icons.local_taxi,
              'Taxi aeropuerto',
              'María · Hace 2 días',
              '\$850.00',
            ),
            Divider(height: 1),
            _Gasto(
              Icons.directions_boat,
              'Tour en lancha',
              'Sofía · Hace 3 días',
              '\$3,200.00',
            ),
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
