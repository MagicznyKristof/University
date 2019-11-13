package Zadanie10;

import javax.swing.*;
import java.awt.*;
import java.util.LinkedList;
import java.util.Random;

public class SimBoard extends JPanel {

    public static final int FPS = 60;
    public static final int MAX_CARS = 20;
    public static final int MIN_DISTANCE = 10;
    public static final int CENTER = 400;
    public static final int SIZE = 800;
    public static final int LANE_SHIFT = 14;
    public static final int LANE_WIDTH = 25;
    public static final int SPAWNZONE = 50;
    public static final int CROSSROAD = 40;

    public boolean CROSSROAD_OCCUPIED = false;

    Random randomGenerator;
    LinkedList<Car> cars;
    int carsSpawned = 0;

    public SimBoard(boolean isDoubleBuffered) {
        super(isDoubleBuffered);

        randomGenerator = new Random();
        cars = new LinkedList<>();
        this.setPreferredSize(new Dimension(Assets.crossroad.getWidth(), Assets.crossroad.getHeight()));

        new Timer(1000 / FPS, e -> {
            this.repaint();
        }).start();


    }


    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.drawImage(Assets.crossroad, 0, 0, this);
        for (Car car : cars)
            car.draw(g);
    }

    public void spawnCar(Car.Orientation from, Car.Orientation to) {
        if (cars.size() >= MAX_CARS)
            return;

        int velocity = randomGenerator.nextInt(17) + 3;
        Car car = new Car(this, from, to, velocity);
        cars.add(car);
        new Thread(car).start();
        carsSpawned++;
    }

    public synchronized void removeCar(Car car) {
        cars.remove(car);
    }
}
