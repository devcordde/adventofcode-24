import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

public class Solution {

    public static void main(String[] args) throws IOException {
        var lines = Files.readAllLines(Path.of("input.txt")).stream()
                .map(string -> Arrays.stream(string.split(" ")).map(Integer::parseInt).toList()).toList();

        System.out.println("Day 2 -> Task 1: " + secure(lines, false));
        System.out.println("Day 2 -> Task 2: " + secure(lines, true));
    }

    private static long secure(List<List<Integer>> input, boolean dampener) {
        return input.stream().filter(integers -> checkLevels(integers, dampener, false)).count();
    }

    public static boolean checkLevels(List<Integer> integers, boolean dampener, boolean alreadyDampened) {
        var it = integers.iterator();
        int curr, prev = it.next();
        boolean asc = integers.get(0) < integers.get(1);
        while (it.hasNext()) {
            curr = it.next();
            if ((asc && (curr - prev > 3 || curr - prev < 1)) || (!asc && (curr - prev > -1 || curr - prev < -3))) {
                return dampener && !alreadyDampened && anyMatch(integers);
            }
            prev = curr;
        }
        return true;
    }

    private static boolean anyMatch(List<Integer> integers) {
        for (int i = 0; i < integers.size(); i++) {
            var removed = new ArrayList<>(integers);
            removed.remove(i);
            if (checkLevels(removed, false, true)) {
                return true;
            }
        }
        return false;
    }
}