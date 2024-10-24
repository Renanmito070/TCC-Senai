import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaInicio.dart';
import 'package:flutternexus/PaginaMedidaProtetiva.dart';

class PaginaBebidas extends StatefulWidget {
  const PaginaBebidas({Key? key}) : super(key: key);

  @override
  State<PaginaBebidas> createState() => _PaginaBebidasState();
}

class _PaginaBebidasState extends State<PaginaBebidas> {

  bool _Coca = false;
  bool _FantaLaranja = false;
  bool _FantaUva = false;
  bool _Itubaina = false;
  bool _Sprite = false;
  bool _Guarana = false;
  bool _Pepsi = false;
  bool _PepsiBlack = false;
  bool _SucoLaranja = false;
  bool _SucoUva = false;
  bool _SucoMaracuja = false;


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
                  MaterialPageRoute(builder: (context) => PaginaMedidaprotetiva()), // Navega para a página de dúvidas
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
                        "images/BannerBebidas.jpg",
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
                        "images/coca.jpg",
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Coca',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('A clássica e refrescante Coca-Cola'),
                    ),
                  ),
                  Checkbox(
                    value: _Coca,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Coca = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Image.asset(
                        "images/fantaLaranja.jpg",
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Fanta Laranja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Uma explosão de sabor cítrico!'),
                    ),
                  ),
                  Checkbox(
                    value: _FantaLaranja,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _FantaLaranja = newValue ?? false;
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
                        'images/fantaUva.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Fanta uva',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Refresque-se com o delicioso e doce sabor de uvas'),
                    ),
                  ),
                  Checkbox(
                    value: _FantaUva,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _FantaUva = newValue ?? false;
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
                        'images/guarana.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Guaraná Antártica',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('O autêntico sabor brasileiro!'),
                    ),
                  ),
                  Checkbox(
                    value: _Guarana,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Guarana = newValue ?? false;
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
                        'images/Itubaina.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Itubaina',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('A Itubaína combina sabor clássico e doçura suave'),
                    ),
                  ),
                  Checkbox(
                    value: _Itubaina,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Itubaina = newValue ?? false;
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
                        'images/pepsi.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pepsi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Acompanhe suas refeições com a irresistível Pepsi'),
                    ),
                  ),
                  Checkbox(
                    value: _Pepsi,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Pepsi = newValue ?? false;
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
                        'images/pepsiBlack.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Pepsi Black',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('A versão zero açúcar da Pepsi com muito sabor'),
                    ),
                  ),
                  Checkbox(
                    value: _PepsiBlack,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _PepsiBlack = newValue ?? false;
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
                        'images/sprite.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Sprite',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Uma bebida refrescante e leve, sabor limão'),
                    ),
                  ),
                  Checkbox(
                    value: _Sprite,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _Sprite = newValue ?? false;
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
                        'images/laranja.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Suco de Laranja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Feito com laranjas frescas, este suco traz um equilíbrio perfeito entre doçura e acidez'),
                    ),
                  ),
                  Checkbox(
                    value: _SucoLaranja,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _SucoLaranja = newValue ?? false;
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
                        'images/uva.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Suco de Uva',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text('Natural e delicioso, o suco de uva oferece um sabor doce e intenso'),
                    ),
                  ),
                  Checkbox(
                    value: _SucoUva,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _SucoUva = newValue ?? false;
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
                        'images/maracuja.jpg',
                        height: 100,
                        width: 60,
                      ),
                      title: Text(
                        'Suco de Maracujá',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,  // Texto em negrito
                        ),
                      ),
                      subtitle: Text(' O suco de maracujá combina o toque tropical e cítrico dessa fruta'),
                    ),
                  ),
                  Checkbox(
                    value: _SucoMaracuja,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _SucoMaracuja = newValue ?? false;
                      });
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
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
