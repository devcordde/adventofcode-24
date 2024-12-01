import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class Solution {

    public static void main(String[] args) throws IOException {
        var lines = Files.readAllLines(Path.of("input.txt"));
        var left = lines.stream().mapToInt(string -> Integer.parseInt(string.split(" {3}")[0])).boxed().sorted().toList();
        var right = lines.stream().mapToInt(string -> Integer.parseInt(string.split(" {3}")[1])).boxed().sorted().toList();
        System.out.println("Day 1 -> Task 1: " + sumDiff(left, right));
        System.out.println("Day 1 -> Task 2: " + simScore(left, right));
    }

    private static int sumDiff(List<Integer> left, List<Integer> right) {
        var sum = 0;
        for (int index = 0; index < left.size(); index++) {
            sum += left.get(index) > right.get(index) ? left.get(index) - right.get(index) : right.get(index) - left.get(index);
        }
        return sum;
    }

    private static long simScore(List<Integer> left, List<Integer> right) {
        return left.stream().mapToLong(leftInt -> right.stream().filter(integer -> integer.equals(leftInt)).count() * leftInt).sum();
    }
}