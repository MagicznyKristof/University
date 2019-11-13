package Zadanie12;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.awt.*;

public enum Celestial {

    SUN(CelestialType.STAR, 1.989e30, 6.96e5, null, 0, 0, Color.decode("#faa513")),

    MERCURY(CelestialType.PLANET_ROCK, 3.285e23, 2.44e3, SUN, 87.969, 5.791e7, Color.decode("#8f8f8f")),
    VENUS(CelestialType.PLANET_ROCK, 4.867e24, 6.05e3, SUN, 224.701, 1.082e8, Color.decode("#873d10")),
    EARTH(CelestialType.PLANET_ROCK, 5.972e24, 6.37e3, SUN, 365.256, 1.496e8, Color.decode("#0b3280")),
    MARS(CelestialType.PLANET_ROCK, 6.39e23, 3.39e3, SUN, 687.980, 2.279e8, Color.decode("#982b02")),

    JUPITER(CelestialType.PLANET_GAS, 1.898e27, 6.99e4, SUN, 4332.589, 7.785e8, Color.decode("#ab805c")),
    SATURN(CelestialType.PLANET_GAS, 5.683e26, 5.82e4, SUN, 10759.22, 1.429e9, Color.decode("#e8c782")),
    URANUS(CelestialType.PLANET_GAS, 8.681e25, 2.54e4, SUN, 30685.4, 2.871e9, Color.decode("#4cd4ea")),
    NEPTUNE(CelestialType.PLANET_GAS, 1.024e26, 2.46e4, SUN, 60189, 4.498e9, Color.decode("#466ffd")),

    CERES(CelestialType.PLANET_DWARF, 9.5e20, 4.73e2, SUN, 1680, 4.14e8, Color.decode("#8a837d")),
    PLUTO(CelestialType.PLANET_DWARF, 1.309e22, 1.19e3, SUN, 90560, 5.9063e9, Color.decode("#e4c1a1")),
    HAUMEA(CelestialType.PLANET_DWARF, 4.006e21, 8.16e2, SUN, 103774, 6.452e9, Color.decode("#848685")),
    MAKEMAKE(CelestialType.PLANET_DWARF, 2.9e21, 7.50e2, SUN, 112897, 6.77688e9, Color.decode("#8a635c")),
    ERIS(CelestialType.PLANET_DWARF, 1.66e22, 1.56e3, SUN, 204728.5, 1.012e10, Color.decode("#909aa1")),

    MOON(CelestialType.SATELLITE, 7.347e22, 1.737e3, EARTH, 27.321, 3.84403e5, Color.decode("#dadada")),
    IO(CelestialType.SATELLITE, 8.931e22, 1.815e3, JUPITER, 1.769, 4.22e5, Color.decode("#bab365")),
    EUROPA(CelestialType.SATELLITE, 4.8e22, 1.561e3, JUPITER, 3.551, 6.71e5, Color.decode("#9c724a")),
    TRITON(CelestialType.SATELLITE, 2.14e22, 1.353e3, NEPTUNE, -5.876, 3.548e5, Color.decode("#bfb8c0")),
    TITANIA(CelestialType.SATELLITE, 3.527e21, 7.88e2, URANUS, 8.7, 4.363e5, Color.decode("#a89e95")),
    GANYMEDE(CelestialType.SATELLITE, 1.4819e23, 2.634e3, JUPITER, 7.154, 1.07e6, Color.decode("#574b59")),
    TITAN(CelestialType.SATELLITE, 1.345e23, 2.576e3, SATURN, 15.95, 1.22187e6, Color.decode("#52886e")),
    CALLISTO(CelestialType.SATELLITE, 1.075e23, 2.410e3, JUPITER, 16.689, 1.883e6, Color.decode("#66525d"));


    @NotNull CelestialType type;
    double mass, radius; // mass in gk, radius in km
    @Nullable Celestial parentCelestial; // parent celestial it orbits around
    double period, distance; /// Period of full circle in earth days, distance in km
    Color color;

    Celestial(CelestialType type, double mass, double radius, @Nullable Celestial parentCelestial, double period, double distance, @NotNull Color color) {
        this.type = type;
        this.mass = mass;
        this.radius = radius;
        this.parentCelestial = parentCelestial;
        this.period = period;
        this.distance = distance;
        this.color = color;
    }


    enum CelestialType {
        STAR, PLANET_ROCK, PLANET_GAS, PLANET_DWARF, SATELLITE
    }
}
