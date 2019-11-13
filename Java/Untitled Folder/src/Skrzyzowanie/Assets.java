package Skrzyzowanie;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;

public class Assets {

    public static BufferedImage crossroad;
    public static BufferedImage carS;
    public static BufferedImage carD;
    public static BufferedImage carR;
    public static BufferedImage carU;
    public static BufferedImage carL;

    public static void load() {
        try {
            crossroad = ImageIO.read(Assets.class.getResource("resources/crossroad.png"));
            carS = ImageIO.read(Assets.class.getResource("resources/car3.png"));
            carD = ImageIO.read(Assets.class.getResource("resources/car3D.png"));
            carR = ImageIO.read(Assets.class.getResource("resources/car3R.png"));
            carU = ImageIO.read(Assets.class.getResource("resources/car3U.png"));
            carL = ImageIO.read(Assets.class.getResource("resources/car3L.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}