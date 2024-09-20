import 'package:flutter/material.dart';
import 'package:flutternexus/TelaInicio.dart';

class Medidaprotetiva extends StatefulWidget {
  const Medidaprotetiva({super.key});

  @override
  State<Medidaprotetiva> createState() => _MedidaprotetivaState();
}

class _MedidaprotetivaState extends State<Medidaprotetiva> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white, // Cor da seta de voltar
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaInicial("", ""),
              ),
            );
          },
        ),
        backgroundColor: Colors.black, // Cor da AppBar
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'images/fundo.png', // Substitua pelo caminho da sua imagem
              fit: BoxFit.cover, // Ajusta a imagem ao tamanho da tela
            ),
          ),
          // Conteúdo sobreposto (cards)
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 50)),
                Padding(
                  padding: EdgeInsets.all(44.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Alinhamento inicial
                    children: [
                      buildCard1(),
                      buildCard2(),
                      buildCard3(),
                      buildCard4(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para criar o primeiro card
  Widget buildCard1() {
    return buildCard(1, "A vítima dirige-se à delegacia, registra o boletim de ocorrência relatando os fatos e informa o desejo de solicitar uma medida protetiva.");
  }

  // Método para criar o segundo card
  Widget buildCard2() {
    return buildCard(2, "A vítima preenche o formulário de solicitação da medida protetiva, detalhando as razões e indicando as medidas necessárias para sua proteção.");
  }

  // Método para criar o terceiro card
  Widget buildCard3() {
    return buildCard(3, "O(A) juiz(a) irá avaliar o caso e julgar as medidas necessárias para assegurar a proteção da vítima.");
  }

  // Método para criar o quarto card
  Widget buildCard4() {
    return buildCard(4, "A Patrulha Maria da Penha entra em contato com a vítima para fornecer apoio e acompanhamento contínuo, garantindo a efetivação da medida protetiva concedida.");
  }

  // Método comum para criar os cards com número e texto
  Widget buildCard(int number, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 50.0), // Reduz o espaço entre os cards
      width: 400, // Define a largura dos cards (ajustável)
      height: 160, // Define uma altura fixa para o card (ajustável)
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Colors.grey.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.brown,
                child: Text(
                  '$number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 16), // Espaço entre o círculo e o texto
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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