import 'package:flutter/material.dart';
import 'package:susu_games/pages/simple_math/in_game_page.dart';
import 'package:susu_games/pages/simple_math/simple_math.component.dart';
import 'package:susu_games/pages/simple_math/simple_math.model.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

class ViewAnswers extends StatelessWidget {
  final List<Question> questions;

  const ViewAnswers({super.key, required this.questions});

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
            Expanded(
                child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                      child: Text("Question",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25)),
                    )),
                    Expanded(
                        child: Center(
                      child: Text("Answer",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25)),
                    )),
                    Expanded(
                        child: Center(
                      child: Text("Correct",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 25)),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length, // Độ dài của danh sách
                  itemBuilder: (context, index) {
                    var question = questions[index];
                    Color color = question.answer == question.yourAnswer
                        ? Colors.greenAccent
                        : Colors.redAccent;
                    // Tạo một widget cho mỗi mục trong danh sách
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: Text(question.question,
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20)),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(question.yourAnswer,
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20)),
                          )),
                          Expanded(
                              child: Center(
                            child: Text(question.answer,
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20)),
                          )),
                        ],
                      ),
                    );
                  },
                ))
              ],
            )),
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    CustomPageRoute.createPageRoute(const SimpleMathPage()),
                    (Route<dynamic> route) => route.isFirst,
                  );

                  Navigator.of(context).push(
                    CustomPageRoute.createPageRoute(const InGamePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 142, 255)),
                child: const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Retry',
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
                    backgroundColor: const Color.fromARGB(255, 255, 112, 143)),
                child: const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 25),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
