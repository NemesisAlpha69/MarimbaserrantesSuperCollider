let sound; // To hold the audio
let fft;   // For analyzing audio frequencies
let started = false; // Flag to track whether the audio has started

function preload() {
  sound = loadSound('Marimbas_Errantes.mp3'); // Replace with your MP3 file name
}

function setup() {
  createCanvas(800, 600);
  noStroke();

  fft = new p5.FFT();
  textSize(32);
  textAlign(CENTER, CENTER);
  fill(255);
  text('Click to Start', width / 2, height / 2);
}

function draw() {
  if (!started) return; // Wait for user to start the sound

  background(20);

  let spectrum = fft.analyze();

  for (let i = 0; i < spectrum.length; i++) {
    let x = map(i, 0, spectrum.length, 0, width);
    let h = map(spectrum[i], 0, 255, 0, height);
    fill(100, 200, 255);
    rect(random(x), height - h, width / spectrum.length, h);
  }

  let amplitude = fft.getEnergy("bass");
  fill(255, 100, 200, amplitude);
  ellipse( random(width), random(height), amplitude, amplitude);
}


function mousePressed() {
  if (!started) {
    sound.loop();
    started = true;
  }
}

