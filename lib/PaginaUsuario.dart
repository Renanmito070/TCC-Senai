import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaCadastro.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:flutternexus/PaginaMaps.dart';
import 'package:flutternexus/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PaginaUsuario extends StatefulWidget {
  const PaginaUsuario({super.key});

  @override
  State<PaginaUsuario> createState() => _PaginaUsuarioState();
}

class _PaginaUsuarioState extends State<PaginaUsuario> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? usuarioEmail;
  String? guardiaoEmail;
  int? guardiaoTelefone;
  String? fotoPerfilUrl;
  bool _isObscured = true; // Estado inicial da senha (escondida)
  bool _editarNomeUsuario = false;
  bool _editarEmailUsuario = false;
  bool _editarSenhaUsuario = false;
  bool _editarEmailGuardiao = false;
  bool _editarTelefoneGuardiao = false;
  TextEditingController _nomeUsuarioController = TextEditingController();
  TextEditingController _emailUsuarioController = TextEditingController();
  TextEditingController _senhaUsuarioController = TextEditingController();
  TextEditingController _emailGuardiaoController = TextEditingController();
  TextEditingController _telefoneGuardiaoController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        fotoPerfilUrl = pickedFile.path;
      });
    }
  }
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Escolher da Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Usar Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _obterDadosUsuario() async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .get();

      if (doc.exists) {
        setState(() {
          _nomeUsuarioController.text = doc['nome']; // Popula o campo de email
          _emailGuardiaoController.text = doc['email'];
          _senhaUsuarioController.text = doc['senha'];
        });
      } else {
        print("Guardião não encontrado");
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
    }
  }
  Future<void> _obterDadosGuardiao() async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('guardioes')
          .doc(guardiaoId)
          .get();

      if (doc.exists) {
        setState(() {
          _emailGuardiaoController.text = doc['email']; // Popula o campo de email
          _telefoneGuardiaoController.text = doc['telefone'].toString();
        });
      } else {
        print("Guardião não encontrado");
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
    }
  }
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
              _nomeUsuarioController.text = dadosUsuario['nome'];
            });
            print('Nome do Usuário: ${_nomeUsuarioController.text}');
          } else {
            print('Campo "nome" não encontrado no documento.');
          }
          if (dadosUsuario.containsKey('email')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              _emailUsuarioController.text = dadosUsuario['email'];
            });
            print('Email do Usuário: ${_emailUsuarioController.text}');
          } else {
            print('Campo "Email" não encontrado no documento.');
          }
          if (dadosUsuario.containsKey('senha')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              _senhaUsuarioController.text = dadosUsuario['senha'];
            });
            print('Nome do Usuário: ${_senhaUsuarioController.text}');
          } else {
            print('Campo "senha" não encontrado no documento.');
          }
        } else {
          print('Documento do usuário não encontrado.');
        }
      } else {
        print('ID do usuário é nulo.');
      }
    } catch (e) {
      print('Erro ao obter nome do usuário: $e');
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
              _emailGuardiaoController.text = dadosGuardiao['email'];
            });
            print('Email do guardiao: ${_emailGuardiaoController.text}');
          } else {
            print('Campo "email" não encontrado no documento.');
          }
          if (dadosGuardiao.containsKey('telefone')) {

            // Atualiza o estado com o nome do usuário, se necessário
            setState(() {
              _telefoneGuardiaoController.text = dadosGuardiao['telefone'].toString();
            });
            print('Telefone do guardiao: ${_telefoneGuardiaoController.text}');
          } else {
            print('Campo "Telefone" não encontrado no documento.');
          }
        } else {
          print('Documento do usuário não encontrado.');
        }
      } else {
        print('ID do usuário é nulo.');
      }
    } catch (e) {
      print('Erro ao obter nome do usuário: $e');
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
        print("Arquivo excluído com sucesso!");

        // Redireciona para a página de cadastro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PaginaCadastro()),
        );
      } else {
        print("Arquivo não encontrado");
      }
    } catch (e) {
      print("Erro ao excluir arquivo: $e");
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
        print("Arquivo excluído com sucesso!");

        // Redireciona para a página de cadastro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PaginaCadastro()),
        );
      } else {
        print("Arquivo não encontrado");
      }
    } catch (e) {
      print("Erro ao excluir arquivo: $e");
    }
  }
  Future<void> atualizarCampo(String usuarioId, String guardiaoId, Map<String, dynamic> novosDados) async {
    try {
      // Acessa o documento do guardião na subcoleção 'guardioes' do 'usuario'
      await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('guardioes')
          .doc(guardiaoId)
          .update(novosDados); // Atualiza os campos fornecidos

      print("Campo(s) atualizado(s) com sucesso!");
    } catch (e) {
      print("Erro ao atualizar o campo: $e");
    }
  }
  Future<void> _atualizarGuardiao() async {
    try {
      await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection("guardioes")
          .doc(guardiaoId)
          .update({
        'email': _emailGuardiaoController.text, // Atualiza o campo de email no Firestore
        'telefone': int.tryParse(_telefoneGuardiaoController.text) ?? 0, // Atualiza o campo de email no Firestore
      });
      print("Guardião atualizado com sucesso");
    } catch (e) {
      print("Erro ao atualizar: $e");
    }
  }
  Future<void> _atualizarUsuario() async {
    try {
      await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .update({
        'nome': _nomeUsuarioController.text, // Atualiza o campo de email no Firestore
        'email': _emailUsuarioController.text, // Atualiza o campo de email no Firestore
        'senha': _senhaUsuarioController.text,
      });
      print("Guardião atualizado com sucesso");
    } catch (e) {
      print("Erro ao atualizar: $e");
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
    _obterDadosGuardiao();
    _obterDadosUsuario();
  }
  @override
  void dispose() {
    _nomeUsuarioController.dispose();
    _emailUsuarioController.dispose();
    _senhaUsuarioController.dispose();
    _emailGuardiaoController.dispose();
    _telefoneGuardiaoController.dispose();
    _focusNode.dispose();
    super.dispose();
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 90,
                                backgroundImage: fotoPerfilUrl != null
                                    ? FileImage(File(fotoPerfilUrl!))  // Usar FileImage para imagens locais
                                    : AssetImage("images/default_profile.png") as ImageProvider,
                              ),
                              SizedBox(height: 10), // Espaço entre o avatar e o botão
                              GestureDetector(
                                onTap: _showPickerOptions,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white, // Escolha a cor do ícone
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          )

                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: _nomeUsuarioController,
                            focusNode: _focusNode, // Adicione o FocusNode aqui
                            readOnly: !_editarNomeUsuario, // Torna o campo apenas leitura quando não está no modo de edição
                            decoration: InputDecoration(
                              labelText: "Nome",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando habilitado
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _editarNomeUsuario ? Icons.check : Icons.edit, // Alterna entre o ícone de editar e de check
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_editarNomeUsuario) {
                                      print("Atualizando...");
                                      _atualizarUsuario(); // Chama a função para atualizar os dados no banco
                                    }
                                    _editarNomeUsuario = !_editarNomeUsuario; // Alterna o estado de edição
                                    if (_editarNomeUsuario) {
                                      _focusNode.requestFocus(); // Garante que o campo tenha foco quando em modo de edição
                                    } else {
                                      _focusNode.unfocus(); // Remove o foco quando a edição é desativada
                                    }
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: _emailUsuarioController,
                            focusNode: _focusNode, // Adicione o FocusNode aqui
                            readOnly: !_editarEmailUsuario, // Torna o campo apenas leitura quando não está no modo de edição
                            decoration: InputDecoration(
                              labelText: "Email",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _editarEmailUsuario ? Icons.check : Icons.edit, // Alterna entre o ícone de editar e de check
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_editarEmailUsuario) {
                                      print("Atualizando...");
                                      _atualizarUsuario(); // Chama a função para atualizar os dados no banco
                                    }
                                    _editarEmailUsuario = !_editarEmailUsuario; // Alterna o estado de edição
                                    if (_editarEmailUsuario) {
                                      _focusNode.requestFocus(); // Garante que o campo tenha foco quando em modo de edição
                                    } else {
                                      _focusNode.unfocus(); // Remove o foco quando a edição é desativada
                                    }
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Colors.white), // Texto branco
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: _senhaUsuarioController,
                            focusNode: _focusNode, // Adicione o FocusNode aqui
                            readOnly: !_editarSenhaUsuario, // Torna o campo apenas leitura quando não está no modo de edição
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
                                  _editarSenhaUsuario ? Icons.check : Icons.edit, // Alterna entre o ícone de editar e de check
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_editarSenhaUsuario) {
                                      print("Atualizando...");
                                      _atualizarUsuario(); // Chama a função para atualizar os dados no banco
                                    }
                                    _editarSenhaUsuario = !_editarSenhaUsuario; // Alterna o estado de edição
                                    if (_editarSenhaUsuario) {
                                      _focusNode.requestFocus(); // Garante que o campo tenha foco quando em modo de edição
                                    } else {
                                      _focusNode.unfocus(); // Remove o foco quando a edição é desativada
                                    }
                                  });
                                },
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
                          controller: _emailGuardiaoController,
                          focusNode: _focusNode, // Adicione o FocusNode aqui
                          readOnly: !_editarEmailGuardiao, // Torna o campo apenas leitura quando não está no modo de edição
                          decoration: InputDecoration(
                            labelText: "Email",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                            ),
                            labelStyle: TextStyle(color: Colors.white), // Cor do label
                            suffixIcon: IconButton(
                              icon: Icon(
                                _editarEmailGuardiao ? Icons.check : Icons.edit, // Alterna entre o ícone de editar e de check
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_editarEmailGuardiao) {
                                    print("Atualizando...");
                                    _atualizarGuardiao(); // Chama a função para atualizar os dados no banco
                                  }
                                  _editarEmailGuardiao = !_editarEmailGuardiao; // Alterna o estado de edição
                                  if (_editarEmailGuardiao) {
                                    _focusNode.requestFocus(); // Garante que o campo tenha foco quando em modo de edição
                                  } else {
                                    _focusNode.unfocus(); // Remove o foco quando a edição é desativada
                                  }
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.white), // Texto branco
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15, top: 20),
                          child: TextField(
                            controller: _telefoneGuardiaoController,
                            focusNode: _focusNode, // Adicione o FocusNode aqui
                            readOnly: !_editarTelefoneGuardiao, // Torna o campo apenas leitura quando não está no modo de edição
                            decoration: InputDecoration(
                              labelText: "Telefone",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca embaixo
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white), // Linha branca quando desabilitado
                              ),
                              labelStyle: TextStyle(color: Colors.white), // Cor do label
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _editarTelefoneGuardiao ? Icons.check : Icons.edit, // Alterna entre o ícone de editar e de check
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_editarTelefoneGuardiao) {
                                      print("Atualizando...");
                                      _atualizarGuardiao(); // Chama a função para atualizar os dados no banco
                                    }
                                    _editarTelefoneGuardiao = !_editarTelefoneGuardiao; // Alterna o estado de edição
                                    if (_editarTelefoneGuardiao) {
                                      _focusNode.requestFocus(); // Garante que o campo tenha foco quando em modo de edição
                                    } else {
                                      _focusNode.unfocus(); // Remove o foco quando a edição é desativada
                                    }
                                  });
                                },
                              ),
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(color: Colors.amber, width: 2), // Borda vermelha
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Borda quadrada
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Logout ',
                                      style: TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Colors.amber,
                                    ),
                                  ],
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
