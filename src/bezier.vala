
namespace LiveChart { 
    const double POLYNOMIAL_TOLERANCE = 1e-6;

    //https://www.xarg.org/book/computer-graphics/line-segment-bezier-curve-intersection/
    public Gee.List<Coord?> find_intersections_between(Segment segment, BezierCurve bezier) {

        var ax = 3 * (bezier.c1.x - bezier.c2.x) + bezier.c3.x - bezier.c0.x;
        var ay = 3 * (bezier.c1.y - bezier.c2.y) + bezier.c3.y - bezier.c0.y;
        
        var bx = 3 * (bezier.c0.x - 2 * bezier.c1.x + bezier.c2.x);
        var by = 3 * (bezier.c0.y - 2 * bezier.c1.y + bezier.c2.y);
        
        var cx = 3 * (bezier.c1.x - bezier.c0.x);
        var cy = 3 * (bezier.c1.y - bezier.c0.y);
    
        var dx = bezier.c0.x;
        var dy = bezier.c0.y;
    
        var vx = segment.to.y - segment.from.y;
        var vy = segment.from.x - segment.to.x;
    
        var d = segment.from.x * vx + segment.from.y * vy;
    
        var roots = get_cubic_roots(
            vx * ax + vy * ay,
            vx * bx + vy * by,
            vx * cx + vy * cy,
            vx * dx + vy * dy - d
        );
        
        var results = new Gee.ArrayList<Coord?>();
        for (var i = 0; i < roots.size; i++) {
            var root = roots[i];
            if (0 > root || root > 1) continue;
            results.add({
                x: ((ax * root + bx) * root + cx) * root + dx,
                y: ((ay * root + by) * root + cy) * root + dy
            });
        }
       
        return results;
  }

  Gee.List<double?> get_cubic_roots(double C3, double C2, double C1, double C0) {

      var roots = new Gee.ArrayList<double?>();

      //
      var c3 = C3;
      var c2 = C2 / c3;
      var c1 = C1 / c3;
      var c0 = C0 / c3;
    
      var a       = (3 * c1 - c2 * c2) / 3;
      var b       = (2 * c2 * c2 * c2 - 9 * c1 * c2 + 27 * c0) / 27;
      var offset  = c2 / 3;
      var discrim = b * b / 4 + a * a * a / 27;
      var halfB   = b / 2;
      
      double tmp = 0;
      double root = 0;
      
      if (Math.fabs(discrim) <= POLYNOMIAL_TOLERANCE) { discrim = 0; }
      
      if (discrim > 0) {
        var e = Math.sqrt(discrim);
    
        tmp = -halfB + e;
        if ( tmp >= 0 ) { root = Math.pow(  tmp, 1/3); }
        else            { root = -Math.pow(-tmp, 1/3); }
    
        tmp = -halfB - e;
        if ( tmp >= 0 ) { root += Math.pow( tmp, 1/3); }
        else            { root -= Math.pow(-tmp, 1/3); }
      
        roots.add(root - offset);
      } else if (discrim < 0) {
        var distance = Math.sqrt(-a/3);
        var angle    = Math.atan2(Math.sqrt(-discrim), -halfB) / 3;
        var _cos      = Math.cos(angle);
        var _sin      = Math.sin(angle);
        var sqrt3    = Math.sqrt(3);
    
        roots.add( 2 * distance * _cos - offset);
        roots.add(-distance * (_cos + sqrt3 * _sin) - offset);
        roots.add(-distance * (_cos - sqrt3 * _sin) - offset);
      } else {
        if (halfB >= 0) { tmp = -Math.pow(halfB, 1/3); }
        else            { tmp =  Math.pow(-halfB, 1/3); }
    
        roots.add(2 * tmp - offset);
        // really should return next root twice, but we return only one
        roots.add(-tmp - offset);
      }

      return roots;
    }

}