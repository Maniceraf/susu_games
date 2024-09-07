import 'dart:math';

import 'package:flutter/material.dart';
import 'package:susu_games/pages/number_hunt/in_game.dart';
import 'package:susu_games/pages/number_hunt/models/number_hunt.model.dart';
import 'package:susu_games/utilities/custom_page_route.dart';

List<NumberHuntModel> levels = [
  NumberHuntModel(level: "3x3", value: 3),
  NumberHuntModel(level: "4x4", value: 4),
  NumberHuntModel(level: "5x5", value: 5),
  NumberHuntModel(level: "6x6", value: 6),
  NumberHuntModel(level: "7x7", value: 7),
  NumberHuntModel(level: "8x8", value: 8),
  NumberHuntModel(level: "9x9", value: 9),
  NumberHuntModel(level: "10x10", value: 10),
];

class NumberHuntPage extends StatelessWidget {
  const NumberHuntPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Number Hunt",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Đặt màu của nút back thành màu trắng
          onPressed: () {
            Navigator.of(context).pop(); // Hành động khi nhấn nút back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Số lượng cột
              crossAxisSpacing: 2.0, // Khoảng cách giữa các cột
              mainAxisSpacing: 2.0, // Khoảng cách giữa các hàng
              childAspectRatio: 1.25),
          itemCount: levels.length, // Số lượng phần tử
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                int count = levels[index].value * levels[index].value;
                List<NumberModel> numbers = List.generate(
                    count, (index) => NumberModel(value: index + 1));
                numbers.shuffle(Random());
                Navigator.of(context)
                    .push(CustomPageRoute.createPageRoute(InGamePage(
                  numbers: numbers,
                  level: levels[index].value,
                )));
              },
              splashColor: Colors.red, // Màu hiệu ứng khi nhấn
              child: Card(
                color: const Color.fromARGB(255, 107, 142, 255),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        levels[index].level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        "Best: 00:00:00",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 242, 58),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
