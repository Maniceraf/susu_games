import 'package:flutter/material.dart';
import 'package:susu_games/pages/simple_math/simple_math.model.dart';
import 'package:susu_games/pages/simple_math/view_answers.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

class ResultPage extends StatelessWidget {
  final List<Question> questions;
  const ResultPage({super.key, required this.questions});

  String getText(count) {
    if (count <= 2) {
      return "Hey, you can do it!";
    } else if (count <= 4) {
      return "Hey, Not Bad!";
    } else if (count <= 6) {
      return "Good Job!";
    } else if (count <= 8) {
      return "Great!";
    } else {
      return "Perfect!";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Results",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      "Correct",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      questions.where((x) => x.isCorrect).length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      "Wrong",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      questions.where((x) => !x.isCorrect).length.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ))
              ],
            ),
            Center(
              child: Text(
                getText(questions.where((x) => x.isCorrect).length),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(CustomPageRoute.createPageRoute(ViewAnswers(
                        questions: questions,
                      )));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 107, 142, 255)),
                    child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'View Answers',
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
