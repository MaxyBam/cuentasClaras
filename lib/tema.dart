import 'package:flutter/material.dart';

const kPrimario = Color(0xFF0F766E);
const kOscuro = Color(0xFF0B3D3A);
const kClaro = Color(0xFFD9F2EE);
const kMenta = Color(0xFF6EE7B7);
const kCoral = Color(0xFFF2545B);
const kAmbar = Color(0xFFF59E0B);
const kIndigo = Color(0xFF6366F1);
const kRosa = Color(0xFFEC4899);
const kVerde = Color(0xFF16A34A);
const kGrafito = Color(0xFF1F2933);
const kGris = Color(0xFF6B7780);
const kBorde = Color(0xFFE1E6E8);
const kFondo = Color(0xFFF4F6F6);

BoxDecoration tarjeta({double radio = 16}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radio),
    border: Border.all(color: kBorde),
  );
}

String dinero(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '\$$entero.${partes[1]}';
}
