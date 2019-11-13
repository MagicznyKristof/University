package Zadanie10;

import javax.swing.*;
import java.awt.*;

public class GUI extends JFrame {
    private JPanel rootPanel;
    private JPanel crossroad;
    private JButton westEast;
    private JButton westSouth;
    private JButton westNorth;
    private JButton southNorth;
    private JButton southEast;
    private JButton southWest;
    private JButton eastSouth;
    private JButton eastNorth;
    private JButton eastWest;
    private JButton northWest;
    private JButton northEast;
    private JButton northSouth;
    private JPanel westPanel;
    private JPanel northPanel;
    private JPanel eastPanel;
    private JPanel southPanel;
    private JPanel bardContainer;

    public GUI(String title) throws HeadlessException {
        super(title);
        setContentPane(rootPanel);

        westEast.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.WEST, Car.Orientation.EAST));
        westSouth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.WEST, Car.Orientation.SOUTH));
        westNorth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.WEST, Car.Orientation.NORTH));
        southNorth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.SOUTH, Car.Orientation.NORTH));
        southEast.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.SOUTH, Car.Orientation.EAST));
        southWest.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.SOUTH, Car.Orientation.WEST));
        eastSouth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.EAST, Car.Orientation.SOUTH));
        eastNorth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.EAST, Car.Orientation.NORTH));
        eastWest.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.EAST, Car.Orientation.WEST));
        northWest.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.NORTH, Car.Orientation.WEST));
        northEast.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.NORTH, Car.Orientation.EAST));
        northSouth.addActionListener(e -> ((SimBoard) crossroad).spawnCar(Car.Orientation.NORTH, Car.Orientation.SOUTH));
    }

    private void createUIComponents() {
        crossroad = new SimBoard(true);
    }


}
