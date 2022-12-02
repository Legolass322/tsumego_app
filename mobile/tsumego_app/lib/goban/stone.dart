import 'package:flutter/material.dart';
import 'package:tsumego_app/goban/goban_position.dart';

class Stone extends StatefulWidget {
  const Stone({
    required this.x, 
    required this.y, 
    required this.size, 
    required this.color,
    required this.onClick, 
    super.key
  });

  final int x;
  final int y;
  final CellState color;
  final double size;
  final void Function() onClick;

  @override
  State<Stone> createState() => _StoneState();
}

class _StoneState extends State<Stone> {

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration;
    if (widget.color == CellState.empty) {
      decoration = const BoxDecoration();
    } else if (widget.color == CellState.black) {
      decoration = const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      );
    } else {
      decoration = const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      );
    }
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: decoration,
      )
    );
  }
}