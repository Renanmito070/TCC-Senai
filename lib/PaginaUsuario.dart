import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaCadastro.dart';
import 'package:flutternexus/main.dart';
import 'package:path_provider/path_provider.dart';

class PaginaUsuario extends StatefulWidget {
  const PaginaUsuario({super.key});

  @override
  State<PaginaUsuario> createState() => _PaginaUsuarioState();
}

class _PaginaUsuarioState extends State<PaginaUsuario> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? nomeUsuario;
  String? usuarioEmail;
  String? _usuarioSenha;
  String? guardiaoEmail;
  String? guardiaoTelefone;

  Future<void> pegarIdDoArquivoUsuario() async {
    try {
      // Obtém o diretório onde o arquivo está salvo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/usuario.txt';
      final file = File(path);

      // Verifica se o arquivo existe
      if (await file.exists()) {
        // Lê o conteúdo do arquivo
        final conteudo = await file.readAsString();

        // Armazena o ID na variável global
        usuarioId = conteudo.trim();
        print('ID do usuário carregado: $usuarioId');
      } else {
        print('Arquivo não encontrado.');
      }
    } catch (e) {
      print('Erro ao ler ID do arquivo: $e');
    }
  }
  Future<void> obterNomeUsuario() async {
    try {
      await pegarIdDoArquivoUsuario(); // Carrega o ID salvo no arquivo
      print("Entrou no método");
      print(usuarioId);

      // Verifica se o ID do usuário foi carregado corretamente
      if (usuarioId != null) {
        // Obtém o documento do usuário no Firestore com o ID
        DocumentSnapshot usuarioDoc = await firestore.collection('usuarios').doc(usuarioId).get();

        if (usuarioDoc.exists) {
          // Obtém os dados do documento como um Map
          final dadosUsuario = usuarioDoc.data() as Map<String, dynamic>;

          // Verifica se o campo 'nome' existe e o imprime
          if (dadosUsuario.containsKey('nome')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              nomeUsuario = dadosUsuario['nome'];
            });
            print('Nome do Usuário: $nomeUsuario');
          } else {
            print('Campo "nome" não encontrado no documento.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Campo "nome" não encontrado.')),
            );
          }
        } else {
          print('Documento do usuário não encontrado.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário não encontrado no Firestore.')),
          );
        }
      } else {
        print('ID do usuário é nulo.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar o ID do usuário.')),
        );
      }
    } catch (e) {
      print('Erro ao obter nome do usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter nome do usuário: $e')),
      );
    }
  }
  Future<void> excluirArquivoUsuario() async {
    try {
      // Obtém o diretório onde o arquivo está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/usuario.txt';
      final file = File(path);

      // Verifica se o arquivo existe e o exclui
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo excluído com sucesso!')),
        );

        // Redireciona para a página de cadastro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PaginaCadastro()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo não encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir arquivo: $e')),
      );
    }
  }
  Future<void> excluirArquivoGuardiao() async {
    try {
      // Obtém o diretório onde o arquivo está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/guardiao.txt';
      final file = File(path);

      // Verifica se o arquivo existe e o exclui
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo excluído com sucesso!')),
        );

        // Redireciona para a página de cadastro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PaginaCadastro()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo não encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir arquivo: $e')),
      );
    }
  }
  Future<void> excluirArquivoLoginUsuario() async {
    try {
      // Obtém o diretório onde o arquivo está armazenado
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/loginUsuario.txt';
      final file = File(path);

      // Verifica se o arquivo existe e o exclui
      if (await file.exists()) {
        await file.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo excluído com sucesso!')),
        );

        // Redireciona para a página de cadastro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PaginaCadastro()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arquivo não encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir arquivo: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fundo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(30),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7), // Fundo preto com opacidade
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              excluirArquivoUsuario();
                              excluirArquivoGuardiao();
                              excluirArquivoLoginUsuario();
                            },
                            child: Text("Apagar"),
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
