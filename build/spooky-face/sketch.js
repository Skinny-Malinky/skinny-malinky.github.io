let capture;

function setup() {
  createCanvas(640, 480);
  // pixelDensity(1);
  capture = createCapture(VIDEO);
  // capture.size(320, 240);
  capture.hide()
}

function draw() {
  background(255);
  let vScale = 15;
  capture.loadPixels();
  loadPixels();
  for (let y = 0; y < capture.height; y+=vScale) {
    for (let x = 0; x < capture.width; x+=vScale) {
      let index = (x+y*width)*4;
      let r = capture.pixels[index];
      let g = capture.pixels[index+1];
      let b = capture.pixels[index+2];
      let a = 255;
      noStroke();
      if (r > 120) {
        fill('rgba(' + r + ', ' + g + ', ' + b + ', ' + a + ')');
        vScale = 15;
      } else {
        fill(r+g+b) / 3;
        vScale = 2;
      }
      rect(x,y,vScale,vScale);
    }
  }
}