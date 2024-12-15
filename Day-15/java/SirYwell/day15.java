import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

class AoC2024Day15 {

  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Path.of("day15.txt"));
    int splitter = lines.indexOf("");
    List<String> fieldPart = lines.subList(0, splitter);
    int H = fieldPart.size();
    int W = fieldPart.getFirst().length();
    byte[] fieldOrig = new byte[H * W];
    int n = 0;
    int rpOrig = -1;
    for (String line : fieldPart) {
      for (int i = 0; i < W; i++, n++) {
        fieldOrig[n] = switch (line.charAt(i)) {
          case '#' -> 0;
          case '.' -> 1;
          case 'O' -> 2;
          case '@' -> {
            rpOrig = n;
            yield 1;
          }
          default -> throw new IllegalArgumentException(line);
        };
      }
    }
    enum D {
      UP, RIGHT, DOWN, LEFT
    }
    D[] directions = lines.subList(splitter + 1, lines.size())
        .stream()
        .flatMap(s -> s.chars().mapToObj(c -> switch (c) {
          case '^' -> D.UP;
          case '>' -> D.RIGHT;
          case 'v' -> D.DOWN;
          case '<' -> D.LEFT;
          default -> throw new IllegalArgumentException(String.valueOf(c));
        }))
        .toArray(D[]::new);
    int rp = rpOrig;
    byte[] field = fieldOrig.clone();
    for (D d : directions) {
      int offset = switch (d) {
        case D.UP -> -W;
        case D.RIGHT -> 1;
        case D.DOWN -> W;
        case D.LEFT -> -1;
      };
      int np = rp + offset;
      switch (field[np]) {
        case 1 -> rp = np;
        case 2 -> {
          int fp = np + offset;
          while (field[fp] == 2) {
            fp += offset;
          }
          if (field[fp] == 1) {
            field[fp] = 2;
            field[np] = 1;
            rp = np;
          }
        }
      }
    }
    long s = 0;
    for (int i = 0; i < field.length; i++) {
      if (field[i] == 2) {
        s += i % W + (i / W) * 100L;
      }
    }
    System.out.println(s);
    byte[] wideField = new byte[fieldOrig.length * 2];
    for (int i = 0; i < fieldOrig.length; i++) {
      wideField[i * 2] = fieldOrig[i];
      wideField[i * 2 + 1] = fieldOrig[i] == 2 ? 3 : fieldOrig[i];
    }
    rp = rpOrig * 2;
    for (D d : directions) {
      int offset = switch (d) {
        case D.UP -> -W * 2;
        case D.RIGHT -> 1;
        case D.DOWN -> W * 2;
        case D.LEFT -> -1;
      };
      int np = rp + offset;
      switch (wideField[np]) {
        case 1 -> rp = np;
        case 2 -> {
          if (d.ordinal() % 2 == 0) {
            if (canMove(wideField, np, offset)) {
              move(wideField, np, offset);
              rp = np;
            }
          } else {
            rp += tryMoveHorizontal(offset, np, wideField);
          }
        }
        case 3 -> {
          if (d.ordinal() % 2 == 0) {
            if (canMove(wideField, np - 1, offset)) {
              move(wideField, np - 1, offset);
              rp = np;
            }
          } else {
            rp += tryMoveHorizontal(offset, np, wideField);
          }
        }
      }
    }
    s = 0;
    for (int i = 0; i < wideField.length; i++) {
      if (wideField[i] == 2) {
        s += i % (W * 2L) + (i / (W * 2L)) * 100;
      }
    }
    System.out.println(s);
  }

  private static int tryMoveHorizontal(int offset, int np, byte[] wideField) {
    int fp = np + offset;
    while (((wideField[fp] - 2) | 1) == 1) {
      fp += offset;
    }
    if (wideField[fp] == 1) {
      int u = Math.max(np, fp);
      int l = Math.min(np, fp);
      if (offset < 0) {
        u++;
        l++;
      }
      System.arraycopy(wideField, l, wideField, l + offset, u - l);
      wideField[np] = 1;
      return offset;
    }
    return 0;
  }

  private static void move(byte[] field, int boxStart, int offset) {
    switch (field[boxStart + offset]) { // [
      case 1 -> {
      }
      case 2 -> move(field, boxStart + offset, offset);
      case 3 -> move(field, boxStart + offset - 1, offset);
      default -> throw new IllegalArgumentException("??");
    }
    switch (field[boxStart + offset + 1]) { // ]
      case 1 -> {
      }
      case 2 -> move(field, boxStart + offset + 1, offset);
      case 3 -> {
      } // covered by [
      default -> throw new IllegalArgumentException("??");
    }
    field[boxStart + offset] = 2;
    field[boxStart + offset + 1] = 3;
    field[boxStart] = 1;
    field[boxStart + 1] = 1;
  }

  private static boolean canMove(byte[] field, int boxStart, int offset) {
    return switch (field[boxStart + offset]) { // [
      case 0 -> false;
      case 1 -> true;
      case 2 -> canMove(field, boxStart + offset, offset);
      case 3 -> canMove(field, boxStart + offset - 1, offset);
      default -> throw new IllegalArgumentException("??");
    } && switch (field[boxStart + offset + 1]) { // ]
      case 0 -> false;
      case 1 -> true;
      case 2 -> canMove(field, boxStart + offset + 1, offset);
      case 3 -> true; // covered by [, no need to branch
      default -> throw new IllegalArgumentException("??");
    };
  }
}
