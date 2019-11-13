package Skrzyzowanie;

import javax.swing.*;
import java.awt.*;

public class CrossroadsApp {
    public static void main(String[] args) {

        Assets.load();
        EventQueue.invokeLater(() -> {
            GUI gui = new GUI("Crossroad");
            gui.pack();
            gui.setLocationRelativeTo(null);
            gui.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

            gui.setVisible(true);
        });
    }
}