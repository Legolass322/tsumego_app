import 'package:flutter/material.dart';
import 'package:tsumego_app/goban/goban_history.dart';
import 'package:tsumego_app/goban/coord.dart';
import 'package:tsumego_app/goban/stone.dart';

class Goban extends StatefulWidget {
  const Goban({super.key,});

  @override
  State<Goban> createState() => _GobanState();
}

class _GobanState extends State<Goban> {
  final history = GobanHistory();

  void makeMove(int x, int y) {
    setState(() {
      history.makeMove(Coord(x, y));
    });
  }

  @override
  Widget build(BuildContext context) {
    const size = 9;
    const lineWidth = 2.0;
    const space = 32.0;
    return Container(
      color: Colors.amber,
      width: 800.0,
      height: 800.0,
      child: Center(
        heightFactor: 2.0,
        widthFactor: 2.0,
        child: 
        Padding(padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(space/2),
                child: Column(children: [
                  for (int i = 0; i < size; i++)
                    Container(
                      color: Colors.black,
                      height: lineWidth,
                      width: (lineWidth + space) * (size - 1) + lineWidth,
                      margin: const EdgeInsets.only(bottom: space),
                    )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(space/2),
                child: Row(children: [
                  for (int i = 0; i < size; i++)
                    Container(
                      color: Colors.black,
                      height: (lineWidth + space) * (size - 1) + lineWidth,
                      width: lineWidth,
                      margin: const EdgeInsets.only(right: space),
                    )
                ]),
              ),
              Column(children: [
                for (int i = 0; i < size; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: lineWidth),
                    child: Row(children: [
                      for (int j = 0; j < size; j++)
                        Padding(
                          padding: const EdgeInsets.only(right: lineWidth),
                          child: Stone(
                            x: i, 
                            y: j, 
                            size: space, 
                            color: history.current.at(Coord(i, j)), 
                            onClick: () {
                              makeMove(i, j);
                            },
                          )
                        ),
                    ],)
                  ),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}