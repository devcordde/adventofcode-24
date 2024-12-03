import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Pattern;

public static void main() throws IOException {
    var input = Files.readString(Path.of("input.txt"));
    System.out.println("Day 3 -> Task 1: " + mulSum(input, "mul\\(\\d{1,3},\\d{1,3}\\)"));
    System.out.println("Day 3 -> Task 2: " + mulSum(input, "(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))|(don't\\(\\))|(do\\(\\))"));
}

private static int mulSum(String input, String regex) {
    var matcher = Pattern.compile(regex).matcher(input);
    var matches = new LinkedList<String>();

    while (matcher.find()) matches.add(matcher.group());

    final boolean[] isActive = {true};
    return matches.stream().mapToInt(string -> {
        isActive[0] = string.equals("do()") || (!string.equals("don't()") && isActive[0]);
        return isActive[0] && !string.equals("do()") ? Integer.parseInt(string.replaceAll("(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))", "$2")) *
                Integer.parseInt(string.replaceAll("(mul\\()(\\d{1,3})(,)(\\d{1,3})(\\))", "$4")) : 0;
    }).sum();
}