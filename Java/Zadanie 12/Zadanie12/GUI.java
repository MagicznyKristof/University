package Zadanie12;

import javax.swing.*;
import java.awt.*;

public class GUI extends JFrame {
    public static int simSpeed = 25; // how many days one second represents
    private JPanel rootPanel;
    private JPanel systemPanel;
    private JSpinner simSpeedSpinner;
    private JSlider groupSep;
    private JSlider groupScale;
    private JSlider scale;
    private JLabel SimulationSpeed;

    public GUI() throws HeadlessException {
        super("Solar system app");
        setContentPane(rootPanel);
    }

    private void createUIComponents() {
        systemPanel = new SolarSystemPanel();
        simSpeedSpinner = new JSpinner();
        simSpeedSpinner.setValue(simSpeed);

        simSpeedSpinner.addChangeListener(e -> {
            if ((int) simSpeedSpinner.getValue() < -300000)
                simSpeedSpinner.setValue(-300000);
            if ((int) simSpeedSpinner.getValue() > 300000)
                simSpeedSpinner.setValue(30000);

            simSpeed = (int) simSpeedSpinner.getValue();
        });

        groupSep = new JSlider();
        groupScale = new JSlider();
        scale = new JSlider();

        groupSep.addChangeListener(e -> {
            if (groupSep.getValue() < 0)
                groupSep.setValue(0);
            if (groupSep.getValue() > 400)
                groupSep.setValue(400);

            SolarSystemPanel.distanceGroupSpacer = groupSep.getValue();
        });

        groupScale.addChangeListener(e -> {
            if (groupScale.getValue() < 0)
                groupScale.setValue(0);
            if (groupScale.getValue() > 400)
                groupScale.setValue(400);

            SolarSystemPanel.distanceGroupScale = groupScale.getValue();
        });

        scale.addChangeListener(e -> {
            if (scale.getValue() < 0)
                scale.setValue(0);
            if (scale.getValue() > 400)
                scale.setValue(400);

            SolarSystemPanel.distanceScale = scale.getValue();
        });
    }

}
