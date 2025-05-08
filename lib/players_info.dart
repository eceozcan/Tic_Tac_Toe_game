import 'package:flutter/material.dart';
import 'game_panel.dart';

class PlayersInfoPage extends StatefulWidget {
  const PlayersInfoPage({super.key});

  @override
  State<PlayersInfoPage> createState() => _PlayersInfoPageState();
}

class _PlayersInfoPageState extends State<PlayersInfoPage> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  List<Map<String, dynamic>> heroes = [];

  void _swapNames() {
    String temp = player1Controller.text;
    setState(() {
      player1Controller.text = player2Controller.text;
      player2Controller.text = temp;
    });
  }

  void _addHero(String name, String symbol, int score) {
    setState(() {
      heroes.add({
        'name': name,
        'symbol': symbol,
        'score': score,
      });
    });
  }

  void _navigateToGame() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          player1Name: player1Controller.text.isEmpty
              ? "Player 1"
              : player1Controller.text,
          player2Name: player2Controller.text.isEmpty
              ? "Player 2"
              : player2Controller.text,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      _addHero(result['name'], result['symbol'], result['score']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6f3dc),
      appBar: AppBar(
        title: const Text('Players Panel'),
        elevation: 4,
        leading: const BackButton(),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            const Divider(thickness: 1.5),
            const SizedBox(height: 5),
            _playerInput(player1Controller, 'Player 1', Colors.blue),
            const SizedBox(height: 8),

            GestureDetector(
              onTap: _swapNames,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.keyboard_arrow_up, size: 40, color: Colors.black),
                  Text('|', style: TextStyle(fontSize: 55, color: Colors.black, height: -0.1)),
                  Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.black),
                ],
              ),
            ),

            const SizedBox(height: 2),
            _playerInput(player2Controller, 'Player 2', Colors.red),
            const SizedBox(height: 15),
            const Divider(thickness: 1.5),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Heroes List:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'serif',
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: heroes.isEmpty
                  ? const Center(child: Text(''))
                  : ListView.builder(
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  final hero = heroes[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      setState(() {
                        heroes.removeAt(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: hero['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18),
                                      ),
                                      const TextSpan(text: '\n'),
                                      TextSpan(
                                        text: hero['symbol'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${hero['score']}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF4B014B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
         
        ),
        child: FloatingActionButton(
          onPressed: _navigateToGame,
          backgroundColor: Colors.green,
          elevation: 0,
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget _playerInput(TextEditingController controller, String hint, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 50,
            offset: Offset(0, 2),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Colors.black26, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 26),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
                Container(
                  height: 2.3,
                  width: double.infinity,
                  color: Colors.black26,
                ),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
