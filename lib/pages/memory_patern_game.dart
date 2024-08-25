import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MemoryPatternPage extends StatefulWidget {
  const MemoryPatternPage({super.key, required this.title});

  final String title;

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
  final values = [3];
  final int _maxLevel = 10;
  int _currentLevel = 1;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();

    final random = Random();

    gridSize = values[random.nextInt(values.length)];

    for (int i = 0; i < gridSize; i++) {
      _pattern.add(List.generate(gridSize, (index) => random.nextBool()));
      _userPattern.add(List.generate(gridSize, (index) => false));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      start();
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
            content: Text(isWin
                ? 'You completed the level! Score: $_score'
                : 'You made a mistake!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isWin) {
                    _resetGame();
                  }
                },
                child: Text('OK'),
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
      });
      _showPopup(false);
    }

    if (_isPatternMatched()) {
      _timer.cancel();
      setState(() {
        _showingPattern = true;
        _score++;
      });

      if (_currentLevel + 1 <= _maxLevel) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Great! Start next level in 5 seconds'),
              content: Text('Get ready to start the game!'),
            );
          },
        );

        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            _currentLevel++;
            _pattern.clear();
            _userPattern.clear();

            final random = Random();

            gridSize = values[random.nextInt(values.length)];

            for (int i = 0; i < gridSize; i++) {
              _pattern
                  .add(List.generate(gridSize, (index) => random.nextBool()));
              _userPattern.add(List.generate(gridSize, (index) => false));
            }
          });
          Navigator.of(context).pop();

          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _showingPattern = false;
              _timeLeft = 10;
            });

            _startTimer();
          });
        });
      } else {
        _timer.cancel();
        setState(() {
          _gameOver = true;
        });

        _showPopup(true);
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

    gridSize = values[random.nextInt(values.length)];

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _gameOver
                ? const Text("GAME OVER!",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red))
                : _showingPattern
                    ? const Text('Memorize the pattern!',
                        style: TextStyle(fontSize: 20))
                    : Text('Tap to recreate the pattern! Time left: $_timeLeft',
                        style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text("Score: $_score",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Level: $_currentLevel/$_maxLevel",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _gameOver
                ? ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Try Again'),
                  )
                : Container(),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    final row = index ~/ gridSize;
                    final col = index % gridSize;
                    final isPatternTile = _pattern[row][col];
                    final isUserTile = _userPattern[row][col];

                    return GestureDetector(
                      onTap: () => _onTileTap(row, col),
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(4),
                        color: _showingPattern
                            ? (isPatternTile
                                ? Colors.yellow
                                : const Color.fromARGB(255, 202, 202, 202))
                            : (isUserTile
                                ? (_pattern[row][col]
                                    ? Colors.green
                                    : Colors.red)
                                : const Color.fromARGB(255, 202, 202, 202)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
