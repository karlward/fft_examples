/* This is based on the processing.sound library's FFT example from 
 * https://processing.org/reference/libraries/sound/FFT.html 
 */

import processing.sound.*;
FFT fft;
AudioIn in;
int sampleRate = 44100;
int nyquistFreq = sampleRate / 2; // assuming FFT uses Nyquist frequency
int bands = 512;
float freqBandwidth = nyquistFreq / bands;
int tickMod = int(bands / 8);
float[] spectrum = new float[bands];

void setup() {
  size(1024, 360);
  background(255);
  strokeCap(SQUARE);
  strokeWeight(width/bands);
  textSize(14);
  textAlign(CENTER);
  fill(0,0,0);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in, bands);
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
    float centerFreq = (i * nyquistFreq / bands) + freqBandwidth / 2;
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    pushMatrix();
    //translate(i * width / bands, 0);
    translate(map(centerFreq, 0, nyquistFreq, 0, width), 0);
    line(0, height - 20, 0, height - spectrum[i]*height*5 - 20 );
    translate(0, height - 2);
    if (i % tickMod == 0) {
      text("" + centerFreq, 0, 0);
    }
    popMatrix();
  } 
}
