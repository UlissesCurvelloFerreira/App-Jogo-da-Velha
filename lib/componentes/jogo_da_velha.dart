import 'dart:math';
import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  const JogoDaVelha({super.key});

  @override
  State<JogoDaVelha> createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  // Lista que representa o tabuleiro (9 espaços), inicializada como vazia
  List<String> _tabuleiro = List.filled(9, '');

  // Jogador atual: 'X' começa o jogo
  String _jogadorAtual = 'X';

  // Variável que indica se o jogador está jogando contra a máquina
  bool _jogarContraMaquina = false;

  // Gerador aleatório usado para a jogada da máquina
  final Random _geradorAleatorio = Random();

  // Variável que indica se a máquina está "pensando" na jogada
  bool _isPensando = false;

  // Função para iniciar um novo jogo
  void _iniciarJogo() {
    setState(() {
      // Limpa o tabuleiro e reseta o jogador para 'X'
      _tabuleiro = List.filled(9, '');
      _jogadorAtual = 'X';
    });
  }

  // Alterna entre os jogadores X e O
  void _alternarJogador() {
    setState(() {
      _jogadorAtual = _jogadorAtual == 'X' ? 'O' : 'X';
    });
  }

  // Exibe um diálogo indicando o vencedor ou empate
  void _mostrarDialogoVencedor(String vencedor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Exibe o resultado: vencedor ou empate
          title: Text(vencedor == 'Empate' ? 'Empate!' : 'Vencedor: $vencedor'),
          actions: [
            ElevatedButton(
              child: const Text('Reiniciar Jogo'),
              onPressed: () {
                Navigator.of(context).pop();
                _iniciarJogo(); // Reinicia o jogo
              },
            ),
          ],
        );
      },
    );
  }

  // Função que verifica se um jogador venceu ou se houve empate
  bool _verificarVencedor(String jogador) {
    const posicoesVencedoras = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6], // Diagonais
    ];

    // Verifica as posições vencedoras
    for (var posicoes in posicoesVencedoras) {
      if (_tabuleiro[posicoes[0]] == jogador &&
          _tabuleiro[posicoes[1]] == jogador &&
          _tabuleiro[posicoes[2]] == jogador) {
        _mostrarDialogoVencedor(jogador); // Exibe o vencedor
        return true;
      }
    }

    // Verifica se houve empate (nenhum espaço vazio)
    if (!_tabuleiro.contains('')) {
      _mostrarDialogoVencedor('Empate');
      return true;
    }
    return false;
  }

  // Função que simula a jogada da máquina
  void _jogadaComputador() {
    setState(() => _isPensando = true); // Indica que a máquina está "pensando"
    Future.delayed(const Duration(seconds: 1), () {
      int movimento;
      // Gera um movimento aleatório até encontrar uma posição vazia
      do {
        movimento = _geradorAleatorio.nextInt(9);
      } while (_tabuleiro[movimento] != '');
      setState(() {
        // A máquina faz a jogada
        _tabuleiro[movimento] = 'O';
        // Verifica se a máquina ganhou após a jogada
        if (!_verificarVencedor(_jogadorAtual)) {
          _alternarJogador(); // Alterna para o próximo jogador
        }
        _isPensando = false; // Máquina terminou de "pensar"
      });
    });
  }

  // Função chamada quando um jogador faz uma jogada
  void _jogada(int index) {
    // Se a célula estiver vazia, faz a jogada
    if (_tabuleiro[index] == '') {
      setState(() {
        _tabuleiro[index] = _jogadorAtual; // Marca a jogada no tabuleiro
        // Verifica se o jogador ganhou após a jogada
        if (!_verificarVencedor(_jogadorAtual)) {
          _alternarJogador(); // Alterna para o outro jogador
          // Se for contra a máquina, a máquina joga após o humano
          if (_jogarContraMaquina && _jogadorAtual == 'O') {
            _jogadaComputador(); // Máquina faz a jogada
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height * 0.5; // Altura do tabuleiro
    return Column(
      children: [
        // Controle do modo contra a máquina
        Expanded(
          child: Row(
            children: [
              Transform.scale(
                scale: 0.6, // Ajusta o tamanho do Switch
                child: Switch(
                  value: _jogarContraMaquina,
                  onChanged: (value) {
                    setState(() {
                      _jogarContraMaquina = value; // Ativa ou desativa o modo contra a máquina
                      _iniciarJogo(); // Reinicia o jogo quando o modo é alterado
                    });
                  },
                ),
              ),
              Text(_jogarContraMaquina ? 'Computador' : 'Humano'),
              const SizedBox(width: 30.0),
              // Exibe um indicador enquanto a máquina está "pensando"
              if (_isPensando)
                const SizedBox(
                  height: 15.0,
                  width: 15.0,
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        // Exibe o tabuleiro de jogo
        Expanded(
          flex: 8,
          child: SizedBox(
            width: altura,
            height: altura,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 colunas
                crossAxisSpacing: 5.0, // Espaçamento entre colunas
                mainAxisSpacing: 5.0, // Espaçamento entre linhas
              ),
              itemCount: 9, // 9 células no tabuleiro
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _jogada(index), // Chama a função de jogada ao clicar
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(208, 100, 95, 194), // Cor azul clara
                      borderRadius: BorderRadius.circular(5), // Bordas arredondadas
                    ),
                    child: Center(
                      child: Text(
                        _tabuleiro[index], // Exibe o símbolo 'X' ou 'O'
                        style: const TextStyle(fontSize: 40.0), // Tamanho da fonte
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Botão para reiniciar o jogo
        Expanded(
          child: ElevatedButton(
            onPressed: _iniciarJogo, // Reinicia o jogo
            child: const Text('Reiniciar o Jogo'),
          ),
        ),
      ],
    );
  }
}
