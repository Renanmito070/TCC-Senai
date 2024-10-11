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
  Map<String, dynamic>? usuario; // Para armazenar os dados do usuário específico
  Map<String, dynamic>? guardiao; // Para armazenar os dados do usuário específico
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o Form
  final TextEditingController emailUsuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController emailGuardiao = TextEditingController();
  final TextEditingController telefone = TextEditingController();
  final TextEditingController nomeUsuario = TextEditingController();

  Future<void> adicionarUsuarioEGuardiao() async {
    try {
      // Adicionar o usuário primeiro
      DocumentReference docRef = await firestore.collection('usuarios').add({
        'nome': nomeUsuario.text,
        'email': emailUsuario.text,
        'senha': _senha.text,
      });

      // Armazena o ID do usuário adicionado
      usuarioId = docRef.id;

      // Salva o ID do usuário no arquivo de texto
      await salvarIdEmArquivoUsuario(usuarioId!);

      // Agora, adicione o guardião dentro do documento de usuário
      DocumentReference guardiaoRef = await firestore
          .collection('usuarios')
          .doc(usuarioId) // Acessa o documento do usuário criado
          .collection('guardioes') // Adiciona à subcoleção "guardioes"
          .add({
        'email': emailGuardiao.text,
        'telefone': int.parse(telefone.text),
      });

      // Armazena o ID do guardião adicionado
      guardiaoId = guardiaoRef.id;

      // Salva o ID do guardião no arquivo de texto
      await salvarIdEmArquivoGuardiao(guardiaoId!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário e guardião adicionados com sucesso!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar usuário e guardião: $e')),
      );
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
                              child: TextField(
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
                                  labelText: 'Email(Guardião)',
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
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: telefone,
                                decoration: InputDecoration(
                                  labelText: 'Telefone(Guardião)',
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
                              ),
                            ),
                            SizedBox(height: 45),
                            SizedBox(
                              width: 260, // Ajuste a largura conforme necessário
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    print('Validação bem-sucedida');
                                    adicionarUsuarioEGuardiao();
                                    print(guardiaoId);
                                    _sendEmail(emailGuardiao.text);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PaginaInicio(),
                                      ),
                                    );
                                  } else {
                                    print('Falha na validação');
                                  }
                                },
                                child: Row(
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
