import 'dart:io';

void main() async {
  final input = await File('./input.txt').readAsLines();
  final levels = input.map((line) => line.split(' ').map(int.parse).toList()).toList();

  final levelIsSafe = (List<int> level) {
    final isIncreasing = level[0] < level[1];
    return level.asMap().entries.every((e) {
      if (e.key == 0) return true;

      final previous = level[e.key - 1];
      return isIncreasing ? e.value >= previous + 1 && e.value <= previous + 3 :
        e.value <= previous - 1 && e.value >= previous - 3;
    });
  };

  final safeLevels = levels.where(levelIsSafe);
  print('Part 1: ${safeLevels.length}');

  final safeLevelsDampened = levels.where((level) => level.asMap().entries
      .any((e) => levelIsSafe(List.of(level)..removeAt(e.key))));
  print('Part 2: ${safeLevelsDampened.length}');
}