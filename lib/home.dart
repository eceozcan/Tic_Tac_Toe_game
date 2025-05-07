import 'package:flutter/material.dart';
import 'players_info.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: const Color(0xffecf7dc),
      body: Column(
        children: [
          // Üst bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.lightGreen,
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Welcome to TTT',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Daha büyük görsel: 420px (son ayar)
          SizedBox(
            width: double.infinity,
            height: 420,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.contain,
            ),
          ),

          // Turuncu buton - üstüne yapışık gibi duracak
          Transform.translate(
            offset: const Offset(0, -20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(24),
              ),
              child: const Text(
                "V 1.0",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Continue >>
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersInfoPage(),
                  ),
                );
              },
              child: const Text(
                'Continue >>',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
