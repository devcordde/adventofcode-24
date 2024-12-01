import 'dart:io';

void main() async {
  final input = await File('./input.txt').readAsLines();
  final leftIds = <int>[];
  final rightIds = <int>[];

  input.forEach((l) {
    final numbers = l.split('   ').map(int.parse).toList();
    leftIds.add(numbers[0]);
    rightIds.add(numbers[1]);
  });

  leftIds.sort();
  rightIds.sort();

  final differenceSum = leftIds.asMap().entries
      .map((e) => (e.value - rightIds[e.key]).abs())
      .reduce((a, b) => a + b);

  print('Part 1: $differenceSum');

  final similarityScore = leftIds
      .map((left) => left * rightIds.where((right) => left == right).length)
      .reduce((a, b) => a + b);

  print('Part 2: $similarityScore');
}