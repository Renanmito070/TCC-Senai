import 'package:flutter/material.dart';
import 'package:flutternexus/TelaInicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginaGuardiao extends StatefulWidget {
  const PaginaGuardiao({Key? key}) : super(key: key);

  @override
  State<PaginaGuardiao> createState() => _PaginaGuardiaoState();
}

class _PaginaGuardiaoState extends State<PaginaGuardiao> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey para o Form
  TextEditingController email = TextEditingController();
  TextEditingController telefone = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/imagemFundo1.png"),
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
                    padding: EdgeInsets.only(bottom: 336, top: 335),
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
                              'Cadastre seu entregador',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                              ),
                            ),
                          ),
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
                              keyboardType: TextInputType.phone,
                              controller: telefone,
                              decoration: InputDecoration(
                                labelText: 'Número(Opicional)',
                                labelStyle: TextStyle(color: Colors.white),
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
                                  _sendEmail(email.text);
                                  print('Validação bem-sucedida');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TelaInicial(email.text, telefone.text),
                                    ),
                                  );
                                } else {
                                  print('Falha na validação');
                                }
                              },
                              child: Text(
                                'Cadastrar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
