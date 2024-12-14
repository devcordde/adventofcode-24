import javax.swing.*;
import javax.swing.border.BevelBorder;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.event.MouseInputAdapter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.beans.PropertyChangeListener;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicLong;

class AoC2024Day14 {

  public static void main(String[] args) throws IOException {
    List<String> lines = Files.readAllLines(Path.of("day14.txt"));
    int H = 103;
    int QH = H / 2;
    int W = 101;
    int QW = W / 2;
    record Vec(int x, int y) {}
    record Robot(Vec initialPos, Vec velocity) {}
    Robot[] robots = lines.stream().map(s -> {
      int space = s.indexOf(' ');
      int firstComma = s.indexOf(',');
      int lastComma = s.lastIndexOf(',');
      int rx = Integer.parseInt(s, 2, firstComma, 10);
      int ry = Integer.parseInt(s, firstComma + 1, space, 10);
      int vx = Integer.parseInt(s, space + 3, lastComma, 10);
      int vy = Integer.parseInt(s, lastComma + 1, s.length(), 10);
      return new Robot(new Vec(rx, ry), new Vec(vx, vy));
    }).toArray(Robot[]::new);
    long[] q = new long[4];
    for (Robot robot : robots) {
      Vec pos = robot.initialPos();
      Vec vel = robot.velocity();
      int x = Math.floorMod(pos.x() + vel.x() * 100, W);
      int y = Math.floorMod(pos.y() + vel.y() * 100, H);
      if (x != QW && y != QH) {
        q[(x / (QW + 1)) + (y / (QH + 1)) * 2]++;
      }
    }
    long safetyFactor = Arrays.stream(q).reduce(1, (a, b) -> a * b);
    System.out.println(safetyFactor);

    // ??? go through images and click the first one that has a christmas tree
    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    JFrame frame = new JFrame("wtf");
    frame.setExtendedState(frame.getExtendedState() | JFrame.MAXIMIZED_BOTH);
    frame.pack();
    int w = (screenSize.width - frame.getSize().width) / W;
    int h = (screenSize.height - frame.getSize().height) / H;
    JPanel panel = new JPanel(new GridLayout(h, w));
    frame.add(panel);
    AtomicLong step = new AtomicLong();
    BufferedImage[] img = new BufferedImage[w * h];
    for (int i = 0; i < img.length; i++) {
      img[i] = new BufferedImage(W, H, BufferedImage.TYPE_BYTE_GRAY);
      JButton field = new JButton(new ImageIcon(img[i]));
      field.setBorder(BorderFactory.createBevelBorder(BevelBorder.LOWERED));
      int index = i;
      field.addActionListener(e -> {
        System.out.println(step.get() - (img.length - index));
        frame.dispatchEvent(new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));
      });
      panel.add(field);
    }
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    ActionListener listener = e -> {
      for (BufferedImage image : img) {
        long s = step.getAndIncrement();
        image.getGraphics().clearRect(0, 0, W, H);
        for (Robot robot : robots) {
          Vec pos = robot.initialPos();
          Vec vel = robot.velocity();
          int x = Math.floorMod(pos.x() + vel.x() * s, W);
          int y = Math.floorMod(pos.y() + vel.y() * s, H);
          image.setRGB(x, y, 0xFFFFFF);
        }
      }
      panel.repaint();

    };
    listener.actionPerformed(null); // ...
    JButton next = new JButton("Next");
    next.addActionListener(listener);
    JDialog dialog = new JDialog(frame, "No christmas tree?");
    dialog.setSize(200, 100);
    dialog.add(next);
    frame.setVisible(true);
    dialog.setVisible(true);
  }
}
