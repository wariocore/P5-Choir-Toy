import processing.sound.*;

AudioSample wave;
Pulse pulse;
Reverb reverb;
BandPass bandPass;
SoundFile drumsfx;
Amplitude amp;

Sound s;

int sampleCount = 128;
float[] buffer = new float[sampleCount];

float note;
float rate = 0;
String noteWritten = "";
String instruct = ""; 

boolean mute = true; //makes a wave sound on startup that idk how to fix -- hacky solution, but it works for something as small as this

void setup() {
  size(650, 400);
  
  drumsfx = new SoundFile(this, "drum.wav");

  for(int i = 0; i < buffer.length; i++) {    
    //sine wave code
    buffer[i] = sin(float(i)/buffer.length * TWO_PI);
  }
  
  pulse = new Pulse(this); //club member 1
  
  bandPass = new BandPass(this);
  wave = new AudioSample(this, buffer, 440*buffer.length); //club member 2 
  wave.loop();
  bandPass.process(wave);
  
  s = new Sound(this); //all sound
  s.volume(0);
  
  reverb = new Reverb(this);
  pulse.amp(0.02);
  
  amp = new Amplitude(this);
  amp.input(drumsfx);
}      
  


void draw() {
  background(255);
  noFill();
  stroke(255);
  strokeWeight(2);
  
  textSize(40);
  if (mute){
    instruct = "M - UNMUTE ALL"; 
  } else { 
    instruct = "M - MUTE ALL";  }
    
  text(instruct, 30, 50);

  if (mute) {
    s.volume(0);
  } else { 
    s.volume(0.5);
  }

  
  
  // ----------------------------------------------------------------------------------------
  //glee club guy 1 - beeps
  fill(255);
  stroke(0);
  ellipse(120, 370, 150, 250);
  circle(120, 200, 150);
  fill(0);
  circle(80, 200, 10);
  circle(160, 200, 10);
  
  
  if (mute || note == 0 || ((!keyPressed || key == ' ' || key == 'm' || key == 'M'))){
    mouthshut(85, 220);
    pulse.amp(0);
   } else {
    pulse.amp(0.05);
    ellipse(120, 230 - note / 20, 50, note / 3);
   }
    
    
  text(noteWritten, 80, 100);
  // ----------------------------------------------------------------------------------------
  //glee club guy 2 - held note -- code for club member 2 is based on in class wave code
  fill(255);
  stroke(0);
  ellipse(320, 370, 150, 250);
  circle(320, 200, 150);
  fill(0);
  circle(280, 200, 10);
  circle(360, 200, 10);
  

  if (mute || (!mousePressed)) { 
    wave.amp(0);
    mouthshut(285, 220);
  } else {
    wave.amp(0.08); 
    ellipse(320, 230 - (rate * 100) / 20, 50, rate * 50);
    }

  // ----------------------------------------------------------------------------------------
  //glee club guy 3 - percussion
  fill(255);
  stroke(0);
  ellipse(520, 340, 150, 250);
  circle(520, 180, 150);
  fill(0);
  circle(480, 180, 10);
  circle(560, 180, 10);
  
  if (mute){
    mouthshut(485, 200);
  } else {
    float sfxplaying = amp.analyze();
    if (sfxplaying > 0.005){
      ellipse(520, 210, 50, 50);}
    else {
    mouthshut(485, 200);}
    }
    
  
}

void mouthshut(int x, int y){
    line(x, y, x + 35, y + 20);
    line(x + 35, y + 20, x + 70, y);
}

void keyPressed() {
  if (key == 'm' || key == 'M') {
    if (mute == true) {
      mute = false;
    } else { 
      mute = true; }
    print(mute);
  }   
  else if (!mute){
    switch(key) {
      case ' ':
        drumsfx.play(1,1);
        break;

      case '1': 
        noteWritten = "Low C";  
        note = 130.813;
        break;
      case '2': 
        noteWritten = "D";  
        note = 146.832;
        break;
      case '3': 
        noteWritten = "E";  
        note = 164.814;
        break;
      case '4': 
        noteWritten = "F";  
        note = 174.614;
        break;
      case '5': 
        noteWritten = "G";  
        note = 195.998;
        break;
      case '6': 
        noteWritten = "A";  
        note = 220;
        break;
      case '7': 
        noteWritten = "B";  
        note = 246.942 ;
        break;
      case '8': 
        noteWritten = "High C";  
        note = 261.626;
        break;
      default: 
        note = 0;
        break;
    }
   
   if (!(note == 0)){ 
    pulse.freq(note);
    pulse.play();
    }
   
  }
}

void mouseDragged() {
  updateWave();
}

void mouseMoved()
{
  updateWave();
}

void updateWave(){
  float minRate = 0.5; 
  float maxRate = 2.0; 
  rate = map(mouseY, height, 0, minRate, maxRate);

  wave.rate(rate); // for pitch
}
