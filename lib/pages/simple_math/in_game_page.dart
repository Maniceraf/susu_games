import 'dart:math';

import 'package:flutter/material.dart';
import 'package:susu_games/pages/simple_math/result_page.dart';
import 'package:susu_games/pages/simple_math/simple_math.model.dart';
import 'package:susu_games/utilities/custom_page_route.dart';
import 'package:susu_games/widgets/alert.dart';
import 'package:susu_games/widgets/constant.dart';
import 'package:susu_games/widgets/dialog_button.dart';

class InGamePage extends StatefulWidget {
  const InGamePage({super.key});

  @override
  InGamePageState createState() => InGamePageState();
}

List<Question> _generateQuestions() {
  List<Question> questions = [];
  final random = Random();

  for (int i = 0; i < 100; i++) {
    // Sinh số ngẫu nhiên cho phép tính
    int x = random.nextInt(20) + 1; // Từ 1 đến 20
    int y = random.nextInt(20) + 1; // Từ 1 đến 20
    String operator;
    int correctAnswer;

    // Chọn phép toán ngẫu nhiên
    switch (random.nextInt(3)) {
      case 0: // Cộng
        operator = '+';
        correctAnswer = x + y;
        break;
      case 1: // Trừ
        operator = '-';
        correctAnswer = x - y;
        break;
      case 2: // Nhân
        operator = '*';
        correctAnswer = x * y;
        break;
      default:
        operator = '+';
        correctAnswer = x + y;
    }

    // Tạo câu hỏi
    String question = '$x $operator $y = ?';

    // Tạo các tùy chọn, đảm bảo có câu trả lời đúng
    List<int> options = [correctAnswer];
    while (options.length < 4) {
      int option = random.nextInt(40) - 20; // Từ -20 đến 20
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    options.shuffle(); // Trộn các tùy chọn

    // Tạo đối tượng Question
    questions.add(
      Question(
        id: i + 1,
        question: question,
        options: options.map((e) => e.toString()).toList(),
        answer: correctAnswer.toString(),
      ),
    );
  }

  return questions;
}

class InGamePageState extends State<InGamePage> {
  List<Question> _questions = [];
  Question? _selectedQuestion;
  bool isStart = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions();
    _selectedQuestion =
        _questions.firstWhere((element) => !element.isCompleted);
  }

  Widget answerWidget(String option) {
    Color? color = null;
    if (!isStart) {
      color = const Color.fromARGB(255, 107, 142, 255);
    } else {
      if (_selectedQuestion?.yourAnswer != option) {
        color = const Color.fromARGB(255, 107, 142, 255);
      } else {
        if (_selectedQuestion?.yourAnswer == _selectedQuestion?.answer) {
          color = const Color.fromARGB(255, 159, 216, 126);
        } else {
          color = const Color.fromARGB(255, 247, 93, 93);
        }
      }

      if (isCorrect && option == _selectedQuestion?.answer) {
        color = const Color.fromARGB(255, 159, 216, 126);
      }
    }

    return Card(
      color: color,
      child: InkWell(
        onTap: () {
          setState(() {
            _questions
                .firstWhere((x) => x.id == _selectedQuestion!.id)
                .isCompleted = true;
            _questions
                .firstWhere((x) => x.id == _selectedQuestion!.id)
                .yourAnswer = option;
            if (option == _selectedQuestion!.answer) {
              _questions
                  .firstWhere((x) => x.id == _selectedQuestion!.id)
                  .isCorrect = true;
            }

            isStart = true;
          });

          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isCorrect = true;
            });

            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _selectedQuestion =
                    _questions.firstWhere((element) => !element.isCompleted);

                isStart = false;
                isCorrect = false;
              });

              if (_questions.where((x) => x.isCompleted).length >= 10) {
                // Chuyển đến Page B và xóa mọi thứ trước đó trừ HomePage
                Navigator.of(context).pushAndRemoveUntil(
                  CustomPageRoute.createPageRoute(ResultPage(
                      questions:
                          _questions.where((x) => x.isCompleted).toList())),
                  (Route<dynamic> route) =>
                      route.isFirst, // Chỉ giữ lại trang đầu tiên (HomePage)
                );
              }
            });
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Text(
              option,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
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
              color: const Color.fromRGBO(255, 81, 29, 1),
              child: const Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              color: const Color.fromRGBO(46, 204, 99, 1),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ).show();

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "${_questions.where((x) => x.isCompleted).length.toString()}/10",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        _questions
                            .where((x) => x.isCompleted && x.isCorrect)
                            .length
                            .toString(),
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        _questions
                            .where((x) => x.isCompleted && !x.isCorrect)
                            .length
                            .toString(),
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _selectedQuestion!.question,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: answerWidget(_selectedQuestion!.options[0])),
                      Expanded(
                          child: answerWidget(_selectedQuestion!.options[1]))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: answerWidget(_selectedQuestion!.options[2])),
                      Expanded(
                          child: answerWidget(_selectedQuestion!.options[3]))
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
