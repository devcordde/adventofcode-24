import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Queue;

class day12 {

  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Path.of("day12.txt"));
    int H = lines.size() + 2;
    int W = lines.getFirst().length() + 2;
    byte[] field = new byte[H * W];
    int idx = W + 1;
    for (String l : lines) {
      for (int x = 0; x < l.length(); x++) {
        field[idx++] = (byte) l.charAt(x);
      }
      idx += 2;
    }
    ArrayDeque<Integer> global = new ArrayDeque<>();
    ArrayDeque<Integer> local = new ArrayDeque<>();
    global.add(toIndex(1, 1, W));
    final byte localBit = 0b01;
    byte[] visited = new byte[H * W];
    long priceSum = 0;
    long bulkPriceSum = 0;
    while (!global.isEmpty()) {
      long area = 0;
      List<Integer> np = new ArrayList<>();
      List<Integer> ep = new ArrayList<>();
      List<Integer> sp = new ArrayList<>();
      List<Integer> wp = new ArrayList<>();
      int pos = global.removeFirst();
      local.add(pos);
      while (!local.isEmpty()) {
        int ir = local.removeFirst();
        int xr = toX(ir, W);
        int yr = toY(ir, W);
        if ((visited[ir] & localBit) != 0) {
          continue;
        }
        area++;
        visited[ir] |= localBit;
        byte v = field[ir];
        if (v == 0) {
          continue;
        }
        int in = toIndex(xr, yr - 1, W);
        byte n = field[in];
        if (outside(v, n, in, global, local, visited)) {
          np.add(in);
        }
        int ie = toIndex(xr + 1, yr, W);
        byte e = field[ie];
        if (outside(v, e, ie, global, local, visited)) {
          ep.add(rotate(ie, W, H));
        }
        int is = toIndex(xr, yr + 1, W);
        byte s = field[is];
        if (outside(v, s, is, global, local, visited)) {
          sp.add(is);
        }
        int iw = toIndex(xr - 1, yr, W);
        byte w = field[iw];
        if (outside(v, w, iw, global, local, visited)) {
          wp.add(rotate(iw, W, H));
        }
      }
      priceSum += area * (np.size() + ep.size() + sp.size() + wp.size());
      bulkPriceSum += area * (bulkPrice(np) + bulkPrice(ep) + bulkPrice(sp) + bulkPrice(wp));
    }
    System.out.println(priceSum);
    System.out.println(bulkPriceSum);
  }

  private static long bulkPrice(List<Integer> parts) {
    Collections.sort(parts);
    if (parts.isEmpty()) {
      return 0;
    }
    long p = 1;
    int before = parts.getFirst();
    for (int i = 1; i < parts.size(); i++) {
      int next = parts.get(i);
      if (next != before + 1) {
        p++;
      }
      before = next;
    }
    return p;
  }

  private static boolean outside(byte rv, byte ov, int op, Queue<Integer> global, Queue<Integer> local, byte[] visited) {
    if (rv != ov) {
      if (ov != 0 && visited[op] >> 1 == 0) {
        visited[op] |= 0b10;
        global.add(op);
      }
      return true;
    } else {
      local.add(op);
      return false;
    }
  }

  private static int rotate(int index, int W, int H) {
    int x = toX(index, W);
    int y = toY(index, W);
    //noinspection SuspiciousNameCombination
    return toIndex(y, x, H);
  }

  private static int toIndex(int x, int y, int W) {
    return y * W + x;
  }

  private static int toX(int index, int W) {
    return index % W;
  }

  private static int toY(int index, int W) {
    return index / W;
  }
}
