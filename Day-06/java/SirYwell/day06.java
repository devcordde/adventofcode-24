import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.BitSet;
import java.util.List;

class day06 {

  enum Dir {
    UP(0, -1), RIGHT(1, 0), DOWN(0, 1), LEFT(-1, 0);
    private static final Dir[] VALUES = Dir.values();
    private final int x;
    private final int y;

    Dir(int x, int y) {
      this.x = x;
      this.y = y;
    }
    private Dir turn() {
      return VALUES[(this.ordinal() + 1) % 4];
    }

    private boolean requiresTurn(int x, int y, int W, int H, BitSet field) {
      int tx = x + this.x;
      int ty = y + this.y;
      return !isOffMap(H, W, tx, ty) && field.get(toIndex(tx, ty, W));
    }
  }

  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Path.of("day06.txt"));
    int H = lines.size();
    int W = lines.get(0).length();
    BitSet obstacles = new BitSet(H * W);
    int originX = -1;
    int originY = -1;
    for (int j = 0; j < lines.size(); j++) {
      String line = lines.get(j);
      for (int i = 0; i < line.length(); i++) {
        switch (line.charAt(i)) {
          case '^' -> {
            originX = i;
            originY = j;
          }
          case '#' -> obstacles.set(toIndex(i, j, W));
        }
      }
    }
    byte[] collect = collect(H, W, obstacles, originX, originY);
    int unique = 0;
    int extraObstaclePositions = 0;
    for (byte b : collect) {
      if ((b & 0xF) != 0) {
        unique++;
      }
      if (b < 0) {
        extraObstaclePositions++;
      }
    }
    System.out.println(unique);
    System.out.println(extraObstaclePositions);
  }

  private static byte[] collect(int H, int W, BitSet obstacles, int originX, int originY) {
    int x = originX;
    int y = originY;
    byte[] state = new byte[H * W];
    Dir dir = Dir.UP;
    markDir(W, state, x, y, dir);
    while (dir.requiresTurn(x, y, W, H, obstacles)) {
      dir = dir.turn();
      markDir(W, state, x, y, dir);
    }
    do {
      x += dir.x;
      y += dir.y;
      if (isOffMap(H, W, x, y)) {
        return state;
      }
      markDir(W, state, x, y, dir);
      Dir before = dir;
      while (dir.requiresTurn(x, y, W, H, obstacles)) {
        dir = dir.turn();
        markDir(W, state, x, y, dir);
      }
      Dir next = dir.turn();
      if (before != next && !isOffMap(H, W, x + dir.x, y + dir.y)) {
        int obstaclePos = toIndex(x + dir.x, y + dir.y, W);
        if (state[obstaclePos] != 0) {
          continue;
        }
        BitSet obstacleCopy = (BitSet) obstacles.clone();
        obstacleCopy.set(obstaclePos);
        byte[] stateCopy = state.clone();
        if (turnCausesLoop(next, stateCopy, H, W, obstacleCopy, x, y)) {
          state[obstaclePos] |= (byte) 0x80;
        }
      }
    } while (true);
  }

  private static boolean isOffMap(int H, int W, int x, int y) {
    return (Integer.compareUnsigned(x, W) & Integer.compareUnsigned(y, H)) >= 0;
  }

  private static boolean turnCausesLoop(Dir dir, byte[] state, int H, int W, BitSet obstacles, int originX, int originY) {
    int x = originX;
    int y = originY;
    if (markDir(W, state, x, y, dir)) {
      return true;
    }
    while (dir.requiresTurn(x, y, W, H, obstacles)) {
      dir = dir.turn();
      if (markDir(W, state, x, y, dir)) {
        return true;
      }
    }
    do {
      x += dir.x;
      y += dir.y;
      if (isOffMap(H, W, x, y)) {
        return false;
      }
      if (markDir(W, state, x, y, dir)) {
        return true;
      }
      while (dir.requiresTurn(x, y, W, H, obstacles)) {
        dir = dir.turn();
        if (markDir(W, state, x, y, dir)) {
          return true;
        }
      }
    } while (true);
  }

  private static boolean markDir(int W, byte[] state, int x, int y, Dir dir) {
    int idx = toIndex(x, y, W);
    byte b = state[idx];
    byte markBit = (byte) (1 << dir.ordinal());
    boolean isMarked = (b & markBit) != 0;
    b |= (byte) (1 << dir.ordinal());
    state[idx] = b;
    return isMarked;
  }

  private static int toIndex(int x, int y, int width) {
    return y * width + x;
  }
}
