package Skrzyzowanie;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.Serializable;

public class Car implements Serializable, Runnable {

    public static final int size = 8;
    public static final float velocityModifier = 1f / 10f;
    public static final int PROBE_AHEAD = 40;
    public static final int PROBE_LEFT = 100;
    public static final int PROBE_RIGHT = 100;
    private static final int LANE[] = {386, 386, 414, 414};
    static long lastUpdate;
    static long elapsed;

    static {
        lastUpdate = System.currentTimeMillis();
    }

    SimBoard board;
    Orientation from;
    Orientation destination;
    int velocity;
    int turn = 0; // -1:left 0:straight 1:right
    boolean turning = false; // if the car is crossing the crossroad
    boolean moving = false;
    private int x, y;
    private float xf, yf;

    public Car(SimBoard parent, Orientation from, Orientation destination, int velocity) {
        board = parent;
        this.from = from;
        this.destination = destination;
        this.velocity = velocity;

        if ((from.value + 1) % 4 == destination.value)
            turn = 1;
        else if (from.value == (destination.value + 1) % 4)
            turn = -1;
        else if ((from.value + 2) % 4 == destination.value)
            turn = 0;
        else
            throw new IllegalArgumentException("wrong from->to destination");

        if (from == Orientation.SOUTH) {
            x = LANE[Orientation.SOUTH.value];
            y = SimBoard.SIZE - SimBoard.SPAWNZONE;
        } else if (from == Orientation.EAST) {
            x = SimBoard.SIZE - SimBoard.SPAWNZONE;
            y = LANE[Orientation.EAST.value];
        } else if (from == Orientation.NORTH) {
            x = LANE[Orientation.NORTH.value];
            y = SimBoard.SPAWNZONE;
        } else if (from == Orientation.WEST) {
            x = SimBoard.SPAWNZONE;
            y = LANE[Orientation.WEST.value];
        }

    }

    @Override
    public void run() {
        try {
            while (this.onBoard()) {
                elapsed = System.currentTimeMillis();
                if (elapsed - lastUpdate > 1000) {
                    deadlockSolve();
                }
                if (this.collidesAhead()) {
                    Thread.sleep(100);
                } else {
                    if (!onCrossroad()) {
                        if (moving) {
                            board.CROSSROAD_OCCUPIED = false;
                            moving = false;
                            from = Orientation.opposite(destination);
                            turn = 0;
                        }
                        move(Orientation.opposite(from));
                    } else {
                        if (board.CROSSROAD_OCCUPIED && !moving)
                            Thread.sleep(100);
                        else {
                            if (moving) {
                                if (turn == 0)
                                    move(destination);
                                else if (turn == 1)
                                    turn(destination);
                                else if (turn == -1)
                                    turn(destination);
                            } else {
                                if (turn == 0 && !collidesRight() ||
                                        turn == 1 ||
                                        turn == -1 && !collidesRight() && !collidesLeft()) {
                                    board.CROSSROAD_OCCUPIED = true;
                                    moving = true;
                                } else {
                                    Thread.sleep(100);
                                }
                            }
                        }

                    }

                }
                Thread.sleep(100 / (velocity * 2));
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        board.removeCar(this);
    }

    // póki jest na planszy symuluje
    private boolean onBoard() {
        return this.x >= 0 &&
                this.x <= SimBoard.SIZE &&
                this.y >= 0 &&
                this.y <= SimBoard.SIZE;
    }

    private synchronized boolean collidesAhead() {
        for (Car car : board.cars) {
            if (car != this && this.from == car.from) {

                if (this.from == Orientation.NORTH &&
                        this.y < car.y &&
                        this.y + PROBE_AHEAD > car.y)
                    return true;
                if (this.from == Orientation.SOUTH &&
                        this.y > car.y &&
                        this.y - PROBE_AHEAD < car.y)
                    return true;
                if (this.from == Orientation.WEST &&
                        this.x < car.x &&
                        this.x + PROBE_AHEAD > car.x)
                    return true;
                if (this.from == Orientation.EAST &&
                        this.x > car.x &&
                        this.x - PROBE_AHEAD < car.x)
                    return true;
            }
        }
        return false;
    }
    // sprawdza czy wcina się w boundingboxa

    private synchronized boolean collidesRight() {
        for (Car car : board.cars) {
            if (car != this && Orientation.CCW(this.from).value == car.from.value) {
                if (this.from.value == Orientation.SOUTH.value &&
                        this.x < car.x &&
                        this.x + PROBE_RIGHT > car.x)
                    return true;
                if (this.from.value == Orientation.NORTH.value &&
                        this.x > car.x &&
                        this.x - PROBE_RIGHT < car.x)
                    return true;
                if (this.from.value == Orientation.WEST.value &&
                        this.y < car.y &&
                        this.y + PROBE_RIGHT > car.y)
                    return true;
                if (this.from.value == Orientation.EAST.value &&
                        this.y > car.y &&
                        this.y - PROBE_RIGHT < car.y)
                    return true;
            }
        }
        return false;
    }

    private synchronized boolean collidesLeft() {
        for (Car car : board.cars) {
            if (car != this && this.from.value == Orientation.opposite(car.from).value) {
                if (this.from.value == Orientation.SOUTH.value &&
                        this.y > car.y &&
                        this.y - PROBE_LEFT < car.y)
                    return true;
                if (this.from.value == Orientation.NORTH.value &&
                        this.y < car.y &&
                        this.y + PROBE_LEFT > car.y)
                    return true;
                if (this.from.value == Orientation.WEST.value &&
                        this.x < car.x &&
                        this.x + PROBE_LEFT < car.x)
                    return true;
                if (this.from.value == Orientation.EAST.value &&
                        this.x > car.x &&
                        this.x - PROBE_LEFT < car.x)
                    return true;
            }
        }
        return false;
    }

    private boolean onCrossroad() {
        return Math.abs(this.x - SimBoard.CENTER) <= SimBoard.CROSSROAD &&
                Math.abs(this.y - SimBoard.CENTER) <= SimBoard.CROSSROAD;
    }

    private int moveCoordinate() {
        if (from == Orientation.NORTH || from == Orientation.SOUTH) return y;
        else return x;
    }

    void move(Orientation direction) {
        int dx = 0, dy = 0;
        if (direction == Orientation.NORTH) dy = -1;
        else if (direction == Orientation.SOUTH) dy = 1;
        else if (direction == Orientation.EAST) dx = 1;
        else if (direction == Orientation.WEST) dx = -1;
        x += dx;
        y += dy;
        lastUpdate = System.currentTimeMillis();
    }

    void turn(Orientation direction) {
        if (board.CROSSROAD_OCCUPIED && moving) {
            if (moveCoordinate() != LANE[Orientation.opposite(direction).value])
                move(Orientation.opposite(from));
            else
                move(direction);
        }
    }

    synchronized void deadlockSolve() {
        for (Car c : board.cars) {
            if (c.onCrossroad()) {
                board.CROSSROAD_OCCUPIED = true;
                c.moving = true;
                return;
            }
        }
    }

    void draw(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        BufferedImage img = null;
        if (turn == 0) img = Assets.carS;
        else if (destination == Orientation.EAST) img = Assets.carR;
        else if (destination == Orientation.NORTH) img = Assets.carU;
        else if (destination == Orientation.WEST) img = Assets.carL;
        else if (destination == Orientation.SOUTH) img = Assets.carD;
        g2d.drawImage(img, x - size, y - size, board);
    }

    enum Orientation {
        EAST(0), NORTH(1), WEST(2), SOUTH(3);
        private int value;

        Orientation(int value) {
            this.value = value;
        }

        static Orientation CW(Orientation o) {
            if (o == EAST) return SOUTH;
            if (o == SOUTH) return WEST;
            if (o == WEST) return NORTH;
            return EAST;
        }

        static Orientation CCW(Orientation o) {
            if (o == EAST) return NORTH;
            if (o == NORTH) return WEST;
            if (o == WEST) return SOUTH;
            return EAST;
        }

        static Orientation opposite(Orientation o) {
            if (o == EAST) return WEST;
            if (o == WEST) return EAST;
            if (o == NORTH) return SOUTH;
            return NORTH;
        }
    }
}