import 'dart:math';

import 'device.dart';

class SensorHandler {
  static final double EPSILON = 0.000001;

  var sensors = [
    [300.0, 300.0, null], // red
    [0.0, 300.0, null], // green
    [0.0, 0.0, null], // blue
    [300.0, 0.0, null] // pink
  ];

  double _distanceFormula(x1, x2, y1, y2){
    return (sqrt(((x1 - x2)*(x1 - x2)) + ((y1 - y2)*(y1 - y2)) ));
  }

  SensorHandler(Device device){
    for(int i = 0; i < this.sensors.length; i++){
      this.sensors[i][2] = _distanceFormula(device.x, this.sensors[i][0], device.y, this.sensors[i][1]);
    }
  }

  Iterable<double> approximateDevice(){
    double x0 = sensors[0][0];
    double y0 = sensors[0][1];
    double r0 = sensors[0][2];
    double x1 = sensors[1][0];
    double y1 = sensors[1][1];
    double r1 = sensors[1][2];
    double x2 = sensors[2][0];
    double y2 = sensors[2][1];
    double r2 = sensors[2][2];
    double a, dx, dy, d, h, rx, ry;
    double point2_x, point2_y;

    /* dx and dy are the vertical and horizontal distances between
    * the circle centers.
    */
    dx = x1 - x0;
    dy = y1 - y0;

    /* Determine the straight-line distance between the centers. */
    d = sqrt((dy*dy) + (dx*dx));

    /* Check for solvability. */
    if (d > (r0 + r1))
    {
        /* no solution. circles do not intersect. */
        return null;
    }
    if (d < (r0 - r1).abs())
    {
        /* no solution. one circle is contained in the other */
        return null;
    }

    /* 'point 2' is the point where the line through the circle
    * intersection points crosses the line between the circle
    * centers.
    */

    /* Determine the distance from point 0 to point 2. */
    a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

    /* Determine the coordinates of point 2. */
    point2_x = x0 + (dx * a/d);
    point2_y = y0 + (dy * a/d);

    /* Determine the distance from point 2 to either of the
    * intersection points.
    */
    h = sqrt((r0*r0) - (a*a));

    /* Now determine the offsets of the intersection points from
    * point 2.
    */
    rx = -dy * (h/d);
    ry = dx * (h/d);

    /* Determine the absolute intersection points. */
    double intersectionPoint1_x = point2_x + rx;
    double intersectionPoint2_x = point2_x - rx;
    double intersectionPoint1_y = point2_y + ry;
    double intersectionPoint2_y = point2_y - ry;

    // Log.d("INTERSECTION Circle1 AND Circle2:", "(" + intersectionPoint1_x + "," + intersectionPoint1_y + ")" + " AND (" + intersectionPoint2_x + "," + intersectionPoint2_y + ")");

    /* Lets determine if circle 3 intersects at either of the above intersection points. */
    dx = intersectionPoint1_x - x2;
    dy = intersectionPoint1_y - y2;
    double d1 = sqrt((dy*dy) + (dx*dx));

    dx = intersectionPoint2_x - x2;
    dy = intersectionPoint2_y - y2;
    double d2 = sqrt((dy*dy) + (dx*dx));

    if((d1 - r2).abs() < EPSILON && intersectionPoint1_x >= 0 && intersectionPoint1_y >= 0) {
      return [intersectionPoint1_x, intersectionPoint1_y];
    }
    else if((d2 - r2).abs() < EPSILON && intersectionPoint2_x >= 0 && intersectionPoint2_y >= 0) {
      return [intersectionPoint2_x, intersectionPoint2_y];
    }
    
    return null;
  }
}
