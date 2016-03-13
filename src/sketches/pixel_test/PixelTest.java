import processing.core.*;

public class PixelTest extends FadecandySketch {

    PixelTest(PApplet app) {
        super(app);
    }
    
    void draw(double t) {
        float creep_speed = 20;
        float ramp_length = 100;
        
        int[] arms;
        switch (panel_config_mode) {
        case _13:
            arms = new int[] {4, 4, 4, 1};
            break;
        case _24:
            arms = new int[] {4, 4, 4, 4, 4, 4};
            break;
        default:
            throw new RuntimeException();
        }
        int px_per_panel = LayoutUtil.pixelsPerPanel(panel_size);

        app.background(0);
        app.loadPixels();
        for (int i = 0; i < points.size(); i++) {
            int panel = i / px_per_panel;
            int arm;
            int panel0 = 0; // panel that starts the current arm
            for (arm = 0; arm < arms.length; arm++) {
                if (panel < arms[arm]) {
                    break;
                }
                panel -= arms[arm];
                panel0 += arms[arm];
            }
            int px = i - panel0 * px_per_panel; // pixel number within the current arm

            double k_px = (px - creep_speed * t) / ramp_length;
            double k_panel = panel / (double)Math.max(arms[arm] - 1, 1);

            double min_sat = .5;
            double max_sat = 1.;
            setLED(i, color(arm / (double)arms.length, min_sat*(1-k_panel) + max_sat*k_panel, MathUtil.fmod(k_px, 1.)));
        }
        app.updatePixels();
    }

}