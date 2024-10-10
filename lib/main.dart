import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaGuardiao.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

String? guardiaoId; // Para armazenar o ID do Guardião adicionado
String? usuarioId; // Para armazenar o ID do Usuario adicionado


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> verificarUsuarioId() async {
    try {
      // Obtém o diretório onde o arquivo está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/guardiao.txt';
      final file = File(path);

      // Verifica se o arquivo existe
      if (await file.exists()) {
        // Lê o conteúdo do arquivo
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          guardiaoId = contents.split('\n').firstWhere((id) => id.isNotEmpty, orElse: () => "");
        }
      }
    } catch (e) {
      print('Erro ao ler o arquivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: verificarUsuarioId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Carregando...
              ),
            );
          } else {
            if (guardiaoId != null) {
              return PaginaInicio();
            } else {
              return PaginaGuardiao();
            }
          }
        },
      ),
    );
  }
}

