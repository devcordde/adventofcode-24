import 'dart:io';

void main() async {
  final input = (await File('./input.txt').readAsString()).replaceAll('\n', '');

  final calculateMultiplicationSum = (String input) {
    final multiples = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)').allMatches(input)
        .map((e) => int.parse(e.group(1)!) * int.parse(e.group(2)!));
    return multiples.reduce((a, b) => a + b);
  };

  print('Part 1: ${calculateMultiplicationSum(input)}');

  final instructedInput = input.replaceAll(RegExp(r"don't\(\)[\S\s]+?(do\(\)|$)"), '');
  print('Part 2: ${calculateMultiplicationSum(instructedInput)}');
}