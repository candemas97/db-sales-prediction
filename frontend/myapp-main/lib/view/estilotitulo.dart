import 'package:flutter/material.dart';

class EstiloTitulo extends StatelessWidget {
  final String textoTitulo;
  const EstiloTitulo({
    super.key, required this.textoTitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text( textoTitulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(44, 86, 151, 1)),),);
  }
}