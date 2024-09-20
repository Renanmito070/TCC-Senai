import 'package:flutter/material.dart';
import 'package:flutternexus/Duvidas.dart';
import 'package:flutternexus/MedidaProtetiva.dart';
import 'package:flutternexus/PaginaGuardiao.dart';
import 'package:flutternexus/TelaInicio.dart';


void main() async {
  runApp(MaterialApp(
    home: TelaInicial("", ""),
    // home: Medidaprotetiva(),
    // home: Duvidas(),
    debugShowCheckedModeBanner: false,
  ));
}

