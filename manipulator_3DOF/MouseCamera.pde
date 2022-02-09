//---quote from "titech-ssr.blog.jp"---
class MouseCamera {
  float eyeX, eyeY, eyeZ;
  float centerX, centerY, centerZ;
  float upX, upY, upZ;
  float radius;
  float[][] matrix;
  PVector preVector;
  MouseCamera(float radius) {
    this(radius, width/2.0, height/2.0, (height/2.0)/tan(PI*30.0/180.0), width/2.0, height/2.0, 0, 0, -1, 0);
  }
  MouseCamera(float radius, float eyeX, float eyeY, float eyeZ, float centerX, float centerY, float centerZ, float upX, float upY, float upZ) {
    this.radius = radius;
    this.eyeX = eyeX;
    this.eyeY = eyeY;
    this.eyeZ = eyeZ;
    this.centerX = centerX;
    this.centerY = centerY;
    this.centerZ = centerZ;
    this.upX = upX;
    this.upY = upY;
    this.upZ = upZ;
    matrix = getIdentityMatrix();
  }
  void update() {
    beginCamera();
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
    applyMatrix(matrix[0][0], matrix[0][1], matrix[0][2], matrix[0][3],
      matrix[1][0], matrix[1][1], matrix[1][2], matrix[1][3],
      matrix[2][0], matrix[2][1], matrix[2][2], matrix[2][3],
      matrix[3][0], matrix[3][1], matrix[3][2], matrix[3][3]);
    endCamera();
  }
  void mousePressed() {
    switch(mouseButton) {
    case RIGHT:
      {
        matrix = getIdentityMatrix();
      }
      break;
    case LEFT:
      {
        preVector = mouseOnSphere(-mouseX+width/2, -mouseY+height/2);
      }
      break;
    case CENTER:
      {
        preVector = new PVector(-mouseX+width/2, -mouseY+height/2);
      }
      break;
    }
  }
  void mouseDragged() {
    switch(mouseButton) {
    case LEFT:
      {
        PVector v = mouseOnSphere(-mouseX+width/2, -mouseY+height/2);
        matrix = mult(getRotationMatrix(preVector, v), matrix);
        preVector = v;
      }
      break;
    case CENTER:
      {
        PVector v = new PVector(-mouseX+width/2, -mouseY+height/2);
        matrix = mult(getTranslationMatrix(preVector, v), matrix);
        preVector = v;
      }
      break;
    }
  }

  void mouseWheel(MouseEvent event) {
    matrix = mult(getScaleMatrix(event.getCount()), matrix);
  }

  float[][] getIdentityMatrix() {
    return new float[][] {{1.0, 0.0, 0.0, 0.0},
      {0.0, 1.0, 0.0, 0.0},
      {0.0, 0.0, 1.0, 0.0},
      {0.0, 0.0, 0.0, 1.0}};
  }

  float[][] getRotationMatrix(PVector v1, PVector v2) {
    PVector v = v1.cross(v2).normalize();
    float c = v1.dot(v2);
    float s = v1.cross(v2).mag();
    return new float[][] {{c + v.x*v.x*(1-c), v.x*v.y*(1-c) - v.z*s, v.x*v.z*(1-c) + v.y*s, 0.0},
      {v.y*v.x*(1-c) + v.z*s, c + v.y*v.y*(1-c), v.y*v.z*(1-c) - v.x*s, 0.0},
      {v.z*v.x*(1-c) - v.y*s, v.z*v.y*(1-c) + v.x*s, c + v.z*v.z*(1-c), 0.0},
      {0.0, 0.0, 0.0, 1.0}};
  }

  float[][] getTranslationMatrix(PVector v1, PVector v2) {
    return new float[][] {{1.0, 0.0, 0.0, v2.x-v1.x},
      {0.0, 1.0, 0.0, v2.y-v1.y},
      {0.0, 0.0, 1.0, v2.z-v1.z},
      {0.0, 0.0, 0.0, 1.0}};
  }

  float[][] getScaleMatrix(float wheelCount) {
    float temp = 10.0;
    return new float[][] {{exp(-wheelCount/temp), 0.0, 0.0, 0.0},
      {0.0, exp(-wheelCount/temp), 0.0, 0.0},
      {0.0, 0.0, exp(-wheelCount/temp), 0.0},
      {0.0, 0.0, 0.0, 1.0}};
  }

  PVector mouseOnSphere(float x, float y) {
    float _x = x/radius;
    float _y = y/radius;
    PVector res = new PVector(_x, _y, 0.0);
    if (_x*_x + _y*_y > 1.0) {
      res.normalize();
    } else {
      res.z = sqrt(1.0 - _x*_x - _y*_y);
    }
    return res;
  }

  float[][] mult(float[][] m1, float[][] m2) {
    assert(m1[0].length == m2.length);
    float[][] res = new float[m1.length][m2[0].length];
    for (int i=0; i<m1.length; i++) {
      for (int j=0; j<m2[0].length; j++) {
        float sum = 0;
        for (int k=0; k<m1[0].length; k++) {
          sum += m1[i][k]*m2[k][j];
        }
        res[i][j] = sum;
      }
    }
    return res;
  }
}
