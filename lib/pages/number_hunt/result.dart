import 'dart:math';

import 'package:flutter/material.dart';
import 'package:susu_games/pages/number_hunt/in_game.dart';
import 'package:susu_games/pages/number_hunt/models/number_hunt.model.dart';
import 'package:susu_games/pages/number_hunt/number_hunt.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

class ResultPage extends StatelessWidget {
  const ResultPage(
      {super.key,
      required this.isSuccess,
      required this.result,
      required this.level});

  final bool isSuccess;
  final String result;
  final int level;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Center(
                  child: Text(
                    "YOUR RESULT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Center(
                  child: Text(
                    isSuccess ? result : "Game Over!",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
            Image.asset(
              width: width / 2,
              'assets/images/giphy.gif',
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        CustomPageRoute.createPageRoute(const NumberHuntPage()),
                        (Route<dynamic> route) => route.isFirst,
                      );

                      int count = level * level;
                      List<NumberModel> numbers = List.generate(
                          count, (index) => NumberModel(value: index + 1));
                      numbers.shuffle(Random());

                      Navigator.of(context).push(
                        CustomPageRoute.createPageRoute(
                            InGamePage(level: level, numbers: numbers)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 107, 142, 255)),
                    child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Play Again',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 112, 143)),
                    child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Exit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
