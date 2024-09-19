
import 'package:flutter/material.dart';

import 'package:hangman_game/greenScreen.dart'; // Update with the correct import

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int _points = 0;

  void _incrementPoints(String category) {
    setState(() {
      _points += 10;
    });
  }

  void _navigateToGameScreen(BuildContext context, String category, String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => gameScreen1(
          category: category,
          level: level,
          onWin: () => _incrementPoints(category),
        ),
      ),
    );
  }

  Widget buildCategoryButton(BuildContext context, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            buildLevelButton(context, label: "Easy", onPressed: () => _navigateToGameScreen(context, category, "Easy")),
            SizedBox(width: 10),
            buildLevelButton(context, label: "Medium", onPressed: () => _navigateToGameScreen(context, category, "Medium")),
            SizedBox(width: 10),
            buildLevelButton(context, label: "Hard", onPressed: () => _navigateToGameScreen(context, category, "Hard")),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget buildLevelButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 223, 102, 21),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 223, 102, 21),
        title: Text("Play Screen"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 4),
                Text(
                  'Points: $_points',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/play.png"), // Ensure the image path is correct
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 400.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Category and Level',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),

                  buildCategoryButton(context, 'Animals'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




