import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaBebidas.dart';
import 'package:flutternexus/PaginaCadastro.dart';
import 'package:flutternexus/PaginaDuvidas.dart';
import 'package:flutternexus/PaginaEsfihas.dart';
import 'package:flutternexus/PaginaMedidaProtetiva.dart';
import 'package:flutternexus/PaginaGuardiao.dart';
import 'package:flutternexus/PaginaMaps.dart';
import 'package:flutternexus/PaginaUsuario.dart';
import 'package:flutternexus/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class PaginaInicio extends StatefulWidget {

  String? guardiaoEmail2;

  PaginaInicio([this.guardiaoEmail2]);

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> with SingleTickerProviderStateMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _address = '';
  late AnimationController _controller;
  final String botToken = '7540693977:AAG3Tf0mjzMIHMpUtaFjK3l3TCM3d4knuOI';
  final List<String> chatIds = ['6727844526', '5475743506', "6022440283"];
  String? guardiaoEmail;
  String? nomeUsuario;

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
  Future<void> obterGuardioes() async {
    try {
      await pegarIdDoArquivoUsuario();
      print("Entrou no metodo");
      print(usuarioId);
      // Obtém todos os documentos da subcoleção 'guardioes' dentro do documento de 'usuarios'
      QuerySnapshot querySnapshot = await firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('guardioes')
          .get();

      // Verifica se existem documentos na subcoleção
      print(querySnapshot.docs.isNotEmpty);
      if (querySnapshot.docs.isNotEmpty) {
        print("Entrou");
        // Itera sobre os documentos retornados
        querySnapshot.docs.forEach((doc) {
          final dadosGuardiao = doc.data() as Map<String, dynamic>;
          print("Existe documento");
          setState(() {
            guardiaoEmail = dadosGuardiao['email']; // Por exemplo, acessa o campo 'email'
          });
          print('Email do Guardião: ${dadosGuardiao['email']}');
        });
        await _handleSubmit();
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
  @override
  void initState() {
    super.initState();
    obterNomeUsuario();
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
          'message': "$nomeUsuario esta em perigo nesta localidade: $_address",
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

    try {
      if (_address.isEmpty) {
        print('Obtendo endereço...');
        await _determinePosition();
      }
      if (_address.isNotEmpty) {
        final String url = 'https://api.telegram.org/bot$botToken/sendMessage';
        final String message = 'Peço que você entre em contato com ${nomeUsuario} o mais rápido possível para verificar se ela está bem. Por favor, se dirija ao local onde ela se encontra ou entre em contato com as autoridades locais para garantir que ela receba a ajuda necessária. $_address';

        if(guardiaoEmail == null){
          await _sendEmail(widget.guardiaoEmail2!);
        } else {
          await _sendEmail(guardiaoEmail!);
        }

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
              image: AssetImage("images/fundFoto.png"),
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
                    padding: EdgeInsets.fromLTRB(40, 65.5, 60, 0),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/perfill.png",
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Olá, ${nomeUsuario} bem-vindo",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 115),
                      child: GestureDetector(
                        onTap: () {
                          if(widget.guardiaoEmail2 != null){
                            print(widget.guardiaoEmail2);
                            _handleSubmit();
                          }else if(guardiaoId != null){
                            obterGuardioes();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaginaGuardiao(),
                              ),
                            );
                          }
                        },
                        child: RotationTransition(
                          turns: _controller,
                          child: Image.asset(
                            "images/pizza.png",
                            height: 310,
                            width: 310,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                      'Clique na pizza para confirma seu pedido!',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaBebidas(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "images/bebida.png",
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaginaEsfihas(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "images/comida.png",
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
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
