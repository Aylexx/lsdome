// Some real-time FFT! This visualizes music in the frequency domain using a
// polar-coordinate particle system. Particle size and radial distance are modulated
// using a filtered FFT. Color is sampled from an image.

import ddf.minim.analysis.*;
import ddf.minim.*;
import me.lsdo.processing.*;

PImage dot;
PImage colors;
Minim minim;
AudioInput in;
FFT fft;
float[] fftFilter;


float spin = 0.001;
float radiansPerBucket = (float)Math.PI/180f;
float decay = 0.9f;
float opacity = 10;
float minSize = 0.1;
float sizeScale = 0.2;
float angleCover = 500;

CanvasSketch simple;

void setup()
{
    size(300, 300, P3D);

    Dome dome = new Dome();
    OPC opc = new OPC();
    simple = new CanvasSketch(this, dome, opc);

    minim = new Minim(this); 

    // Small buffer size!
    in = minim.getLineIn();
    fft = new FFT(in.bufferSize(), in.sampleRate());
    fftFilter = new float[fft.specSize()];

    colors = loadImage("colors.png");
}

void draw()
{
    background(0);

    fft.forward(in.mix);
    for (int i = 0; i < fftFilter.length; i++) {
        fftFilter[i] = max(fftFilter[i] * decay, log(1 + fft.getBand(i)));
    }

        for (int i = 0; i < fftFilter.length; i += 3) {   
            color rgb = colors.get(int(map(i, 0, fftFilter.length-1, 0, colors.width-1)), colors.height/2);
            tint(rgb, fftFilter[i] * opacity);
            blendMode(ADD);

            float size = height * (minSize + sizeScale * fftFilter[i]);
            PVector center = new PVector(width * (fftFilter[i] * 0.2), 0);
            
            float angle = (float)(millis() * spin + i * radiansPerBucket);
            
            center.rotate(angle);
            center.add(new PVector(width * 0.5, height * 0.5));
            
            noFill();
            stroke(rgb);
            //strokeCap(SQUARE);
            //strokeWeight(2);
            //noStroke();

            arc(width/2, height/2, size, size, angle - size/angleCover, angle + size/angleCover);
            arc(width/2, height/2, size, size, PI + angle - size/angleCover, PI + angle + size/angleCover);
            //image(dot, center.x - size/2, center.y - size/2, size, size);
        }
    simple.draw();
}

