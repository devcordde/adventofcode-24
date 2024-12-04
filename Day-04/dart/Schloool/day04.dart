import 'dart:io';

class Vector {
  final int x;
  final int y;

  Vector(this.x, this.y);

  @override
  bool operator ==(Object other) {
    return other is Vector && other.x == x && other.y == y;
  }
}

class Result {
  final Vector endPoint;
  final Vector direction;

  Result(this.endPoint, this.direction);
}

List<Result>? getValidResults(Vector point, List<String> letters,
    List<List<String>> letterLines, Vector? direction) {

  if (point.x < 0 || point.y < 0 || point.x >= letterLines[0].length ||
      point.y >= letterLines.length) {
    return null;
  }

  if (letters[0] != letterLines[point.y][point.x]) {
    return null;
  } else if (letters.length == 1) {
    return [Result(point, direction!)];
  }

  if (direction != null) {
    return getValidResults(Vector(point.x + direction.x, point.y + direction.y),
        letters.sublist(1, letters.length), letterLines, direction);
  }

  return [
    for (var vecX = -1; vecX <= 1; vecX++)
      for (var vecY = -1; vecY <= 1; vecY++)
        ...?getValidResults(Vector(point.x + vecX, point.y + vecY),
            letters.sublist(1), letterLines, Vector(vecX, vecY))
  ];
}

void main() async {
  final input = await File('./input.txt').readAsLines();
  final letterLines = input.map((line) => line.split('')).toList();

  var xmasResults = <Result>[];
  var masResults = <Result>[];
  for (var y = 0; y < letterLines.length; y++) {
    for (var x = 0; x < letterLines[y].length; x++) {
      xmasResults.addAll(getValidResults(Vector(x, y), 'XMAS'.split(''), letterLines, null) ?? []);
      masResults.addAll(getValidResults(Vector(x, y), 'MAS'.split(''), letterLines, null) ?? []);
    }
  }

  print('Part 1: ${xmasResults.length}');

  final getAPoint = (Result r) => Vector(r.endPoint.x - r.direction.x, r.endPoint.y - r.direction.y);
  final isDiagonal = (Result r) => r.direction.x != 0 && r.direction.y != 0;
  final crossMasResults = masResults.where((r1) => masResults.any((r2) =>
      r2 != r1 && getAPoint(r1) == getAPoint(r2) && isDiagonal(r1) && isDiagonal(r2))
  );

  print('Part 2: ${crossMasResults.length ~/ 2}');
}