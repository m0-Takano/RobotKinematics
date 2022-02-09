MouseCamera mouseCamera;
void setup() {
  size(960, 640, P3D);
  mouseCamera = new MouseCamera(400.0, 0, 0, (height/2.0)/tan(PI*30.0/180.0), 0, 0, 0, 0, -1, 0); // MouseCamera
}

void draw() {
  switch(phase) {
  case 0:
    setSphere();
    break;
  case 1:
    InvKin();
    break;
  case 2:
    moveArm();
    check();
    break;
  case 3:
  
    break;
  }

  background(0);
  mouseCamera.update();
  drawArm();
  drawSphere();
}


//------------------------------------------------------------
void mousePressed() {
  mouseCamera.mousePressed();
}
void mouseDragged() {
  mouseCamera.mouseDragged();
}
void mouseWheel(MouseEvent event) {
  mouseCamera.mouseWheel(event);
}
