import 'package:flutter/material.dart';
import 'componentes/jogo_da_velha.dart';

void main() {
  runApp(const Aplicativo());
}

/// Classe principal do aplicativo
class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    const String titulo = 'JOGO DA VELHA'; // Título do aplicativo
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: titulo,
      theme: ThemeData(
        // Define o tema principal do app, com uma paleta baseada em azul
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(180, 12, 147, 210)),
        useMaterial3: true,
      ),
      home: const TelaPrincipal(titulo: titulo), // Define a tela inicial
    );
  }
}

/// Tela principal do aplicativo
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, required this.titulo});

  final String titulo; // Título da tela

  @override
  State<TelaPrincipal> createState() => _EstadoTelaPrincipal();
}

/// Estado associado à tela principal
class _EstadoTelaPrincipal extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estrutura básica da tela
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Cor do AppBar
        title: Text(widget.titulo), // Exibe o título no AppBar
        centerTitle: true, // Centraliza o título
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribui os elementos verticalmente
          children: [
            // Layout superior (pode ser usado no futuro)
            Expanded(
              child: Container(
                alignment: Alignment.center,
                //child: const Text('Layout Superior'), // Exemplo comentado
              ),
            ),
            // Seção principal com o jogo
            Expanded(
              flex: 7, // Proporção maior para a seção do jogo
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuição horizontal
                children: [
                  Expanded(
                    child: Container(
                        //child: const Text('Primeira Coluna'), // Exemplo comentado
                        ),
                  ),
                  Expanded(
                    flex: 2, // Proporção maior para o jogo
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 12, 147, 210), // Azul claro
                        borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                        border: Border.all(
                          color: Colors.black, // Cor da borda
                          width: 1, // Largura da borda
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45, // Sombra
                            blurRadius: 10, // Intensidade do desfoque
                            offset: Offset(5, 5), // Posição da sombra
                          ),
                        ],
                      ),
                      child: const JogoDaVelha(), // Widget do jogo
                    ),
                  ),
                  Expanded(
                    child: Container(
                        //child: const Text('Terceira Coluna'), // Exemplo comentado
                        ),
                  ),
                ],
              ),
            ),
            // Layout inferior (pode ser usado no futuro)
            Expanded(
              flex: 1, // Proporção menor para a seção inferior
              child: Container(
                  //child: const Text('Layout Inferior'), // Exemplo comentado
                  ),
            ),
          ],
        ),
      ),
      // Botão flutuante de ação
      //floatingActionButton: FloatingActionButton(
      // onPressed: () {}, // Ação ao clicar no botão
      // tooltip: 'Adicionar', // Texto exibido ao passar o cursor
      //  child: const Icon(Icons.add), // Ícone do botão
      //),
    );
  }
}
