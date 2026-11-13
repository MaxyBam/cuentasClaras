import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../tema.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cabecera(),
              SizedBox(height: 14),
              _Estadisticas(),
              SizedBox(height: 16),
              _Titulo('Mis grupos'),
              _MisGrupos(),
              SizedBox(height: 16),
              _Titulo('Preferencias'),
              _Preferencias(),
              SizedBox(height: 16),
              _Titulo('Cuenta'),
              _Cuenta(),
              SizedBox(height: 90),
            ],
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

ImageProvider? _foto(String? path) {
  if (path == null) return null;
  return kIsWeb ? NetworkImage(path) : FileImage(File(path));
}

String _saldoTexto(double v) =>
    v.abs() < 0.01 ? dinero(0) : '${v > 0 ? '+' : '-'}${dinero(v.abs())}';

Color _saldoColor(double v) =>
    v.abs() < 0.01 ? kGris : (v > 0 ? kVerde : kCoral);

void _aviso(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}

// ===================== Cabecera =====================

class _Cabecera extends StatelessWidget {
  const _Cabecera();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final foto = _foto(app.fotoPath);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kOscuro,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _cambiarFoto(context),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: kPrimario,
                    backgroundImage: foto,
                    child: foto == null
                        ? Text(
                            app.yo.isEmpty ? '?' : app.yo[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        : null,
                  ),
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: kPrimario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              app.yo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              app.correo,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _hoja(context, const _FormPerfil()),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Editar perfil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _cambiarFoto(BuildContext context) async {
  final app = context.read<AppState>();

  final op = await _hoja<String>(
    context,
    Builder(
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloHoja('Foto de perfil'),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: kPrimario),
            title: const Text('Tomar foto'),
            onTap: () => Navigator.pop(ctx, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: kPrimario),
            title: const Text('Elegir de la galería'),
            onTap: () => Navigator.pop(ctx, 'gallery'),
          ),
          if (app.fotoPath != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: kCoral),
              title: const Text('Quitar foto'),
              onTap: () => Navigator.pop(ctx, 'quitar'),
            ),
        ],
      ),
    ),
  );
  if (op == null) return;

  if (op == 'quitar') {
    app.actualizarFoto(null);
    return;
  }

  try {
    final f = await ImagePicker().pickImage(
      source: op == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (f != null) app.actualizarFoto(f.path);
  } catch (e) {
    if (!context.mounted) return;
    _aviso(context, 'No se pudo abrir la cámara o galería');
  }
}

// ===================== Editar perfil =====================

class _FormPerfil extends StatefulWidget {
  const _FormPerfil();

  @override
  State<_FormPerfil> createState() => _FormPerfilState();
}

class _FormPerfilState extends State<_FormPerfil> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _correo;

  @override
  void initState() {
    super.initState();
    final app = context.read<AppState>();
    _nombre = TextEditingController(text: app.yo);
    _correo = TextEditingController(text: app.correo);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AppState>().actualizarPerfil(
      nombre: _nombre.text.trim(),
      correo: _correo.text.trim(),
    );
    Navigator.pop(context);
    _aviso(context, 'Perfil actualizado');
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tituloHoja('Editar perfil'),
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = (v ?? '').trim();
                if (n.isEmpty) return 'Escribe tu nombre';
                if (!app.nombreLibre(n)) {
                  return 'Ya hay un miembro con ese nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final c = (v ?? '').trim();
                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(c);
                return ok ? null : 'Correo inválido';
              },
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
                  'Guardar cambios',
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

// ===================== Estadísticas =====================

class _Estadisticas extends StatelessWidget {
  const _Estadisticas();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final balance = app.balanceGeneral;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _Stat('Grupos', '${app.grupos.length}', kGrafito)),
          const SizedBox(width: 10),
          Expanded(
            child: _Stat(
              'Gastos pagados',
              '${app.gastosPagadosPorMi}',
              kGrafito,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _Stat('Balance', _saldoTexto(balance), _saldoColor(balance)),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String etiqueta, valor;
  final Color color;
  const _Stat(this.etiqueta, this.valor, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: tarjeta(),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              valor,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: const TextStyle(color: kGris, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ===================== Mis grupos =====================

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: kGrafito,
        ),
      ),
    );
  }
}

class _MisGrupos extends StatelessWidget {
  const _MisGrupos();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: tarjeta(),
        child: Column(
          children: [
            for (int i = 0; i < app.grupos.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _FilaGrupo(i),
            ],
            const Divider(height: 1),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: kClaro,
                child: Icon(Icons.add, color: kPrimario),
              ),
              title: const Text(
                'Crear grupo',
                style: TextStyle(color: kPrimario, fontWeight: FontWeight.w700),
              ),
              onTap: () => _crearGrupo(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaGrupo extends StatelessWidget {
  final int indice;
  const _FilaGrupo(this.indice);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final nombre = app.grupos[indice];
    final activo = app.grupoActivo == indice;
    final saldo = app.saldoEnGrupo(nombre);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorDe(indice),
        child: Text(
          nombre[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              nombre,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kGrafito,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          if (activo) ...[
            const SizedBox(width: 6),
            const Icon(Icons.check_circle, color: kPrimario, size: 16),
          ],
        ],
      ),
      subtitle: Text(
        '${app.miembrosDe(nombre)} miembros · ${app.gastosDe(nombre)} gastos',
        style: const TextStyle(color: kGris, fontSize: 12),
      ),
      trailing: Text(
        _saldoTexto(saldo),
        style: TextStyle(
          color: _saldoColor(saldo),
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
      onTap: () {
        app.elegirGrupo(indice);
        _aviso(context, 'Grupo activo: $nombre');
      },
    );
  }
}

Future<void> _crearGrupo(BuildContext context) async {
  final controller = TextEditingController();
  final app = context.read<AppState>();

  final nombre = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nuevo grupo'),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          labelText: 'Nombre del grupo',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kPrimario),
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: const Text('Crear'),
        ),
      ],
    ),
  );
  controller.dispose();

  if (nombre == null || nombre.isEmpty) return;
  if (!context.mounted) return;

  if (app.grupos.contains(nombre)) {
    _aviso(context, 'Ya existe un grupo con ese nombre');
    return;
  }
  app.agregarGrupo(nombre);
  _aviso(context, 'Grupo "$nombre" creado');
}

// ===================== Preferencias =====================

class _Preferencias extends StatelessWidget {
  const _Preferencias();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: tarjeta(),
        child: SwitchListTile(
          secondary: const Icon(Icons.notifications_none, color: kPrimario),
          title: const Text(
            'Notificaciones',
            style: TextStyle(color: kGrafito, fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Avisos de gastos nuevos y pagos',
            style: TextStyle(color: kGris, fontSize: 12),
          ),
          activeThumbColor: kPrimario,
          value: app.notificaciones,
          onChanged: app.cambiarNotificaciones,
        ),
      ),
    );
  }
}

// ===================== Cuenta =====================

class _Cuenta extends StatelessWidget {
  const _Cuenta();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: tarjeta(),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: kPrimario),
              title: const Text(
                'Acerca de',
                style: TextStyle(color: kGrafito, fontWeight: FontWeight.w700),
              ),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'CuentasClaras',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Divide gastos sin complicaciones.',
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: kCoral),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: kCoral, fontWeight: FontWeight.w700),
              ),
              onTap: () => _cerrarSesion(context),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _cerrarSesion(BuildContext context) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Seguro que quieres salir de tu cuenta?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kCoral),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Salir'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  _aviso(context, 'Sesión cerrada');
  // Aquí navegarías a tu pantalla de login cuando la tengas.
}
