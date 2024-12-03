public static void main() throws java.io.IOException {
    var input = java.nio.file.Files.readString(java.nio.file.Path.of("input.txt"));
    System.out.println(STR."Day 3 -> Task 1: \{mulSum(input, "mul\\(\\d{1,3},\\d{1,3}\\)")}");
    System.out.println(STR."Day 3 -> Task 2: \{mulSum(input, "(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))|(don't\\(\\))|(do\\(\\))")}");
}

private static int mulSum(String input, String regex) {
    final boolean[] isActive = {true};
    return java.util.regex.Pattern.compile(regex).matcher(input).results().map(java.util.regex.MatchResult::group).mapToInt(string -> {
        isActive[0] = string.equals("do()") || (!string.equals("don't()") && isActive[0]);
        return isActive[0] && !string.equals("do()") ? Integer.parseInt(string.replaceAll("(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))", "$2")) *
                Integer.parseInt(string.replaceAll("(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))", "$4")) : 0;
    }).sum();
}