var k;
var d;
var n;

function setup() {
	createCanvas(640, 480);
	sliderN = createSlider(1, 10, 4, 0.01);
	sliderD = createSlider(1, 10, 4, 0.01);
}

function draw() {
	n = sliderN.value();
	d = sliderD.value();
	k = n / d + n;
	console.log(n, d, k);
	background(60);
	translate(width / 2, height / 2);
	beginShape();
	vertex(0, 0);
	strokeWeight(8);
	for (var a = 0; a < PI * d; a += 0.015) {
		var r = 200 * cos(k * parseInt(a));
		var x = r * cos(a);
		var y = r * sin(a);
		if (k == 0) { console.log('hi') }

		stroke(255);
		vertex(x, y);
	}
	fill(244, 25, 150, 255);
	endShape();
}
