import 'package:flutter/material.dart';

import 'tema.dart';
import 'pantallas/inicio.dart';
import 'pantallas/grupos.dart';
import 'pantallas/gastos.dart';
import 'pantallas/perfil.dart';

import 'package:provider/provider.dart';

import 'app_state.dart';

void main() => runApp(const CuentaClarasApp());

class CuentaClarasApp extends StatelessWidget {
  const CuentaClarasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'CuentaClaras',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: kFondo,
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimario),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double anchoMax = 520;
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final margenLateral = ((ancho - anchoMax) / 2).clamp(0.0, double.infinity);

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const InicioPage();
        break;
      case 1:
        page = const GruposPage();
        break;
      case 2:
        page = const GastosPage();
        break;
      case 3:
        page = const PerfilPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: margenLateral),
          Expanded(child: page),
          SizedBox(width: margenLateral),
        ],
      ),
      floatingActionButton: selectedIndex != 0
          ? null
          : Padding(
              padding: EdgeInsets.only(right: margenLateral),
              child: FloatingActionButton.extended(
                onPressed: () {},
                elevation: 2,
                backgroundColor: kCoral,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Nuevo gasto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: anchoMax),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            height: 64,
            backgroundColor: Colors.white,
            indicatorColor: kClaro,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: kPrimario),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups, color: kPrimario),
                label: 'Grupos',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long, color: kPrimario),
                label: 'Gastos',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: kPrimario),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
