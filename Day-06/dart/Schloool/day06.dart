import 'dart:io';

class Vector {
  int x;
  int y;

  Vector(this.x, this.y);

  @override
  bool operator ==(Object other) {
    return other is Vector && other.x == x && other.y == y;
  }

  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y);
  }
}

void main() async {
  final input = await File('./input.txt').readAsLines();
  final map = input.map((line) => line.split('')).toList();

  final turnRight = (Vector v) => Vector(-v.y, v.x);
  var startPosition;
  final startDirection = Vector(0, -1);

  for (var y = 0; y < map.length; y++) {
    var x = map[y].indexOf('^');
    if (x != -1) {
      startPosition = Vector(x, y);
    }
  }

  final performRun = (Vector? obstruction, void Function()? onLoop) {
    var position = startPosition;
    var direction = startDirection;
    var next = position + direction;
    final visitedWithDirection = <Vector, Vector>{};

    while (true) {
      next = position + direction;
      if (next.x < 0 || next.x >= map[0].length || next.y < 0 || next.y >= map.length) {
        break;
      }

      final nextObj = map[next.y][next.x];

      if (nextObj == '#' || next == obstruction) {
        direction = turnRight(direction);
        continue;
      }

      if (visitedWithDirection.entries.any((e) => e.key == next && e.value == direction)) {
        onLoop?.call();
        map[obstruction!.y][obstruction.x] = 'O';
        return visitedWithDirection;
      }

      if (visitedWithDirection.keys.every((v) => v != next)) {
        visitedWithDirection[next] = direction;
      }

      position = next;
    }

    return visitedWithDirection;
  };

  final defaultPath = performRun(null, null);
  print('Part 1: ${defaultPath.length}');

  var loops = 0;
  defaultPath.forEach((pos, dir) => performRun(pos, () => loops++));
  print('Part 2: $loops');
}