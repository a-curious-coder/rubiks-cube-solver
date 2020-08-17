// Round to the nearest half and return an exact value.
float roundToHalf(float d)  {
  return round(d * 2) / 2.0;
}
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
          qb.update(roundToHalf(qb.x), roundToHalf(matrix.m02), roundToHalf(matrix.m12));
          qb.turnFace(axis, dir);
        }
        break;
      case 'y':
        if (qb.y == index) {
          PMatrix2D matrix = new PMatrix2D();
          matrix.rotate(dir * HALF_PI);
          matrix.translate(qb.x, qb.z);
          qb.update(roundToHalf(matrix.m02), roundToHalf(qb.y), roundToHalf(matrix.m12));
          qb.turnFace(axis, dir);
        }
        break;
      case 'z':
        if (qb.z == index)  {
          PMatrix2D matrix = new PMatrix2D();
          matrix.rotate(dir * HALF_PI);
          matrix.translate(qb.x, qb.y);
          qb.update(roundToHalf(matrix.m02), roundToHalf(matrix.m12), roundToHalf(qb.z));
          qb.turnFace(axis, dir);
        }
        break;
    }
  }
}
