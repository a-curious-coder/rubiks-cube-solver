
// axis, direction of turn, index: which side of axis to turn.
void turn(char axis, int dir, float index)  {
  for(int i = 0; i < cube.length; i++)  {
    Cubie qb = cube[i];
    switch (axis)  {
      case 'x':
        if (qb.x == index) {
          PMatrix2D matrix = new PMatrix2D();
          matrix.rotate(dir * HALF_PI);
          matrix.translate(qb.y, qb.z);
          qb.update(qb.x, round(matrix.m02), round(matrix.m12));
          qb.turnFace(axis, dir);
        }
        break;
      case 'y':
        if (qb.y == index) {
          PMatrix2D matrix = new PMatrix2D();
          matrix.rotate(dir * HALF_PI);
          matrix.translate(qb.x, qb.z);
          qb.update(round(matrix.m02), qb.y, round(matrix.m12));
          qb.turnFace(axis, dir);
        }
        break;
      case 'z':
        if (qb.z == index)  {
          PMatrix2D matrix = new PMatrix2D();
          matrix.rotate(dir * HALF_PI);
          matrix.translate(qb.x, qb.y);
          qb.update(round(matrix.m02), round(matrix.m12), qb.z);
          qb.turnFace(axis, dir);
        }
        break;
    }
  }
}

//void turnX(int index, int dir) {
//  for (int i = 0; i < cube.length; i++) {
//    Cubie qb = cube[i];
    //if (qb.x == index) {
    //  PMatrix2D matrix = new PMatrix2D();
    //  matrix.rotate(dir*HALF_PI);
    //  matrix.translate(qb.y, qb.z);
    //  qb.update(round(qb.x), round(matrix.m02), round(matrix.m12));
    //  qb.turnFacesX(dir);
    //}
//  }
//}

//void turnY(int index, int dir) {
//  for (int i = 0; i < cube.length; i++) {
//    Cubie qb = cube[i];
//    if (qb.y == index) {
//      PMatrix2D matrix = new PMatrix2D();
//      matrix.rotate(dir*HALF_PI);
//      matrix.translate(qb.x, qb.z);
//      qb.update(round(matrix.m02), round(qb.y), round(matrix.m12));
//      qb.turnFacesY(dir);
//    }
//  }
//}

//void turnZ(int index, int dir) {
//  for (int i = 0; i < cube.length; i++) {
//    Cubie qb = cube[i];
//    if (qb.z == index) {
//      PMatrix2D matrix = new PMatrix2D();
//      matrix.rotate(dir*HALF_PI);
//      matrix.translate(qb.x, qb.y);
//      qb.update(round(matrix.m02), round(matrix.m12), round(qb.z));
//      qb.turnFacesZ(dir);
//    }
//  }
//}
