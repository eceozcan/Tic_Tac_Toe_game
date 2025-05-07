import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  const GamePage({
    super.key,
    required this.player1Name,
    required this.player2Name,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  int player1Score = 0;
  int player2Score = 0;
  int round = 1;

  void _handleTap(int index) {
    if (board[index] != '') return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
    });

    _checkWinner();
  }

  void _checkWinner() {
    const winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      final a = board[condition[0]];
      final b = board[condition[1]];
      final c = board[condition[2]];
      if (a != '' && a == b && b == c) {
        _showWinnerDialog(a);
        return;
      }
    }

    if (!board.contains('')) {
      _showDrawDialog();
    }
  }

  void _showWinnerDialog(String winnerSymbol) {
    String winnerName = winnerSymbol == 'X' ? widget.player1Name : widget.player2Name;

    setState(() {
      if (winnerSymbol == 'X') {
        player1Score += 3;
        isXTurn = true;
      } else {
        player2Score += 3;
        isXTurn = false;
      }
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Congratulations !!!"),
        content: Text(
              '$winnerName won (+3 points)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextRound();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showDrawDialog() {
    setState(() {
      player1Score += 1;
      player2Score += 1;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Draw"),
        content: const Text(
          "One point for each player.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextRound();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _nextRound() {
    setState(() {
      board = List.filled(9, '');
      round++;
    });
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      player1Score = 0;
      player2Score = 0;
      round = 1;
      isXTurn = true;
    });
  }

  void _exitGame() {
    String winnerName = '';
    String winnerSymbol = '';
    int winnerScore = 0;

    if (player1Score > player2Score) {
      winnerName = widget.player1Name;
      winnerSymbol = 'X';
      winnerScore = player1Score;
    } else if (player2Score > player1Score) {
      winnerName = widget.player2Name;
      winnerSymbol = 'O';
      winnerScore = player2Score;
    }

    Navigator.pop(context, {
      'name': winnerName,
      'symbol': winnerSymbol,
      'score': winnerScore,
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentPlayer = isXTurn ? widget.player1Name : widget.player2Name;
    String currentSymbol = isXTurn ? 'X' : 'O';
    Color currentColor = isXTurn ? Colors.blue : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xffe6f3dc),
      appBar: AppBar(
        title: const Text("Game Panel"),
        leading: const BackButton(),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  '${widget.player1Name} Score: $player1Score',
                  style: const TextStyle(fontSize: 25, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2.8),
                Text(
                  '${widget.player2Name} Score: $player2Score',
                  style: const TextStyle(fontSize: 25, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(thickness: 1),
            Text(
              'Round: $round',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft, // ✅ Sola hizalama
              child: RichText(
                text: TextSpan(
                  text: 'Turn: ',
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                  children: [
                    TextSpan(
                      text: '$currentPlayer ($currentSymbol)',
                      style: TextStyle(
                        color: currentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(
                            fontSize: 90,
                            fontWeight: FontWeight.bold,
                            color: board[index] == 'X' ? Colors.blue : Colors.red,
                          ),
                        ),
                      ),
                    ),

                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text("Are you sure to exit?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _exitGame();
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Exit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
