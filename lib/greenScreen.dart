

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hangman_game/const.dart';
import 'package:hangman_game/figure.dart';
import 'package:hangman_game/hidden_letter.dart';
import 'package:hangman_game/main.dart';
import 'package:hangman_game/playscreen.dart';

class gameScreen1 extends StatefulWidget {
  final String category;
  final String level;
  final VoidCallback onWin;

  const gameScreen1({
    Key? key,
    required this.category,
    required this.level,
    required this.onWin,
  }) : super(key: key);

  @override
  State<gameScreen1> createState() => _gameScreen1State();
}

class _gameScreen1State extends State<gameScreen1> {
  final String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  late String word;
  List<String> selectedchar = [];
  int tries = 0;
  int hintCount = 0;
  final int maxHints = 2;

  @override
  void initState() {
    super.initState();
    word = getRandomWord();
  }

  String getRandomWord() {
    Map<String, Map<String, List<String>>> wordBank = {
      'Animals': {
        'Easy': ['LION', 'FROG', 'BEAR'],
        'Medium': ['TIGER', 'HYENA', 'HORSE'],
        'Hard': ['ZEBRAS', 'CAMELS', 'OTTERS'],
      },
    };

    final random = Random();
    List<String> words = wordBank[widget.category]?[widget.level] ?? ['DEFAULT'];
    return words[random.nextInt(words.length)];
  }

  void giveHint() {
    if (hintCount < maxHints) {
      List<String> remainingChars = word.split('').where((char) => !selectedchar.contains(char)).toList();
      if (remainingChars.isNotEmpty) {
        final random = Random();
        String hintChar = remainingChars[random.nextInt(remainingChars.length)];
        setState(() {
          selectedchar.add(hintChar);
          hintCount++;
        });
      }
    }
  }

  void _handleGuess(String guess) {
    setState(() {
      selectedchar.add(guess);
      if (!word.split('').contains(guess)) {
        tries++;
      }

      if (tries == 6) {
        _showLoseDialog();
      } else if (word.split('').every((char) => selectedchar.contains(char))) {
        _showWinDialog();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color.fromARGB(41, 0, 90, 86),
        content: Container(
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "You Win",
                style: TextStyle(
                  fontFamily: "PatrickHand",
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 25,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _goToNextLevel(); // Progress to the next level
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.grey.shade500,
        content: Container(
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Your Guess is Wrong",
                style: TextStyle(
                  fontFamily: "PatrickHand",
                  color: Colors.red,
                  fontSize: 25,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(), // Replace with the appropriate screen
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextLevel() {
    if (widget.level == 'Easy') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => gameScreen1(
            category: widget.category,
            level: 'Medium',
            onWin: widget.onWin,
          ),
        ),
      );
    } else if (widget.level == 'Medium') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => gameScreen1(
            category: widget.category,
            level: 'Hard',
            onWin: widget.onWin,
          ),
        ),
      );
    } else if (widget.level == 'Hard') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PlayScreen(), // Replace with the appropriate PlayScreen
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 223, 102, 21), // Set the AppBar color to orange
        title: Text("${widget.level} LEVEL"),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.lightbulb_outline),
                onPressed: hintCount < maxHints ? giveHint : null,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  '${maxHints - hintCount} Hints Left',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"), // Ensure the image path is correct
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      widget.category, // Display the selected category
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8), // Adds some space between the text and the icon
                    Icon(
                      _getCategoryIcon(widget.category), // Display category icon
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        figure(GameUi.hang, tries >= 0),
                        figure(GameUi.head, tries >= 1),
                        figure(GameUi.body, tries >= 2),
                        figure(GameUi.l_arm, tries >= 3),
                        figure(GameUi.r_arm, tries >= 4),
                        figure(GameUi.l_leg, tries >= 5),
                        figure(GameUi.r_leg, tries >= 6),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: word
                            .split("")
                            .map(
                              (e) => hiddenLetter(e, !selectedchar.contains(e.toUpperCase())),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 7,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  children: characters.split('').map((e) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 223, 102, 21),
                      ),
                      onPressed: selectedchar.contains(e.toUpperCase())
                          ? null
                          : () => _handleGuess(e.toUpperCase()), // Handle button press
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Animals':
        return Icons.pets;
      default:
        return Icons.help_outline;
    }
  }
}

