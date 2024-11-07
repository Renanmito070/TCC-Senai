import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:flutternexus/PaginaLogin.dart';
import 'package:flutternexus/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Map<String, dynamic>? usuario; // Para armazenar os dados do usuário específico
  Map<String, dynamic>? guardiao; // Para armazenar os dados do usuário específico
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o Form
  final TextEditingController emailUsuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController confirmarSenha = TextEditingController();
  final TextEditingController emailGuardiao = TextEditingController();
  final TextEditingController telefone = TextEditingController();
  final TextEditingController nomeUsuario = TextEditingController();

  Future<bool> verificarSenha() async {
    if (_senha.text == confirmarSenha.text) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
  Future<void> adicionarUsuarioEGuardiao() async {
    try {
      // Adicionar o usuário primeiro
      DocumentReference docRef = await firestore.collection('usuarios').add({
        'nome': nomeUsuario.text,
        'email': emailUsuario.text,
        'senha': _senha.text, // Certifique-se que a senha seja manipulada com segurança
      });

      // Armazena o ID do usuário adicionado e chama setState para garantir que o estado seja atualizado
      if (mounted) {
        setState(() {
          usuarioId = docRef.id;
        });
      }
      print('ID do usuário adicionado ao firebase: $usuarioId');

      // Salva o ID do usuário no arquivo de texto
      await salvarIdEmArquivoUsuario(usuarioId!);

      // Agora, adicione o guardião dentro do documento de usuário
      DocumentReference guardiaoRef = await firestore
          .collection('usuarios')
          .doc(usuarioId) // Acessa o documento do usuário criado
          .collection('guardioes') // Adiciona à subcoleção "guardioes"
          .add({
        'email': emailGuardiao.text,
        'telefone': int.tryParse(telefone.text) ?? 0, // Certifique-se de que o telefone seja convertido corretamente
      });

      // Armazena o ID do guardião adicionado e atualiza o estado
      setState(() {
        guardiaoId = guardiaoRef.id;
      });
      print('ID do guardião adicionado: $guardiaoId');

      // Salva o ID do guardião no arquivo de texto, se necessário
      await salvarIdEmArquivoGuardiao(guardiaoId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário e guardião adicionados com sucesso!')),
        );
      }

      // Navega para a próxima página somente após concluir as operações
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaginaInicio()),
      );
    } catch (e) {
      // Tratamento de erro ao adicionar usuário e guardião
      print('Erro ao adicionar usuário e guardião: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar usuário e guardião: $e')),
        );
      }
    }
  }
  Future<void> salvarIdEmArquivoUsuario(String usuarioId) async {
    try {
      // Obtém o diretório onde o arquivo deve ser salvo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/usuario.txt';
      final file = File(path);

      // Escreve o ID no arquivo (adiciona ao invés de sobrescrever)
      await file.writeAsString('$usuarioId\n', mode: FileMode.append);

      print('ID do Usuario salvo no arquivo: $path');
    } catch (e) {
      print('Erro ao salvar ID no arquivo: $e');
    }
  }
  Future<void> salvarIdEmArquivoGuardiao(String guardiaoId) async {
    try {
      // Obtém o diretório onde o arquivo deve ser salvo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/guardiao.txt';
      final file = File(path);

      // Escreve o ID no arquivo (adiciona ao invés de sobrescrever)
      await file.writeAsString('$guardiaoId\n', mode: FileMode.append);

      print('ID do Guardião salvo no arquivo: $path');
    } catch (e) {
      print('Erro ao salvar ID no arquivo: $e');
    }
  }
  Future<void> _sendEmail(String recipient) async {
    const String serviceId = 'service_q3u8fbq';
    const String templateId = 'template_ce4ay4a';
    const String userId = 'rDX7TBHyB5wPKP1Mz';

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_email': recipient,
          'from_name': 'App User',
          'message': "https://t.me/FlutterTelegramNexusBot",
        },
      }),
    );
    if (response.statusCode == 200) {
      print("Email enviado para: $recipient");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar email: ${response.body}'),
        ),
      );
      print('Erro ao enviar email: ${response.statusCode}');
      print('Resposta: ${response.body}');
    }
  }
  @override
  void initState() {
    super.initState();
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
              child: Form(
                key: _formKey, // Associar o GlobalKey ao Form
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // Container para o fundo preto dos campos e botões
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
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
                                "CADASTRE-SE:",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 15, top: 20)),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: nomeUsuario,
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.person, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Nome está vazia');
                                    return 'Por favor, digite uma nome';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailUsuario,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.email, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Email está vazio');
                                    return 'Por favor, digite um e-mail';
                                  }
                                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                  if (!emailRegExp.hasMatch(value)) {
                                    print('Erro: Email inválido');
                                    return 'Digite um e-mail válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                controller: _senha,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.password, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Senha está vazia');
                                    return 'Por favor, digite uma senha';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                controller: confirmarSenha,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar senha',
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.password, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Senha está vazia');
                                    return 'Por favor, digite uma senha';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 15, top: 20)),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "CADASTRE SEU ENTREGADOR:",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 15, top: 20)),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailGuardiao,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.email, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Email está vazio');
                                    return 'Por favor, digite um e-mail';
                                  }
                                  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                  if (!emailRegExp.hasMatch(value)) {
                                    print('Erro: Email inválido');
                                    return 'Digite um e-mail válido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 350, // Ajuste a largura conforme necessário
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: telefone,
                                decoration: InputDecoration(
                                  labelText: 'Telefone',
                                  labelStyle: TextStyle(
                                      color: Colors.white
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: Icon(Icons.phone, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3), // Fundo do campo
                                ),
                                style: TextStyle(color: Colors.white), // Cor do texto
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    print('Erro: Telefone está vazia');
                                    return 'Por favor, digite uma telefone';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 45),
                            SizedBox(
                              width: 260, // Ajuste a largura conforme necessário
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    bool senhaValida = await verificarSenha(); // Aguardar o resultado de verificarSenha()

                                    if (senhaValida) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        await adicionarUsuarioEGuardiao();
                                        await _sendEmail(emailGuardiao.text);
                                        print('Validação bem-sucedida');
                                      } catch (error) {
                                        print('Erro: $error');
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('As senhas não são as mesmas'),
                                        ),
                                      );
                                    }
                                  } else {
                                    print('Falha na validação');
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Cadastrar ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.verified_user,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20)),
                            SizedBox(
                              width: 260, // Ajuste a largura conforme necessário
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PaginaLogin(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.verified_user,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  textStyle: TextStyle(fontSize: 18),
                                ),
                              ),
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
        )
    );
  }
}
