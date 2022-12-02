import 'package:tsumego_app/goban/coord.dart';

enum CellState {
  empty(0), white(1), black(2);

  const CellState(this.id);
  CellState get invert {
    if (id == 0) return CellState.empty;
    if (id == 1) return CellState.black;
    else return CellState.white;
  }
  final int id;
}

class GobanPosition {
  // TODO: implement with different sizes
  final int width = 19;
  final int height = 19;
  final _position = List.generate(
    19, 
    (i) => List.filled(19, CellState.empty, growable: false), 
    growable: false,
  );
  var turn = CellState.empty;

  GobanPosition.empty();
  GobanPosition.copy(GobanPosition other) {
    turn = other.turn;
    for (int i = 0; i < other._position.length; i++) {
      for (int j = 0; j < other._position[i].length; j++) {
        _position[i][j] = other._position[i][j];
      }
    }
  }

  void setCells(Map<Coord, CellState> cells) {
    cells.forEach((coord, state) { 
      _position[coord.x][coord.y] = state;
    });
  }

  CellState at(Coord c) {
    return _position[c.x][c.y];
  }

  operator[](int index) {
    return _position[index];
  }

  // TODO: implement hashCode
  @override
  bool operator==(Object other) {
    if (other is! GobanPosition) return false;
    for (int i = 0; i < _position.length; i++) {
      for (int j = 0; j < _position[i].length; j++) {
        if (_position[i][j] != other._position[i][j]) {
          return false;
        }
      }
    }
    return true;
  }
}