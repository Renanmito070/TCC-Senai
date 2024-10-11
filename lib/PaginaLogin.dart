import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:flutternexus/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o Form
  final TextEditingController emailUsuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  String guardiaoEmail2 = "";
  String guardiaoTelefone = "";

  // Método para verificar se o e-mail e senha são válidos
  Future<Map<String, dynamic>> verificarCredenciais(String email, String senha) async {
    try {
      // Busca o documento do usuário com o e-mail fornecido
      QuerySnapshot querySnapshot = await firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      // Verifica se o usuário com o e-mail fornecido existe
      if (querySnapshot.docs.isNotEmpty) {
        // Obtém os dados do usuário
        final doc = querySnapshot.docs.first;
        final dadosUsuario = doc.data() as Map<String, dynamic>;

        // Verifica se a senha fornecida corresponde à armazenada no banco de dados
        if (dadosUsuario['senha'] == senha) {
          // Retorna credenciais válidas e o ID do usuário
          return {
            'isValid': true,
            'userId': doc.id,  // ID do usuário
          };
        } else {
          return {
            'isValid': false,
            'userId': null, // Senha incorreta
          };
        }
      } else {
        return {
          'isValid': false,
          'userId': null, // Usuário não encontrado
        };
      }
    } catch (e) {
      print('Erro ao verificar credenciais: $e');
      return {
        'isValid': false,
        'userId': null, // Em caso de erro
      };
    }
  }
  Future<void> salvarIdEmArquivoLoginUsuario(String LoginUsuario) async {
    try {
      // Obtém o diretório onde o arquivo deve ser salvo
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/loginUsuario.txt';
      final file = File(path);

      // Escreve o ID no arquivo (adiciona ao invés de sobrescrever)
      await file.writeAsString('$LoginUsuario\n', mode: FileMode.append);

      print('ID do Usuario salvo no arquivo: $path');
    } catch (e) {
      print('Erro ao salvar ID no arquivo: $e');
    }
  }

  Future<void> obterGuardioes(String id) async {
    try {
      // Obtém todos os documentos da subcoleção 'guardioes' dentro do documento de 'usuarios'
      QuerySnapshot querySnapshot = await firestore
          .collection('usuarios')
          .doc(id)
          .collection('guardioes')
          .get();

      // Verifica se existem documentos na subcoleção
      if (querySnapshot.docs.isNotEmpty) {
        // Itera sobre os documentos retornados
        querySnapshot.docs.forEach((doc) {
          final dadosGuardiao = doc.data() as Map<String, dynamic>;
          print("Existe Documento");
          setState(() {
            guardiaoEmail2 = dadosGuardiao['email']; // Por exemplo, acessa o campo 'email'
          });
          print(guardiaoEmail2);
          print('Email do Guardião: ${dadosGuardiao['email']}');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhum guardião encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter dados: $e')),
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
            child: Form(
              key: _formKey, // Associar o GlobalKey ao Form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "LOGIN:",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: .5,
                                ),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
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
                                fillColor: Colors.black.withOpacity(0.3),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite um e-mail';
                                }
                                final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Digite um e-mail válido';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 350,
                            child: TextField(
                              controller: _senha,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(Icons.password, color: Colors.white),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 45),
                          SizedBox(
                            width: 260,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  // Verifica as credenciais no banco de dados e obtém o ID do usuário
                                  final resultado = await verificarCredenciais(
                                    emailUsuario.text,
                                    _senha.text,
                                  );

                                  // Verifica se as credenciais são válidas
                                  if (resultado['isValid']) {
                                    print('Login em processo');
                                    String idGuardiao = resultado['userId'];
                                    salvarIdEmArquivoLoginUsuario(idGuardiao);
                                    print(idGuardiao);
                                    await obterGuardioes(idGuardiao);
                                    print(guardiaoEmail2);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaginaInicio(guardiaoEmail2),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('E-mail ou senha incorretos')),
                                    );
                                    emailUsuario.clear();
                                    _senha.clear();
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Login', style: TextStyle(color: Colors.white)),
                                  Icon(Icons.verified_user, color: Colors.white),
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
      ),
    );
  }
}
