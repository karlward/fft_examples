import processing.sound.*;
FFT fft;
AudioIn in;
int sampleRate = 44100;
int nyquistFreq = sampleRate / 2; // assuming FFT uses Nyquist frequency
int bands = 256;
float freqBandwidth = nyquistFreq / bands;
int tickMod = int(bands / 8);
float[] spectrum = new float[bands];
SinOsc[] synth = new SinOsc[bands];
//SqrOsc[] synth = new SqrOsc[bands]; // change the oscillator: distortion!

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
  for (int i = 0; i < bands; i++) {
    synth[i] = new SinOsc(this);
    //synth[i] = new SqrOsc(this); // change the oscillator
    float centerFreq = (i * nyquistFreq / bands) + freqBandwidth / 2;
    synth[i].freq(int(centerFreq));
    synth[i].play();
  }
}      

void draw() { 
  background(255);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
    float centerFreq = (i * nyquistFreq / bands) + freqBandwidth / 2;
    synth[i].freq(centerFreq);
    //synth[i].freq(2 * centerFreq);// raise pitch by 1 octave
    synth[i].amp(spectrum[i]);
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
    //delay(1); // time stretching!
  } 
}
