var xspacing = 1;    // Distance between each horizontal location
var w;                // Width of entire wave
var theta = 0.0;      // Start angle at 0
var amplitude = 4.5;  // Height of wave
var period = 10.0;   // How many pixels before the wave repeats
var dx;               // Value for incrementing x
var yvalues;  // Using an array to store height values for the wave
var waveHeight = 7;
var extraY = 1;
var waveTwoY = 23;
var waveThreeY = 46;
var waveFourY = 69;
var colourValue = 256;

function setup() {
  createCanvas(54, 79);
  w = width/2;
  dx = (PI / period) * xspacing;
  yvalues = new Array(floor(w/xspacing));
  frameRate(30);
}

function draw() {
  background(0);
  calcWave();
  renderWave1();
  renderWave2();
  renderWave3();
  renderWave4();
  renderHeightWaveOne();
  renderHeightWaveTwo();
  renderHeightWaveThree();
  renderHeightWaveFour();
  renderSpacers();
}

function calcWave() {
  // Increment theta (try different values for
  // 'angular velocity' here
  theta += 0.03;
  // For every x value, calculate a y value with sine function
  var x = theta;
  for (var i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
}

function renderHeightWaveOne() {
  for (var x = 0; x < yvalues.length; x++) {
    for (var i = 0;i>-10;i--){
      fill(colourValue,colourValue,colourValue);
      noStroke();
      rect(x*xspacing, waveHeight/2-yvalues[x]+extraY+i, 1, 1);
      colourValue = colourValue-30;
    }
    colourValue = 256;
  }
}

function renderHeightWaveTwo() {
  for (var x = 0; x < yvalues.length; x++) {
    for (var i = 0;i<10;i++){
      fill(colourValue,colourValue,colourValue);
      noStroke();
      rect(x*xspacing, waveHeight/2+yvalues[x]+extraY+i+waveTwoY, 1, 1);
      colourValue = colourValue-30;
    }
    colourValue = 256;
  }
}

function renderHeightWaveThree() {
  for (var x = 0; x < yvalues.length; x++) {
    for (var i = 0;i>-10;i--){
      fill(colourValue,colourValue,colourValue);
      noStroke();
      rect(x*xspacing, waveHeight/2-yvalues[x]+extraY+i+waveThreeY, 1, 1);
      colourValue = colourValue-30;
    }
    colourValue = 256;
  }
}

function renderHeightWaveFour() {
  for (var x = 0; x < yvalues.length; x++) {
    for (var i = 0;i<10;i++){
      fill(colourValue,colourValue,colourValue);
      noStroke();
      rect(x*xspacing, waveHeight/2+yvalues[x]+extraY+i+waveFourY, 1, 1);
      colourValue = colourValue-30;
    }
    colourValue = 256;
  }
}

function renderWave1() {
  noStroke();
  fill(255);
  var blue = 256
  // A simple way to draw the wave with an ellipse at each location
  for (var i = 0;i>-10;i--){
    for (var x = 0; x < yvalues.length; x++) {
      fill(random(1,100),0, blue);
      rect(x*xspacing+27, waveHeight/2-yvalues[x]+extraY+i, 1, 1);
    }
  blue = blue - 50;
  }
}
function renderWave2() {
  noStroke();
  fill(255);
  var blue = 256
  // A simple way to draw the wave with an ellipse at each location
  for (var i = 0;i<10;i++){
    for (var x = 0; x < yvalues.length; x++) {
      fill(random(1,100),0, blue);
      rect(x*xspacing+27, waveHeight/2+yvalues[x]+extraY+i+waveTwoY, 1, 1);
    }
  blue = blue - 50;
  }
}
function renderWave3() {
  noStroke();
  fill(255);
  var blue = 256
  // A simple way to draw the wave with an ellipse at each location
  for (var i = 0;i>-10;i--){
    for (var x = 0; x < yvalues.length; x++) {
      fill(random(1,100),0, blue);
      rect(x*xspacing+27, waveHeight/2-yvalues[x]+extraY+i+waveThreeY, 1, 1);
    }
  blue = blue - 50;
  }
}
function renderWave4() {
  noStroke();
  fill(255);
  var blue = 256
  // A simple way to draw the wave with an ellipse at each location
  for (var i = 0;i<10;i++){
    for (var x = 0; x < yvalues.length; x++) {
      fill(random(1,100),0, blue);
      rect(x*xspacing+27, waveHeight/2+yvalues[x]+extraY+i+waveFourY, 1, 1);
    }
  blue = blue - 50;
  }
}
function renderSpacers(){
  fill(128);
  rect(0, 10, 54, 13);
  fill(128);
  rect(0, 33, 54, 13);
  fill(128);
  rect(0, 56, 54, 13);
}