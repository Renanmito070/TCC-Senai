import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaCadastro.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:flutternexus/PaginaMaps.dart';
import 'package:flutternexus/main.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int? guardiaoTelefone;
  String? fotoPerfilUrl;
  bool _isObscured = true; // Estado inicial da senha (escondida)

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
  Future<void> pegarIdDoArquivoGuardiao() async {
    try {
      // Obtém o diretório onde o arquivo está salvo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/guardiao.txt';
      final file = File(path);

      // Verifica se o arquivo existe
      if (await file.exists()) {
        // Lê o conteúdo do arquivo
        final conteudo = await file.readAsString();

        // Armazena o ID na variável global
        guardiaoId = conteudo.trim();
        print('ID do usuário carregado: $guardiaoId');
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
          if (dadosUsuario.containsKey('email')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              usuarioEmail = dadosUsuario['email'];
            });
            print('Email do Usuário: $usuarioEmail');
          } else {
            print('Campo "Email" não encontrado no documento.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Campo "Email" não encontrado.')),
            );
          }
          if (dadosUsuario.containsKey('senha')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              _usuarioSenha = dadosUsuario['senha'];
            });
            print('Nome do Usuário: $_usuarioSenha');
          } else {
            print('Campo "senha" não encontrado no documento.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Campo "senha" não encontrado.')),
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
  Future<void> obterGuardiao() async {
    try {
      await pegarIdDoArquivoGuardiao(); // Carrega o ID salvo no arquivo
      print("Entrou no método");
      print(guardiaoId);

      // Verifica se o ID do usuário foi carregado corretamente
      if (guardiaoId != null) {
        // Obtém o documento do usuário no Firestore com o ID
        DocumentSnapshot guardiaoDoc = await firestore.collection('usuarios').doc(usuarioId).collection('guardioes').doc(guardiaoId).get();

        if (guardiaoDoc.exists) {
          // Obtém os dados do documento como um Map
          final dadosGuardiao = guardiaoDoc.data() as Map<String, dynamic>;

          // Verifica se o campo 'nome' existe e o imprime
          if (dadosGuardiao.containsKey('email')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              guardiaoEmail = dadosGuardiao['email'];
            });
            print('Email do guardiao: $guardiaoEmail');
          } else {
            print('Campo "email" não encontrado no documento.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Campo "email" não encontrado.')),
            );
          }
          if (dadosGuardiao.containsKey('telefone')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              guardiaoTelefone = dadosGuardiao['telefone'];
            });
            print('Telefone do guardiao: $guardiaoTelefone');
          } else {
            print('Campo "Telefone" não encontrado no documento.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Campo "Telefone" não encontrado.')),
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
  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured; // Alterna a visibilidade
    });
  }
  @override
  void initState() {
    super.initState();
    obterNomeUsuario();
    obterGuardiao();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    padding: EdgeInsets.only(right: 30, left: 30, bottom: 30, top: 30),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7), // Fundo preto com opacidade
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "PERFIL",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(right: 100, left: 100),
                          child: CircleAvatar(
                            radius: 90,
                            backgroundImage: fotoPerfilUrl != null
                                ? NetworkImage(fotoPerfilUrl!)
                                : AssetImage("images/default_profile.png") as ImageProvider,
                          ),
                        ),
                        Padding(
                            padding:EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: TextEditingController(text: "${nomeUsuario}"),
                            enabled: false, // Desabilita a edição
                            decoration: InputDecoration(
                              labelText: "Nome",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: TextEditingController(text: "${usuarioEmail}"),
                            enabled: false, // Desabilita a edição
                            decoration: InputDecoration(
                              labelText: "Email",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: TextEditingController(text: _usuarioSenha ?? "********"),
                            obscureText: _isObscured, // Esconde ou mostra o texto
                            readOnly: true, // O campo pode ser focado, mas o texto não é editável
                            decoration: InputDecoration(
                              labelText: "Senha",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleVisibility, // Alterna entre mostrar e esconder a senha
                              ),
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "GUARDIÃO",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextField(
                          controller: TextEditingController(text: "${guardiaoEmail}"),
                          enabled: false, // Desabilita a edição
                          decoration: InputDecoration(
                            labelText: "Email",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                            ),
                            labelStyle: TextStyle(color: Colors.white), // Cor do label
                          ),
                          style: TextStyle(color: Colors.white), // Texto branco
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: TextEditingController(text: "${guardiaoTelefone}"),
                            enabled: false, // Desabilita a edição
                            decoration: InputDecoration(
                              labelText: "Telefone",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: ElevatedButton(
                                onPressed: () {
                                  excluirArquivoUsuario();
                                  excluirArquivoGuardiao();
                                  excluirArquivoLoginUsuario();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(color: Colors.red, width: 2), // Borda vermelha
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Borda quadrada
                                  ),
                                ),
                                child: Text(
                                  "Excluir",
                                  style: TextStyle(
                                    color: Colors.red, // Texto vermelho
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.map, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaMaps(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaInicio(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaUsuario(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
