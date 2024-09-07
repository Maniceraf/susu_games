import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:susu_games/pages/home.dart';
import 'package:susu_games/pages/memory_pattern/widgets/count_down_dialog.dart';
import 'package:susu_games/widgets/alert.dart';
import 'package:susu_games/widgets/constant.dart';
import 'package:susu_games/widgets/dialog_button.dart';

class MemoryPatternPage extends StatefulWidget {
  const MemoryPatternPage({super.key});

  @override
  State<MemoryPatternPage> createState() => MemoryPatternPageState();
}

class MemoryPatternPageState extends State<MemoryPatternPage> {
  int gridSize = 3;
  List<List<bool>> _pattern = [];
  List<List<bool>> _userPattern = [];
  bool _showingPattern = true;
  bool _gameOver = false;
  int _timeLeft = 10;
  late Timer _timer;
  int _score = 0;
  final values = [3, 4, 5, 6];
  final int _maxLevel = 30;
  int _currentLevel = 1;
  DateTime? _lastBackPressed;
  bool _isWin = false;

  @override
  void initState() {
    super.initState();

    final random = Random();

    gridSize = values[0];

    for (int i = 0; i < gridSize; i++) {
      _pattern.add(List.generate(gridSize, (index) => random.nextBool()));
      _userPattern.add(List.generate(gridSize, (index) => false));
    }

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showingPattern = false;
        _timeLeft = 10;
      });

      _startTimer();
    });
  }

  void start1() {
    for (int i = 0; i < values[0]; i++) {
      _pattern.add(List.generate(values[0], (index) => false));
      _userPattern.add(List.generate(values[0], (index) => false));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const CountdownDialog(initialSeconds: 5);
        },
      ).then((_) {
        setState(() {
          _pattern.clear();
          _userPattern.clear();

          final random = Random();

          gridSize = values[random.nextInt(values.length)];

          for (int i = 0; i < gridSize; i++) {
            _pattern.add(List.generate(gridSize, (index) => random.nextBool()));
            _userPattern.add(List.generate(gridSize, (index) => false));
          }
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showingPattern = false;
            _timeLeft = 10;
          });

          _startTimer();
        });
      });
    });
  }

  void start() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Welcome to Memory Pattern Game!'),
          content: Text('Get ready to start the game!'),
        );
      },
    );

    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pop();

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showingPattern = false;
          _timeLeft = 10;
        });

        _startTimer();
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _gameOver = true;
        });
      }
    });
  }

  void _showPopup(bool isWin) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isWin ? 'Congratulations!' : 'Game Over!'),
            content: Text(
                isWin ? 'You completed all 20 levels!' : 'You made a mistake!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // if (isWin) {
                  //   _resetGame();
                  // }
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void _onTileTap(int row, int col) {
    if (_gameOver || _showingPattern) return;

    if (_userPattern[row][col]) return;

    setState(() {
      _userPattern[row][col] = !_userPattern[row][col];
    });

    if (!_pattern[row][col]) {
      _timer.cancel();
      setState(() {
        _gameOver = true;
        _isWin = false;
      });
      //_showPopup(false);
    }

    if (_isPatternMatched()) {
      _timer.cancel();
      setState(() {
        _showingPattern = true;
        _score++;
      });

      if (_currentLevel + 1 <= _maxLevel) {
        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (BuildContext context) {
        //     return const AlertDialog(
        //       title: Text('Great! Start next level in 5 seconds'),
        //       content: Text('Get ready to start the game!'),
        //     );
        //   },
        // );

        // Future.delayed(const Duration(seconds: 5), () {
        //   setState(() {
        //     _currentLevel++;
        //     _pattern.clear();
        //     _userPattern.clear();

        //     final random = Random();

        //     gridSize = values[random.nextInt(values.length)];

        //     for (int i = 0; i < gridSize; i++) {
        //       _pattern
        //           .add(List.generate(gridSize, (index) => random.nextBool()));
        //       _userPattern.add(List.generate(gridSize, (index) => false));
        //     }
        //   });
        //   Navigator.of(context).pop();

        //   Future.delayed(const Duration(seconds: 2), () {
        //     setState(() {
        //       _showingPattern = false;
        //       _timeLeft = 10;
        //     });

        //     _startTimer();
        //   });
        // });

        setState(() {
          _currentLevel++;
          _pattern.clear();
          _userPattern.clear();

          final random = Random();

          if (_currentLevel <= 10) {
            gridSize = values[0];
          } else if (_currentLevel <= 20) {
            gridSize = values[1];
          } else if (_currentLevel <= 30) {
            gridSize = values[2];
          }

          for (int i = 0; i < gridSize; i++) {
            _pattern.add(List.generate(gridSize, (index) => random.nextBool()));
            _userPattern.add(List.generate(gridSize, (index) => false));
          }
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showingPattern = false;
            _timeLeft = 10;
          });

          _startTimer();
        });
      } else {
        _timer.cancel();
        setState(() {
          _gameOver = true;
          _isWin = true;
        });

        _onBasicAlertPressed(context);
        //_showPopup(true);
      }
    }
  }

  bool _isPatternMatched() {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (_pattern[row][col] != _userPattern[row][col]) {
          return false;
        }
      }
    }
    return true;
  }

  void _resetGame() {
    _timer.cancel();

    List<List<bool>> a = [];
    List<List<bool>> b = [];
    final random = Random();

    gridSize = values[0];

    for (int i = 0; i < gridSize; i++) {
      a.add(List.generate(gridSize, (index) => random.nextBool()));
      b.add(List.generate(gridSize, (index) => false));
      log(i);
    }

    setState(() {
      _gameOver = false;
      _showingPattern = true;
      _currentLevel = 1;
      _score = 0;
      _timeLeft = 10;

      _pattern = a;
      _userPattern = b;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showingPattern = false;
      });

      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "Confirm Exit",
      desc: "Do you want to go back to the Home Page?",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          color: Color.fromRGBO(255, 81, 29, 1),
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        DialogButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          color: Color.fromRGBO(46, 204, 99, 1),
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    ).show();
  }

  _onBasicWaitingAlertPressed(context) async {
    await Alert(
      context: context,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();

    // Code will continue after alert is closed.
    debugPrint("Alert closed now.");
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Ngăn chặn việc pop ra khỏi màn hình
    } else {
      return true; // Cho phép pop ra khỏi màn hình
    }
  }

  _onBasicAlertPressed(context) {
    Alert(
            context: context,
            title: "Congratulations!",
            desc: "You completed all $_maxLevel levels!")
        .show();
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Do you want to go back to the Home Page?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Không thoát
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Thoát về HomePage
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          _onAlertButtonsPressed(context);
          // final shouldPop = await _showExitConfirmationDialog();
          // if (shouldPop) {
          //   // ignore: use_build_context_synchronously
          //   Navigator.of(context).popUntil((route) => route.isFirst);
          // }
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF2F3F8),
          appBar: AppBar(
              backgroundColor: const Color(0xFFF2F3F8),
              scrolledUnderElevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _gameOver
                  ? (_isWin
                      ? const Text("ALL CLEARED!",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green))
                      : const Text("Oops! GAME OVER!",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)))
                  : _showingPattern
                      ? const Text('Remember this pattern!',
                          style: TextStyle(fontSize: 20))
                      : Text('Please finish it! Time left: $_timeLeft',
                          style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                    ),
                    itemCount: gridSize * gridSize,
                    itemBuilder: (context, index) {
                      final row = index ~/ gridSize;
                      final col = index % gridSize;
                      final isPatternTile = _pattern[row][col];
                      final isUserTile = _userPattern[row][col];

                      Color color = const Color.fromARGB(255, 202, 202, 202);
                      if (_showingPattern) {
                        if (isPatternTile && !_gameOver) {
                          color = Colors.yellow;
                        } else {
                          const Color.fromARGB(255, 196, 174, 174);
                        }
                      } else {
                        if (_gameOver) {
                          if (isPatternTile && isUserTile) {
                            color = Colors.green;
                          } else {
                            if (!isPatternTile && !isUserTile) {
                              color = const Color.fromARGB(255, 202, 202, 202);
                            } else {
                              if (isUserTile) {
                                color = Colors.red;
                              } else {
                                color = Colors.yellow;
                              }
                            }
                          }
                        } else {
                          color = isUserTile
                              ? (_pattern[row][col] ? Colors.green : Colors.red)
                              : const Color.fromARGB(255, 202, 202, 202);
                        }
                      }

                      return GestureDetector(
                          onTap: () => _onTileTap(row, col),
                          child: Card(
                            borderOnForeground: true,
                            elevation: 5,
                            margin: const EdgeInsets.all(5),
                            color: color,
                          ));
                    },
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            blurRadius: 8,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          children: [
                            Text("Score: $_score",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                                "Current Level: $_currentLevel - Max Level: $_maxLevel",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    )),
              ),
              _gameOver
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: HexColor('#54D3C2'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  blurRadius: 8,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                highlightColor: Colors.transparent,
                                onTap: _resetGame,
                                child: Center(
                                  child: Text(
                                    'Try Again!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}
