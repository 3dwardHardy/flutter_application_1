import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // MyApp constructor taking an option Key parameter
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title of app
      title: 'Tic-Tac-Toe',
      //hides debug banner
      debugShowCheckedModeBanner: false,
      //Sets the theme of the app to white canvas
      theme: ThemeData(canvasColor: Colors.white),
      //Sets the home screen to the Gamepage
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  // Key property for the widget
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Constants for player names
  // ignore: constant_identifier_names
  static const String Player_1 = "X";
  // ignore: constant_identifier_names
  static const String Player_2 = "O";
  //Variables to store the current player, game end status, and occupied spaces
  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    // Call the initialize Game function on initializing the state
    initializeGame();
    super.initState();
  }

  //Function to initialize the game state
  void initializeGame() {
    // Set the first player to be player 1
    currentPlayer = Player_1;
    // Set the game end status to false
    gameEnd = false;
    // Initialize the occupied spaces as empty
    occupied = [
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    ]; //16 empty places
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Main body of the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Call to the _headerText function
            _headerText(),
            // Call to the _gameContainer function
            _gameContainer(),
            // Call to the _restartButton function
            _restartButton(),
          ],
        ),
      ),
    );
  }

  // Function to return the header text widget
  Widget _headerText() {
    return Column(
      children: [
        // The title of the game
        const Text(
          "Tic Tac Toe",
          style: TextStyle(
            color: Color(0xFF311B92),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ), // Text showing the current player's turn
        Text(
          "Player $currentPlayer's turn",
          style: const TextStyle(
            color: Color(0xFF311B92),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    // Return a container that is half the height and width of the screen
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      // Add a margin of 8 on all sides
      margin: const EdgeInsets.all(8),
      // The child is a gridview with a fixed cross axis count of 4
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          // The number of items in the grid is 16
          itemCount: 16,
          // The item builder function returns a "box" for each index
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  // Returns a single "box" for the given index
  Widget _box(int index) {
    // Returns an Inkwell widget that is tappable
    return InkWell(
      onTap: () {
        // If the game has ended or the box is already occupied, return
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }
        // Update the state of the game by marking the box as occupied, changing turns and checking for a winner or draw

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      // The child is a container with a fixed color and margin
      child: Container(
        color: const Color(0xFF311B92),
        margin: const EdgeInsets.all(8),
        // The child of the container is a center widget with a text widget
        child: Center(
          child: Text(
            occupied[index],
            // The text is white with a font size of 50
            style: const TextStyle(fontSize: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Returns a button to restart the game
  _restartButton() {
    return ElevatedButton(
        // When pressed, the game
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Restart Game"));
  }

  changeTurn() {
    if (currentPlayer == Player_1) {
      currentPlayer = Player_2;
    } else {
      currentPlayer = Player_1;
    }
  }

  checkForWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [1, 2, 3],
      [4, 5, 6],
      [5, 6, 7],
      [8, 9, 10],
      [9, 10, 11],
      [12, 13, 14],
      [13, 14, 15],
      [0, 4, 8],
      [4, 8, 12],
      [1, 5, 9],
      [5, 9, 13],
      [2, 6, 10],
      [6, 10, 14],
      [3, 7, 11],
      [7, 11, 15],
      [0, 5, 10],
      [5, 10, 15],
      [3, 6, 9],
      [6, 9, 12],
      [1, 6, 11],
      [2, 5, 8],
      [4, 9, 14],
      [7, 10, 13]
    ];

    for (var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  checkForDraw() {
    if (gameEnd) {
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }

    if (draw) {
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Game Over \n $message",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ))),
    );
  }
}
