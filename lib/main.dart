import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutternexus/PaginaCadastro.dart';
import 'package:flutternexus/PaginaGuardiao.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

String? guardiaoId; // Para armazenar o ID do Guardião adicionado
String? usuarioId; // Para armazenar o ID do Usuario adicionado
String? loginUsuario;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> verificarGuardiaoId() async {
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
      print('Erro ao ler o arquivo guardião: $e');
    }
  }

  Future<void> verificarUsuarioId() async {
    try {
      // Obtém o diretório onde o arquivo está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/usuario.txt';
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
      print('Erro ao ler o arquivo usuário: $e');
    }
  }

  Future<void> verificarIds() async {
    await verificarGuardiaoId();
    await verificarUsuarioId();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: verificarIds(), // Aguarda a verificação de ambos os arquivos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Carregando...
              ),
            );
          } else {
            // Verifica se há um usuário logado ou um guardião
            if (guardiaoId != null) {
              return PaginaInicio();
            } else {
              return PaginaCadastro();
            }
          }
        },
      ),
    );
  }
}
