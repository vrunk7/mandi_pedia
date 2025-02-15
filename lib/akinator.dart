import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading assets
import 'package:outlined_text/outlined_text.dart';
import 'package:google_fonts/google_fonts.dart';

class Fruvenator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FruveNatorGame(),
    );
  }
}

class FruveNatorGame extends StatefulWidget {
  @override
  _FruveNatorGameState createState() => _FruveNatorGameState();
}

class _FruveNatorGameState extends State<FruveNatorGame> {
  bool isGameStarted = false;
  Map<String, dynamic> questionsData = {};
  String currentQuestionId = "Q1_FruitOrVegetable"; // First question
  String currentQuestion = "";
  Map<String, String> currentOptions = {};

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // Load JSON file
  Future<void> loadQuestions() async {
    String jsonString =
        await rootBundle.loadString('assets/fruit_veggie_akinator.json');
    final jsonData = json.decode(jsonString);

    setState(() {
      questionsData = {for (var q in jsonData['questions']) q['id']: q};
      updateQuestion(currentQuestionId);
    });
  }

  // Update question dynamically
  int questionCounter = 0; // Counter to track how many questions have been asked
List<String> questionImages = [
  'assets/ak2.png',
  'assets/ak3.png',
  'assets/ak4.png'
]; // List of images to cycle through
String currentImage = 'assets/ak2.png'; // Default image
String finalAnswerImage = 'assets/ak6.png'; // Fixed image for the answer

void updateQuestion(String nextId) {
  if (questionsData.containsKey(nextId)) {
    setState(() {
      currentQuestionId = nextId;
      currentQuestion = questionsData[nextId]['question'];
      currentOptions = Map<String, String>.from(questionsData[nextId]['options']);

      // Increment question counter
      questionCounter++;

      // Change image every two questions
      if (questionCounter % 2 == 0) {
        int imageIndex = (questionCounter ~/ 2) % questionImages.length;
        currentImage = questionImages[imageIndex];
      }
    });
  } else {
    // If the next step is an answer, display the result and set final image
    setState(() {
      currentQuestion = "I guess $nextId"; // Display final answer
      currentOptions = {}; // Clear options
      currentImage = finalAnswerImage; // Set fixed image for answer
    });
  }
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset("assets/ak1.jpeg", fit: BoxFit.cover),
          ),

          // Center Content
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: isGameStarted
                  ? buildGameScreen(screenWidth, screenHeight)
                  : buildStartScreen(screenWidth, screenHeight),
            ),
          ),

          // Freely Positioned Text Boxes (Only before game starts)
          if (!isGameStarted) ...[
            // Left Text Box
            Positioned(
              left: screenWidth * 0.01, // 5% from the left
              top: screenHeight * 0.29, // 35% from the top
              child: Container(
                width: screenWidth * 0.4, // 40% of screen width
                height: screenHeight * 0.05, // 7% of screen height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Hello, I am Fruvenator",
                    style: GoogleFonts.aladin(
                        fontSize: screenWidth * 0.04, color: Colors.black),
                  ),
                ),
              ),
            ),

            // Right Text Box
            Positioned(
              right: screenWidth * 0.01,
              top: screenHeight * 0.47,
              child: Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Text(
                      "Think about a fruit or vegetable. I will try to guess it",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aladin(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        wordSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Start Screen
  Widget buildStartScreen(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("defi.webp", height: screenHeight * 0.37),
        SizedBox(height: screenHeight * 0.02), // Responsive Genie Image
        OutlinedText(
          text: Text(
            'fruvenator',
            style: TextStyle(
              fontFamily: 'Minangkabau',
              fontSize: screenWidth * 0.14, // Adjusts with screen width
              fontWeight: FontWeight.bold,
              letterSpacing: 6.5,
              color: Colors.amber,
            ),
          ),
          strokes: [
            OutlinedTextStroke(color: Colors.black, width: 6),
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        TextButton(
          onPressed: () {
            setState(() {
              isGameStarted = true;
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          ),
          child: Text(
            "Play",
            style: GoogleFonts.luckiestGuy(
              // Use Google Fonts
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.blueAccent,
                  offset: Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 12.0,
                  color: Colors.blue.withOpacity(0.6),
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Game Screen
  Widget buildGameScreen(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
  currentImage,  // Dynamic image
  key: ValueKey(currentImage), // Forces image refresh
  height: screenHeight * 0.3,  // Keep it responsive
), // Responsive Genie Image
        Container(
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // Rounded edges
            border:
                Border.all(color: Colors.blueAccent, width: 4), // Outer border
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Text(
            currentQuestion,
            textAlign: TextAlign.center,
            style: GoogleFonts.luckiestGuy(
              fontSize:
                  MediaQuery.of(context).size.width * 0.05, // Responsive font
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),

        ...currentOptions.entries
            .map((option) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      updateQuestion(option.value);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor:
                          Colors.orangeAccent, // Akinator's theme color
                      shadowColor: Colors.redAccent,
                      elevation: 8,
                    ),
                    child: Text(
                      option.key,
                      style: GoogleFonts.luckiestGuy(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                              blurRadius: 6.0,
                              color: Colors.black38,
                              offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList()
      ],
    );
  }
}