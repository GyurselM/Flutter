import 'dart:async';
//import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourGameWidget extends StatefulWidget {
  @override
  _YourGameWidgetState createState() => _YourGameWidgetState();
}

class _YourGameWidgetState extends State<YourGameWidget> {
  List<String> imagePaths = [
    'imagen/azul.jpg',
    'imagen/cars-2.jpg',
    'imagen/furgo.jpg',
    'imagen/gris.jpg',
  ];

  List<int> numbers = [0, 1, 2, 3];
  Random random = Random();
  List<int> shuffledNumbers = [];
  int currentIndex = 0;
  late Timer timer;
  List<int> playerSequence = [];
  int score = 0;
  String playerName = '';
  bool isSubmitDisabled = true;
  bool isShowScoreButtonVisible = false;
  bool isGameInitialized = false;

  List<String> localScores = [];

  List<ElevatedButton>? buttons;
  List<String> customButtonNames = ['Azul', 'Rojo', 'Verde', 'Gris'];

  @override
  void initState() {
    super.initState();
    // Iniciar el juego solo cuando se ha recogido el nombre del jugador
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isGameInitialized) {
        showNameInputDialog();
      }
    });
  }

  void initializeGame() {
    shuffledNumbers = List<int>.from(numbers)..shuffle(random);
    currentIndex = 0;
    playerSequence.clear();
    score = 0;
    isShowScoreButtonVisible = false;
    isGameInitialized = true; 
    
    // Marcar el juego como inicializado
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      showNextImage();
    });
  }

  void showNextImage() {
    if (currentIndex == shuffledNumbers.length) {
      timer.cancel();

      setState(() {
        buttons = List.generate(
          numbers.length,
          (index) => ElevatedButton(
            onPressed: () => onButtonTap(index),
            child: Text(customButtonNames[index]),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
          ),
        );

        isShowScoreButtonVisible = true;
      });

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        showButtons();
      });

      return;
    }

    setState(() {
      currentIndex++;
    });
  }

  void showButtons() {
    timer.cancel();

    setState(() {
      playerSequence.clear();
    });
  }

  void onButtonTap(int index) {
    setState(() {
      playerSequence.add(index);
      puntuation();

      // Llamar a la función para mostrar el botón de puntuación
      checkToShowScoreButton();
    });
  }

  void checkToShowScoreButton() {

    // Mostrar el botón de puntuación si el jugador ha completado la secuencia
    if (playerSequence.length == numbers.length) {
      setState(() {
        isShowScoreButtonVisible = true;
      });
    }
    
  }

  void puntuation() {
    if (shuffledNumbers.length != playerSequence.length) {
      return;
    }

    for (int i = 0; i < playerSequence.length; i++) {
      if (playerSequence[i] == shuffledNumbers[i]) {
        score += 10;
      } else {
        score -= 5;
      }
    }

    print("Puntuacion final: $score");

    // Guardar la puntuación localmente
    saveLocalScore(score);

    // Actualizar la lista de puntuaciones locales
    loadLocalScores();

  }

  void saveLocalScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList('local_scores') ?? [];
    String scoreStr = '$playerName: $score';
    scores.add(scoreStr);
    prefs.setStringList('local_scores', scores);
  }

  void loadLocalScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localScores = prefs.getStringList('local_scores') ?? [];
    localScores.sort((a, b) => extractScore(b).compareTo(extractScore(a)));
  }

  void showLocalScores() {
    loadLocalScores();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Puntuaciones Locales'),
          content: Column(
            children: localScores.map((score) => Text(score)).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  

  // Future<void> saveScore() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores'),
  //       headers: headers,
  //       body: json.encode({
  //         'name': 'Anton',
  //         'score': score,
  //       }),
  //     );


  //     if (response.statusCode == 201) {
  //       print('Puntuación guardada exitosamente en la API');
  //       showScores(); // Llamar a showScores después de guardar la puntuación
  //     } else {
  //       print('Error al guardar la puntuación en la API: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error al guardar la puntuación en la API: $e');
  //   }
  // }


  //  Future<void> showScores() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://qhavrvkhlbmsljgmbknr.supabase.co/rest/v1/scores?select=*'),
  //       headers: headers,
  //     );


  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       final dynamic responseBody = jsonDecode(response.body);


  //       if (responseBody != null && responseBody is List) {
  //         final List<Map<String, dynamic>> scoreList = responseBody.cast<Map<String, dynamic>>();


  //         final List<Map<String, dynamic>> sortedScoreList =
  //             scoreList.cast<Map<String, dynamic>>().toList();


  //         sortedScoreList.sort((a, b) => b['score'] - a['score']);


       
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Text('Puntuaciones'),
  //               content: Column(
  //                 children: sortedScoreList.map((gameData) {
  //                   return ListTile(
  //                     title: Text(gameData['name']),
  //                     subtitle: Text('Puntuación: ${gameData['score']}'),
  //                   );
  //                 }).toList(),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('Cerrar'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       } else {
  //         print('Error: La respuesta no es una lista o es nula');
  //       }
  //     } else {
  //       print('Error en la solicitud HTTP: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error al obtener puntuaciones: $e');
  //   }
  // }


  int extractScore(String scoreString) {
    List<String> parts = scoreString.split(':');
    return int.parse(parts.last.trim());
  }

  void showNameInputDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Introduce tu nombre'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  playerName = value;
                  isSubmitDisabled = value.isEmpty;
                });
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: isSubmitDisabled
                    ? null
                    : () {
                        Navigator.pop(context);
                        initializeGame();
                      },
                child: Text('Comenzar Juego'),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Juego de Memoria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentIndex < shuffledNumbers.length)
              Image(
                image: AssetImage(imagePaths[shuffledNumbers[currentIndex]]),
                width: 200,
                height: 200,
              ),
            if (currentIndex >= shuffledNumbers.length)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons ?? [],
              ),
            if (isShowScoreButtonVisible)
              ElevatedButton(
                onPressed: () {
                  //puntuation();
                  showLocalScores();
                },
                child: Text('Mostrar Puntuaciones'),
              ),
          ],
        ),
      ),
    );
  }
}

