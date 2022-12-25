function setup(){
  createCanvas(windowWidth, windowHeight);
}

var a = 0;

function draw() {
  //line(mouseX, mouseY, mouseX + 100, mouseY + 100);
  a += 0.01;
  //if(frameCount%30) {
  fill(color( (sin(a)*frameCount)%255, a*100 , 70+a*100) );
  noStroke();
  bobblesRadius = random(200, 300);
  ellipse(mouseX, mouseY, bobblesRadius, bobblesRadius);
  //}
  console.log(a);
  if (a >= 1) {
    
     a = 0;
  }
}