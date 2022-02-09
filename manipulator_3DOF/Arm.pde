int mode=0;
int phase=0;
float L1=60;
float L2=40;
float L3=50;
float W1=20;
float W2=10;
float W3=5;
float angle1=0;
float angle2=0;
float angle3=0;
float nextAngle1=0;
float nextAngle2=0;
float nextAngle3=0;
float angleV1=0;
float angleV2=0;
float angleV3=0;
float X=80;
float Y=40;
float Z=0;
float R=0;
float T1=0;
float T2=0;
float spAnim=0;
int key_Q=0;
int key_W=0;
int key_E=0;
int key_A=0;
int key_S=0;
int key_D=0;

void drawArm() {
  pushMatrix();

  noStroke();
  fill(100);
  //(0,0,0)
  pushMatrix();
  translate(0, -2, 0);
  box(300, 4, 300);
  popMatrix();

  line(0, 0, 0, 0, L1, 0);
  rotateY(angle1);

  //(0,0,0)
  pushMatrix();
  translate(0, 5, 0);
  fill(255, 0, 0);
  box(W1, 10, W2);
  translate(0, L1/2+W2/4, 0);

  translate((W1+W2)/4, 0, 0);
  box((W1-W2)/2, L1-10+W2/2, W2);
  translate(-(W1+W2)/2, 0, 0);
  box((W1-W2)/2, L1-10+W2/2, W2);
  popMatrix();

  translate(0, L1, 0);
  rotateX(angle2);

  //(0,L2,0)
  pushMatrix();
  fill(255, 255, 0);
  translate(0, (L2+W2/2+W3/2)/2-W2/2, 0);
  translate((W2+W3)/4, 0, 0);
  box((W2-W3)/2, (L2+W2/2+W3/2), W2);
  translate(-(W2+W3)/2, 0, 0);
  box((W2-W3)/2, (L2+W2/2+W3/2), W2);

  popMatrix();


  translate(0, L2, 0);
  pushMatrix();
  rotateX(angle3);


  fill(0, 255, 255);
  translate(0, L3/2-W3/4, 0);
  box(W3, L3+W3/2, W3);
  popMatrix();

  popMatrix();
}
void setSphere() {
  do {
    R=random(L2+L3);
    T1=random(2*PI);
    T2=random(-PI, PI);
    X=R*sin(T1)*sin(T2);
    Y=R*cos(T2)+L1;
    Z=R*cos(T1)*sin(T2);
  } while (Y<0 || (X*X+Z*Z<400 && dist(X, Y, Z, 0, L1, 0)<abs(L2-L3)));
  phase=1;
}
void drawSphere() {
  pushMatrix();
  translate(X, Y, Z);
  noStroke();
  if (phase==3) {
    fill(255, spAnim, 0, 255-spAnim);
    sphere(3+spAnim/15);
    spAnim=(spAnim+8);
    if (spAnim>255)phase=0;
  } else {
    fill(255);
    sphere(3);
    fill(255, 255, 255, 255-spAnim);
    sphere(3+spAnim/25);
    spAnim=(spAnim+4)%256;
  }
  popMatrix();
}

void InvKin() {
  float Th1[]=new float [2];
  float Th2[]=new float [2];
  float Th3[]=new float [2];
  float dif[]=new float [2];
  float S3=0;
  float C3=0;
  float A;
  float B;
  float M;
  float N;

  A=sqrt(Z*Z+X*X);
  B=(Y-L1);
  Th1[0]=atan2(X, Z);
  Th1[1]=Th1[0]+PI;

  C3=(Z*Z+X*X+B*B-L2*L2-L3*L3)/(2*L2*L3);
  S3=sqrt(1-C3*C3);
  Th3[0]=atan2(S3, C3);
  Th3[1]=-Th3[0];

  M=L2+L3*C3;
  N=L3*S3;
  Th2[0]=atan2(M*A-N*B, N*A+M*B);
  Th2[1]=atan2(M*A+N*B, -N*A+M*B);

  dif[1]=6*PI;
  for (int i=0; i<=1; i++) {
    for (int j=0; j<=1; j++) {
      dif[0]=min(abs(Th1[i]-angle1), abs(2*PI-abs(Th1[i]-angle1)))+min(abs(pow(-1, i)*Th2[(i+j)%2]-angle2), abs(2*PI-abs(pow(-1, i)*Th2[(i+j)%2]-angle2)))+min(abs(Th3[j]-angle3), abs(2*PI-abs(Th3[j]-angle3)));
      if (dif[0]<dif[1]) {
        nextAngle1=Th1[i];
        nextAngle2=pow(-1, i)*Th2[(i+j)%2];
        nextAngle3=Th3[j];
        dif[1]=dif[0];
      }
    }
  }
  angleV1=(nextAngle1-angle1)/60;
  angleV2=(nextAngle2-angle2)/60;
  angleV3=(nextAngle3-angle3)/60;
  angleV1=abs(nextAngle1-angle1)<PI ? (nextAngle1-angle1)/60:-(2*PI-abs(nextAngle1-angle1))*(nextAngle1-angle1)/abs(nextAngle1-angle1)/60;
  angleV2=abs(nextAngle2-angle2)<PI ? (nextAngle2-angle2)/60:-(2*PI-abs(nextAngle2-angle2))*(nextAngle2-angle2)/abs(nextAngle2-angle2)/60;
  angleV3=abs(nextAngle3-angle3)<PI ? (nextAngle3-angle3)/60:-(2*PI-abs(nextAngle3-angle3))*(nextAngle3-angle3)/abs(nextAngle3-angle3)/60;
  phase=2;
}

void moveArm() {
  switch(mode) {
  case 0:
    angle1=(2*PI+angle1+angleV1)%(2*PI);
    angle2=(2*PI+angle2+angleV2)%(2*PI);
    angle3=(2*PI+angle3+angleV3)%(2*PI);
    break;
  case 1:
    angle1=(2*PI+angle1+0.02*(key_Q-key_A))%(2*PI);
    angle2=(2*PI+angle2+0.02*(key_W-key_S))%(2*PI);
    angle3=(2*PI+angle3+0.02*(key_E-key_D))%(2*PI);
    break;
  }
}
void check() {
  float Xnow;
  float Ynow;
  float Znow;
  float[] range={1,2};
  Xnow=sin(angle1)*sin(angle2)*L2+sin(angle1)*sin(angle2+angle3)*L3;
  Ynow=L1+cos(angle2)*L2+cos(angle2+angle3)*L3;
  Znow=cos(angle1)*sin(angle2)*L2+cos(angle1)*sin(angle2+angle3)*L3;
  if (dist(X, Y, Z, Xnow, Ynow, Znow)<range[mode]) {
    phase=3;
    spAnim=0;
  }
}

void keyPressed() {
  if (key=='q'||key=='Q') {
    key_Q = 1;
  }
  if (key=='w'||key=='W') {
    key_W = 1;
  }
  if (key=='e'||key=='E') {
    key_E = 1;
  }
  if (key=='a'||key=='A') {
    key_A = 1;
  }
  if (key=='s'||key=='S') {
    key_S = 1;
  }
  if (key=='d'||key=='D') {
    key_D = 1;
  }
  if (phase==2 && key==' ') {
    mode=(mode+1)%2;
    phase=1;
  }
}
void keyReleased() {
  if (key=='q'||key=='Q') {
    key_Q = 0;
  }
  if (key=='w'||key=='W') {
    key_W = 0;
  }
  if (key=='e'||key=='E') {
    key_E = 0;
  }
  if (key=='a'||key=='A') {
    key_A = 0;
  }
  if (key=='s'||key=='S') {
    key_S = 0;
  }
  if (key=='d'||key=='D') {
    key_D = 0;
  }
}
