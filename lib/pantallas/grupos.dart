import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../tema.dart';

// Ya no necesita ser StatefulWidget: los datos viven en AppState
class GruposPage extends StatelessWidget {
  const GruposPage({super.key});

  void _nuevoGrupo(BuildContext context, AppState appState) {
    final controlador = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo grupo'),
          content: TextField(
            controller: controlador,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nombre del grupo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final nombre = controlador.text.trim();
                if (nombre.isEmpty) return;
                appState.agregarGrupo(nombre); // antes: nombres.add + setState
                Navigator.pop(dialogContext);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lee el estado compartido y se redibuja cuando cambia
    var appState = context.watch<AppState>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 44, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Encabezado(),
            const SizedBox(height: 16),
            _TarjetaResumen(
              nombreActivo: appState.nombreActivo,
              totalGrupos: appState.grupos.length,
            ),
            const SizedBox(height: 22),
            const _Titulo('Tus grupos', 'Toca para elegir'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < appState.grupos.length; i++)
                  _ChipGrupo(
                    appState.grupos[i],
                    appState.grupoActivo == i,
                    () => appState.elegirGrupo(i), // antes: setState
                  ),
                _ChipGrupo(
                  '+ Nuevo',
                  false,
                  () => _nuevoGrupo(context, appState),
                ),
              ],
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

// ───────────── ENCABEZADO ─────────────

class _Encabezado extends StatelessWidget {
  const _Encabezado();

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
          child: const Icon(Icons.groups, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organiza tus cuentas',
                style: TextStyle(color: kGris, fontSize: 13),
              ),
              Text(
                'Mis grupos',
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
      ],
    );
  }
}

// ───────────── TARJETA DE RESUMEN ─────────────

class _TarjetaResumen extends StatelessWidget {
  final String nombreActivo;
  final int totalGrupos;
  const _TarjetaResumen({
    required this.nombreActivo,
    required this.totalGrupos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kOscuro,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grupo activo',
            style: TextStyle(color: kMenta, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            nombreActivo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Mini(
                  'Grupos',
                  '$totalGrupos en total',
                  Colors.white,
                  Icons.folder_open_rounded,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _Mini(
                  'Miembros',
                  '4 personas',
                  kMenta,
                  Icons.group_outlined,
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
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
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

// ───────────── TÍTULO DE SECCIÓN ─────────────

class _Titulo extends StatelessWidget {
  final String texto, accion;
  const _Titulo(this.texto, this.accion);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

// ───────────── CHIP DE GRUPO ─────────────

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
        margin: const EdgeInsets.only(right: 10, bottom: 7),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
