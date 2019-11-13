package Zadanie12;

import javax.swing.*;
import java.awt.*;

public class SolarSystem {
    static GUI gui;

    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            gui = new GUI();
            gui.pack();
            gui.setLocationRelativeTo(null);
            gui.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);

            gui.setVisible(true);
        });
    }
}
