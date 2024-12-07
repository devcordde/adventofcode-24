import 'dart:io';
import 'dart:math';

class Equation {
  int result;
  List<int> numbers;

  Equation(this.result, this.numbers);
}

void main() async {
  final input = await File('./input.txt').readAsLines();
  final equations = input.map((line) {
    final resultSplit = line.split(':');
    return Equation(
        int.parse(resultSplit[0]),
        resultSplit[1].trim().split(' ').map(int.parse).toList()
    );
  }).toList();

  List<List<String>> generateOperatorCombinations(int count, List<String> operators) {
    final combinations = <List<String>>[];
    final totalCombinations = pow(operators.length, count);

    for (var i = 0; i < totalCombinations; i++) {
      var temp = i;
      final combination = <String>[];
      for (var j = 0; j < count; j++) {
        combination.add(operators[temp % operators.length]);
        temp ~/= operators.length;
      }
      combinations.add(combination);
    }

    return combinations;
  }

  final getSolvableEquationSum = (List<String> operators) {
    return equations.where((equation) {
      final numCount = equation.numbers.length;
      final operatorCombinations = generateOperatorCombinations(numCount - 1, operators);

      for (var combination in operatorCombinations) {
        var result = equation.numbers[0];
        for (var i = 0; i < combination.length; i++) {
          final operator = combination[i];
          final nextNumber = equation.numbers[i + 1];
          if (operator == '+') {
            result += nextNumber;
          } else if (operator == '*') {
            result *= nextNumber;
          } else if (operator == '||') {
            result = int.parse('$result$nextNumber');
          }
        }

        if (result == equation.result) {
          return true;
        }
      }

      return false;
    }).map((e) => e.result).reduce((a, b) => a + b);
  };

  print('Part 1: ${getSolvableEquationSum(['+', '*'])}');
  print('Part 2: ${getSolvableEquationSum(['+', '*', '||'])}');
}