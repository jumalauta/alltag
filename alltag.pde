import ddf.minim.*;

Minim minim;
AudioPlayer audioPlayer;
PShader blur;
Worm[] worms;

void setup() {
  size(600, 600, P2D);
  blur = loadShader("blur.glsl");
  minim = new Minim(this);
  audioPlayer = minim.loadFile("loop.wav");
  audioPlayer.loop();
  worms = new Worm[50];
  for (int i = 0; i < worms.length; i++) {
    worms[i] = new Worm(600, 600);
  }
}

float filterCount = 0;

void draw() {
  background(64, 64, 64);
  strokeWeight(1);

  for (int i = 0; i < worms.length; i++) {
    Worm worm = worms[i];
    stroke(255 - (((float)i / (float)worms.length) * 255));
    worm.update();
    filter(blur);
  }
}

class Worm {
  float width;
  float height;
  float bottomX;
  NervousPoint point1;
  NervousPoint point2;
  NervousPoint point3;
  float x1;
  float m1;
  float m2;
  float m3;
  float s1;

  Worm(float w, float h) {
    width = w;
    height = h;
    bottomX = random(0, width);
    point1 = new NervousPoint(bottomX, 0);
    point2 = new NervousPoint(bottomX + random(-30, 30), (height * 0.333) + random(-10, 10));
    point3 = new NervousPoint(bottomX + random(-30, 30), (height * 0.666) + random(-10, 10));
    m1 = random(5, 40);
    m2 = random(5, 40);
    m3 = random(5, 40);
    s1 = random(0, 0.1);
  }

  void update() {
    x1 += s1;
    point1.update(5);
    point2.update(3);
    point3.update(1);
    point1.x += cos(x1) * m1;
    point2.x += sin(x1) * m2;
    point3.x += sin(x1) * m3;
    bezier(bottomX, height, point3.x, point3.y, point2.x, point2.y, point1.x, point1.y);
  }
}

class NervousPoint {
  float originX;
  float originY;
  float x;
  float y;

  NervousPoint(float x, float y) {
    originX = x;
    originY = y;
  }
  
  void update(float max) {
    x = originX + random(-max, max);
    y = originY + random(-max, max);
  }
}
