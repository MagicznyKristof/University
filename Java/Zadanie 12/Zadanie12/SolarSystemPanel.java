package Zadanie12;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.awt.geom.Point2D;

public class SolarSystemPanel extends JPanel {
    public static int distanceScale = 5;
    public static int distanceGroupScale = 50;
    public static int distanceGroupSpacer = 180;
    Color backgroundColor = Color.decode("#0f1515");
    long oldTime = 0;
    double currentTime = 0;
    Point shift = new Point(0, 0);
    Point starting;
    Point oldShift;

    public SolarSystemPanel() {
        super(true);
        this.setBackground(backgroundColor);

        new Timer(1000 / 60, e -> this.repaint()).start();

        this.requestFocus();
        addMouseListener(new MouseAdapter() {

            @Override
            public void mousePressed(MouseEvent e) {
                starting = e.getPoint();
                oldShift = (Point) shift.clone();

            }


        });

        addMouseMotionListener(new MouseMotionAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                shift.x = oldShift.x + (e.getX() - starting.x);
                shift.y = oldShift.y + (e.getY() - starting.y);
            }
        });
    }

    @Override
    public void paintComponent(Graphics g) {
        if (oldTime == 0)
            oldTime = System.currentTimeMillis();
        long newTime = System.currentTimeMillis();
        currentTime += (double) (newTime - oldTime) / 1000.0 * (double) GUI.simSpeed;
        oldTime = newTime;

        Planet.updatePlanets(currentTime);


        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.translate(getWidth() / 2 + shift.x, getHeight() / 2 + shift.y);
        g2d.setColor(backgroundColor);
        g2d.fillRect(-this.getWidth() - shift.x, -this.getHeight() - shift.y, 2 * this.getWidth(), 2 * this.getHeight());
        Planet.planets.forEach((celestial, planet) -> {
            g2d.setColor(planet.getPlanetEnum().color);

            Point2D pos = calcPlanetPos(planet);
            Point2D parentPos = calcPlanetPos(planet.getParent());

            int radius = (int) calcPlanetRadius(planet);

            if (planet.getParent() != null)
                g2d.drawOval((int) (parentPos.getX() - calcPlanetDistance(planet)),
                        (int) (parentPos.getY() - calcPlanetDistance(planet)),
                        (int) (2 * (calcPlanetDistance(planet))),
                        (int) (2 * (calcPlanetDistance(planet)))
                );
            g2d.fillOval((int) (pos.getX() + parentPos.getX() - radius),
                    (int) (pos.getY() + parentPos.getY() - radius),
                    radius * 2,
                    radius * 2);

            g2d.setColor(Color.decode("#b7f70b"));
            g2d.drawString(planet.getPlanetEnum().name(), (int) (pos.getX() + parentPos.getX()), (int) (pos.getY() + parentPos.getY()));
        });
    }

    private Point2D.Double calcPlanetPos(Planet planet) {
        if (planet == null || planet.getPlanetEnum() == Celestial.SUN)
            return new Point2D.Double(0, 0);

        double distance = calcPlanetDistance(planet);
        return new Point2D.Double(distance * Math.cos(planet.getTheta()), distance * Math.sin(planet.getTheta()));
    }

    private double calcPlanetDistance(Planet planet) {
        if (planet == null || planet.getPlanetEnum() == Celestial.SUN)
            return 0;
        double exponent = Math.round(Math.log10(planet.getPlanetEnum().distance));
        double distance;
        if (planet.getPlanetEnum().type == Celestial.CelestialType.SATELLITE)
            return calcPlanetRadius(planet.getParent()) / 1.5 + distanceScale * planet.getPlanetEnum().distance / Math.pow(10, exponent - 1);
        else
            return distanceGroupScale * (exponent - 7) + distanceGroupSpacer * (exponent - 8) + distanceScale * planet.getPlanetEnum().distance / Math.pow(10, exponent - 1);
    }

    private double calcPlanetRadius(Planet planet) {
        double radiusExponent = Math.round(Math.log10(planet.getPlanetEnum().radius));
        if (planet.getPlanetEnum().type == Celestial.CelestialType.SATELLITE)
            radiusExponent--;
        if (planet.getPlanetEnum() == Celestial.URANUS || planet.getPlanetEnum() == Celestial.NEPTUNE)
            radiusExponent += 0.5;
        return Math.pow(2, radiusExponent);
    }
}
