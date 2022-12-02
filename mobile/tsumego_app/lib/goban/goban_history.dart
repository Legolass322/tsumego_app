import 'package:tsumego_app/goban/goban_position.dart';
import 'package:tsumego_app/goban/coord.dart';

class GobanHistory {  
  final _TreeNode<GobanPosition> _root = _TreeNode(GobanPosition.empty());
  late _TreeNode<GobanPosition> _current;

  GobanPosition get current => _current.value;

  GobanHistory() {
    _current = _root;
  }

  StoneGroup _collectTheGroup(Coord coord) {
    var color = current.at(coord);
    if (color == CellState.empty) {
      return StoneGroup(color: color, stones: [coord], liberties: 0);
    }
    final stackOfStones = [coord];
    for (var i = 0; i < stackOfStones.length; i++) {
      for (var libery in stackOfStones[i].around()) {
        if (current.at(libery) == color && !stackOfStones.contains(libery)) {
          stackOfStones.add(libery);
        }
      }
    }

    // Counring liberties
    final stackOfLiberties = [];
    for (var stone in stackOfStones) {
      for (var liberty in stone.around()) {
        if (current.at(liberty) == CellState.empty && !stackOfLiberties.contains(liberty)) {
          stackOfLiberties.add(liberty);
        }
      }
    }
    return StoneGroup(
      color: color, 
      stones: stackOfStones, 
      liberties: stackOfLiberties.length
    );
  }

  void makeMove(Coord coord) {
    if (current.at(coord) != CellState.empty) {
      // TODO: make special exception
      throw Exception('Cannot');
    }
    var turn = current.turn == CellState.empty || current.turn == CellState.white 
      ? CellState.black 
      : CellState.white;

    // Checking groups
    final adjacentGroups = [ for (var iter in coord.around()) _collectTheGroup(iter) ];

    final emptyGroups = { for (var group in adjacentGroups) if (group.color == CellState.empty) group };
    final opponentGroups = { for (var group in adjacentGroups) if (group.color == turn.invert) group };
    final selfGroups = { for (var group in adjacentGroups) if (group.color == turn) group };
    final opponentDead = <StoneGroup>[];

    for (var group in opponentGroups) {
      if (group.liberties <= 1) {
        opponentDead.add(group);
      }
    }

    // Possibility: not sucidal
    if (emptyGroups.isEmpty) {
      if (opponentDead.isEmpty) {
        var alive = selfGroups
        .map((e) => e.liberties > 1)
        .reduce((value, element) => value || element);
        if (!alive) {
          // TODO: make special exception
          throw Exception('Cannot');
        }
      }
    }

    final newPos = GobanPosition.copy(current);
    newPos.turn = turn;
    final changes = <Coord, CellState>{
      coord: turn,
      for (var group in opponentDead) for (var stone in group.stones)
        stone: CellState.empty,
    };
    newPos.setCells(changes);

    // Possibility: ko-rule
    if (_current.parent?.value == newPos) {
      // TODO: make special exception
      throw Exception('Cannot');
    }

    _current.add(newPos);
    _current = _current.children[_current.children.length - 1];
  }
}

class _TreeNode<T> {  
  T value;
  _TreeNode<T>? parent;
  List<_TreeNode<T>> children = [];

  _TreeNode(this.value);

  void add(T childValue) {
    _TreeNode<T> tmp = _TreeNode<T>(childValue);
    children.add(tmp);
    tmp.parent = this;
  }
  // TODO: remove
}

class StoneGroup {
  CellState color = CellState.empty;
  List<Coord> stones = [];
  int liberties = 0;

  StoneGroup({required this.color, required this.stones, required this.liberties}) {
    stones.sort();
  }

  @override
  int get hashCode {
    if (stones.isEmpty) return 400;
    return stones[0].hashCode;
  }
  @override
  bool operator==(Object other) {
    return other is StoneGroup && hashCode == other.hashCode;
  }
}