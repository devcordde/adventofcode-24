import 'dart:io';

class Rule {
  int before;
  int after;

  Rule(this.before, this.after);
}

void main() async {
  final input = await File('./input.txt').readAsLines();

  final rules = input.map((line) => line.split('|'))
      .where((split) => split.length == 2)
      .map((numbers) => Rule(int.parse(numbers[0]), int.parse(numbers[1])))
      .toList();
  final pagesList = input.map((line) => line.split(','))
      .where((split) => split.length > 1)
      .map((line) => line.map(int.parse).toList())
      .toList();

  final pagesInRightOrder = (List<int> pages) {
    final pageEntries =  pages.toList().asMap().entries;
    return pageEntries.every((e) {
      final pageRules = rules.where((r) => r.before == e.value);
      return pageRules.every((rule) => pageEntries
          .where((e2) => e2.value == rule.after)
          .every((e2) => e2.key > e.key));
    });
  };

  final midPagesSum = (pageList) => pageList
      .map((pages) => pages[pages.length ~/ 2])
      .reduce((a, b) => a + b);

  final rightOrderPages = pagesList.where(pagesInRightOrder);
  print('Part 1: ${midPagesSum(rightOrderPages)}');

  final wrongOrderPages = pagesList
      .where((pagesList) => !pagesInRightOrder(pagesList))
      .toList();

  wrongOrderPages.forEach((pageList) {
    while (!pagesInRightOrder(pageList)) {
      final entries = pageList.asMap().entries;
      entries.forEach((a) => entries.forEach((b) {
        final rule = rules.where((rule) =>
          (rule.before == a.value && rule.after == b.value)
              || (rule.before == b.value && rule.after == a.value))
            .firstOrNull;

        if (rule == null) {
          return;
        }

        if ((rule.before == a.value && a.key > b.key) ||
            (rule.before == b.value && b.key > a.key)) {
          final temp = pageList[a.key];
          pageList[a.key] = pageList[b.key];
          pageList[b.key] = temp;
        }
      }));
    }
  });

  print('Part 2: ${midPagesSum(wrongOrderPages)}');
}