import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? usuario; // Para armazenar os dados do usuário específico
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o Form
  final TextEditingController email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

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
                                controller: email,
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
                            SizedBox(height: 45),
                            SizedBox(
                              width: 260, // Ajuste a largura conforme necessário
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    print('Validação bem-sucedida');
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
                                    Icon(
                                      Icons.verified_user,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Cadastrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
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
