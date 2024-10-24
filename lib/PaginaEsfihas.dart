import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaDuvidas.dart';
import 'package:flutternexus/PaginaInicio.dart';

class PaginaEsfihas extends StatefulWidget {
  const PaginaEsfihas({Key? key}) : super(key: key);

  @override
  State<PaginaEsfihas> createState() => _PaginaEsfihasState();
}

class _PaginaEsfihasState extends State<PaginaEsfihas> {
  bool _Queijo = false;
  bool _Calabresa = false;
  bool _Morango = false;
  bool _Prestigo = false;
  bool _FrangoCatupiry = false;
  bool _Bacon = false;
  bool _PresuntoEQueijo = false;
  bool _Banana = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white), // Ícone de três pontos na cor branca
            color: Colors.white, // Cor do menu suspenso
            onSelected: (String result) {
              if (result == 'info') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaginaDuvidas()), // Navega para a página de dúvidas
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'info',
                child: Text('Mais informações'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      "images/Esfihas.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        "images/QuatroQueijos.jpg",
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza 4 Queijos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Gorgonzola, mussarela, parmesão, prato'),
                    ),
                  ),
                  Checkbox(
                    value: _Queijo,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Queijo = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        "images/calabresa.jpg",
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza Calabresa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Calabresa, queijo mussarela e orégano'),
                    ),
                  ),
                  Checkbox(
                    value: _Calabresa,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Calabresa = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/presuntoQueijo.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza Bauru',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Presunto, queijo mussarela e tomate'),
                    ),
                  ),
                  Checkbox(
                    value: _PresuntoEQueijo,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _PresuntoEQueijo = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/bacon.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza de Bacon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Bacon e queijo mussarela  '),
                    ),
                  ),
                  Checkbox(
                    value: _Bacon,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Bacon = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/frangoCatupiry.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza Caipira',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Frango, catupiry e milho'),
                    ),
                  ),
                  Checkbox(
                    value: _FrangoCatupiry,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _FrangoCatupiry = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/prestigio.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza de Prestigio',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Chocolate meio amargo e coco ralado'),
                    ),
                  ),
                  Checkbox(
                    value: _Prestigo,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Prestigo = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/morangoNutella.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza de Morango com nutella',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Morango e Nutella'),
                    ),
                  ),
                  Checkbox(
                    value: _Morango,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Morango = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 22)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        'images/banana.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pizza de Banana',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Banana, chantilly e canela'),
                    ),
                  ),
                  Checkbox(
                    value: _Banana,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Banana = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Column(
                children: [
                  Padding(padding:
                  EdgeInsets.only(right: 100, left: 100, bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaginaInicio(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirmar ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.check,
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
                    ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
