import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:susu_games/pages/number_hunt/models/number_hunt.model.dart';
import 'package:susu_games/pages/number_hunt/result.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

class InGamePage extends StatefulWidget {
  const InGamePage({super.key, required this.numbers, required this.level});

  final List<NumberModel> numbers;
  final int level;

  @override
  State<InGamePage> createState() => InGamePageState();
}

class InGamePageState extends State<InGamePage> {
  int heartCount = 3;
  int target = 1;

  late Timer _timer;
  int _seconds = 0;
  int _milliseconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _milliseconds += 10;
        if (_milliseconds >= 1000) {
          _milliseconds = 0;
          _seconds++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds, int milliseconds) {
    int minutes = (seconds / 60).floor();
    int displaySeconds = seconds % 60;
    int displayMilliseconds = (milliseconds / 10).floor();
    return '${_twoDigits(minutes)}:${_twoDigits(displaySeconds)}:${_twoDigits(displayMilliseconds)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Canh giữa
                  children: List.generate(heartCount, (index) {
                    return const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30.0,
                    );
                  }),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      _formatTime(_seconds, _milliseconds),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.level,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: widget.numbers.length,
              itemBuilder: (context, index) {
                return Material(
                  color: const Color.fromARGB(255, 107, 142, 255),
                  child: InkWell(
                    onTap: () {
                      if (widget.numbers[index].value == target) {
                        setState(() {
                          target++;
                        });
                        if (target - 1 == widget.numbers.length) {
                          _timer.cancel();
                          Navigator.of(context).pushReplacement(
                              CustomPageRoute.createPageRoute(ResultPage(
                            isSuccess: true,
                            result: _formatTime(_seconds, _milliseconds),
                            level: widget.level,
                          )));
                        }
                      } else {
                        setState(() {
                          heartCount--;
                        });
                        if (heartCount <= 0) {
                          Navigator.of(context).pushReplacement(
                              CustomPageRoute.createPageRoute(ResultPage(
                            isSuccess: false,
                            result: _formatTime(_seconds, _milliseconds),
                            level: widget.level,
                          )));
                        }
                      }
                    },
                    splashColor: Colors.red,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.zero),
                      child: Center(
                        child: Text(
                          widget.numbers[index].value.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.level == 10 ? 10 : 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
            Center(
              child: Text(
                "Tìm số: $target",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
