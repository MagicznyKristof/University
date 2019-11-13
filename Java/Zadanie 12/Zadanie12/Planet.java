package Zadanie12;

import java.util.EnumMap;
import java.util.Map;

public class Planet {


    static Map<Celestial, Planet> planets;

    static {
        planets = new EnumMap<>(Celestial.class);
        for (Celestial celestial : Celestial.values()) {
            Planet planet = new Planet(celestial);
            planets.put(celestial, planet);
        }
    }

    //-----------------------------------------------------------------------------
    private Celestial planetEnum;
    private double theta;

    private Planet(Celestial planetEnum) {
        this.planetEnum = planetEnum;
        this.theta = 0;
    }

    public static void updatePlanets(double deltaDays) { // delta time in days
        planets.forEach((celestial, planet) -> {
            if (planet.getPlanetEnum() != Celestial.SUN)
                planet._update(deltaDays);
        });
    }

    private void _update(double deltaDays) {
        theta = (deltaDays / planetEnum.period) * 2 * Math.PI;
    }

    public Celestial getPlanetEnum() {
        return planetEnum;
    }

    public double getTheta() {
        return theta;
    }

    public Planet getParent() {
        return planets.get(planetEnum.parentCelestial);
    }
}
