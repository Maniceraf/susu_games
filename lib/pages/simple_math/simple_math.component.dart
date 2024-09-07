import 'package:flutter/material.dart';
import 'package:susu_games/pages/simple_math/in_game_page.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

class SimpleMathPage extends StatefulWidget {
  const SimpleMathPage({super.key});

  @override
  State<SimpleMathPage> createState() => SimpleMathPageState();
}

class SimpleMathPageState extends State<SimpleMathPage> {
  int _selectedValue = 1; // Giá trị mặc định

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Đặt màu của nút back thành màu trắng
          onPressed: () {
            Navigator.of(context).pop(); // Hành động khi nhấn nút back
          },
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Simple Math",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Statistics",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.flag,
                                    color: Colors.orange,
                                    size: 25.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.access_alarm,
                                    color: Colors.blue,
                                    size: 25.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0%",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    "Precision",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 25.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    "Correct",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                    size: 25.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  Text(
                                    "Wrong",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Choose the complexity of the test",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        'Easy',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Medium',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      leading: Radio(
                        value: 2,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Hard',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      leading: Radio(
                        value: 3,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      CustomPageRoute.createPageRoute(const InGamePage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 142, 255)),
                child: const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'START',
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
