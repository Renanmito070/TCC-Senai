import 'package:flutter/material.dart';
import 'package:flutternexus/PaginaInicio.dart';

class PaginaDuvidas extends StatefulWidget {
  const PaginaDuvidas({super.key});

  @override
  State<PaginaDuvidas> createState() => _PaginaDuvidasState();
}

class _PaginaDuvidasState extends State<PaginaDuvidas> {
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
                builder: (context) => PaginaInicio(),
              ),
            );
          },
        ),
        backgroundColor: Colors.black, // Cor da AppBar
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/fundo.png"), // Caminho para sua imagem de fundo
                fit: BoxFit.cover, // Faz a imagem cobrir
              ),
            ),
          ),
          // Conteúdo da página
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Espaço nas laterais
                  child: buildCard("O que é o ciclo da violência? Como posso quebrar-lo?", "O ciclo da violência é um padrão repetitivo que ocorre em relacionamentos abusivos, geralmente dividido em três fases: Tensão: Pequenas tensões e conflitos se acumulam. Explosão: O abuso físico, emocional ou verbal ocorre. Lua de mel: O agressor pede desculpas, promete mudar e o relacionamento parece melhorar temporariamente. Para quebrar esse ciclo, é essencial reconhecer os sinais de abuso e buscar apoio. Desenvolva um plano de segurança, converse com amigos ou familiares de confiança e considere a ajuda de profissionais, como terapeutas ou grupos de apoio. A conscientização sobre o ciclo é um primeiro passo crucial para sair dele."),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildCard("O que fazer se eu não me sentir pronta para denunciar?", "Se você não se sentir pronta para denunciar, não há problema. É importante respeitar seu próprio tempo e conforto. Busque apoio emocional de pessoas de confiança, como amigos, familiares ou grupos de apoio. Você também pode considerar falar com um terapeuta, que pode ajudá-la a processar suas experiências e explorar suas opções. Lembre-se de que você sempre pode tomar essa decisão no seu próprio ritmo e que existem recursos disponíveis para ajudá-la."),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildCard("Preciso de um advogado para conseguir a medida protetiva?", "Embora não seja estritamente necessário ter um advogado para solicitar uma medida protetiva, ter um profissional pode facilitar o processo. Um advogado pode orientar você sobre como coletar as evidências necessárias, preencher a documentação e entender os seus direitos legais. Se você não puder pagar por um advogado, procure serviços de assistência jurídica gratuita ou organizações que oferecem suporte a vítimas de abuso, pois muitas vezes têm profissionais que podem ajudar nesse processo."),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildCard("Minha cidade não tem uma delegacia da mulher, posso ir a uma delegacia convencional?", "Sim, você pode ir a uma delegacia convencional se não houver uma delegacia da mulher em sua cidade. As delegacias comuns também são responsáveis por registrar denúncias de abuso e violência doméstica. Ao chegar, explique a situação e solicite assistência. Se possível, leve consigo documentos ou evidências que ajudem a esclarecer sua situação. Não hesite em buscar ajuda, independentemente de onde você for."),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildCard("O que fazer se eu não me sentir pronta para denunciar?", "É completamente normal não se sentir pronta para denunciar um abusador, e cada pessoa tem seu próprio ritmo. O mais importante é priorizar sua segurança e bem-estar. Considere buscar apoio de amigos de confiança, familiares ou grupos de apoio, onde você pode compartilhar suas experiências sem pressão. Você pode também falar com um terapeuta que compreenda seu contexto e ajude a explorar suas opções. Lembre-se de que a decisão de denunciar deve ser sua, e você pode buscar ajuda e recursos no seu próprio tempo, sem pressa."),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: buildCard("Quais são as linhas de apoio?", "As linhas de apoio são serviços que oferecem assistência emocional, informação e orientação a pessoas em situação de abuso ou violência. Aqui estão alguns tipos comuns de linhas de apoio: Ligue 180 - Central de Atendimento à Mulher: Oferece apoio e orientação sobre violência contra a mulher, disponível 24 horas. Disque Denúncia - 190: Para denúncias de violência ou emergências em geral, incluindo violência doméstica."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para criar o card expansível
  Widget buildCard(String title, String content) {
    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Color(0xFFF5F5DC),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        trailing: Icon(Icons.keyboard_arrow_down), // Ícone da seta para baixo
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}