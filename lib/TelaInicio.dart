import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaMaps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaInicial extends StatefulWidget {
  String email;
  String telefone;

  TelaInicial(this.email, this.telefone);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  String _address = '';
  late AnimationController _controller;
  final String botToken = '7540693977:AAG3Tf0mjzMIHMpUtaFjK3l3TCM3d4knuOI';
  final List<String> chatIds = ['6727844526', '5475743506', "6022440283"];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Duração da rotação completa
      vsync: this,
    )..repeat(); // Repetir indefinidamente
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _address = "${place.street}, ${place.subThoroughfare}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('O serviço de localização está desativado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização negada permanentemente.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await _getAddressFromLatLng(position);
  }

  Future<void> _sendEmail(String recipient) async {
    const String serviceId = 'service_q3u8fbq';
    const String templateId = 'template_k3evpzl';
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
          'message': _address,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pedido a caminho!!!',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> _handleSubmit() async {
    print('Validação bem-sucedida');
    final emaill = widget.email;

    try {
      if (_address.isEmpty) {
        print('Obtendo endereço...');
        await _determinePosition();
      }
      if (_address.isNotEmpty) {
        final String url = 'https://api.telegram.org/bot$botToken/sendMessage';
        final String message = 'Peço que você entre em contato com [Nome da pessoa em perigo] o mais rápido possível para verificar se ela está bem. Por favor, se dirija ao local onde ela se encontra ou entre em contato com as autoridades locais para garantir que ela receba a ajuda necessária. $_address'; // Mensagem predefinida

        await _sendEmail(emaill);

        for (String chatId in chatIds) {
          final response = await http.post(
            Uri.parse(url),
            body: {
              'chat_id': chatId,
              'text': message,
            },
          );
        }
      } else {
        print('Endereço não encontrado.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: Endereço não encontrado.'),
          ),
        );
      }
    } catch (e) {
      print('Erro ao obter a posição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao obter localização: $e'),
        ),
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
              image: AssetImage("images/imagemFundo2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 80, 60, 0),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/perfill.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Olá, seja bem-vindo",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 230),
                    child: Text(
                      "Clique na pizza para confirmar seu pedido!",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: _handleSubmit,
                        child: RotationTransition(
                          turns: _controller,
                          child: Image.asset(
                            "images/pizza.png",
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 288.7),
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.info_sharp, color: Colors.white),
                        onPressed: () {
                          // Ação para o botão de home
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.map, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaginaMaps(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          // Ação para o botão de perfil
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
