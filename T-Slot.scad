/** 
 * @file
 * Generic library for fractional T-Slot extrusions.
 *
 * Creative Commons Share Alike 3.0
 * Copyright (c) 3014 Manuel García
 *
 * Original library (David Lee Miller)
 * https://www.thingiverse.com/thing:136430
 */ 

ProfileCore = 4.3;     // Profile core Ø (Default M5).
minkR_TS = 0.04 * 30;  // Minkowski radius for the T-Slot.
minkR_IC = 0.075 * 30; // Minkowski radius for the inner cutout.
minkR_PF = 0.05 * 30;  // Minkowski radius for the profile corners.

//3030Profile(100);
//3040Profile(100);
//3060Profile(100);
//3080Profile(100);
//4040Profile(100);
//4060Profile(100);
//4080Profile(100);

module fillet(rad) {
  translate([-rad, -rad, 0])
  difference() {
    translate([0, 0, 0]) square([rad + 0.01, rad + 0.01]);
    circle(r = rad, center = true, $fn = 32);
  }
}

module insideCutout() {
  minkowski() {
    translate([0, 0, 0]) circle(r = minkR_IC, center = true, $fn = 32);
    hull() {
      square([0.2 * 30 - minkR_IC, 0.645 * 30 - 2 * minkR_IC], center = true);
      square([0.8 * 30 - 2 * minkR_IC, 0.001 * 30], center = true);
    }
  }
}

module doubleCutout() {
  union() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_IC, center = true, $fn = 32);
      union() {
        rotate([0, 0, 0]) hull() {
          translate([-0.5 * 30, 0, 0]) hull() {
            square([0.2 * 30 - minkR_IC, 0.645 * 30 - 2 * minkR_IC], center = true);
            square([0.8 * 30 - 2 * minkR_IC, 0.001 * 30], center = true);
          }
          translate([0.5 * 30, 0, 0]) hull() {
            square([0.2 * 30 - minkR_IC, 0.645 * 30 - 2 * minkR_IC], center = true);
            square([0.8 * 30 - 2 * minkR_IC, 0.001 * 30], center = true);
          }
        }
        rotate([0, 0, 90]) hull() {
          translate([-0.5 * 30, 0, 0]) hull() {
            square([0.2 * 30 - minkR_IC, 0.645 * 30 - 2 * minkR_IC], center = true);
            square([0.8 * 30 - 2 * minkR_IC, 0.001 * 30], center = true);
          }
          translate([0.5 * 30, 0, 0]) hull() {
            square([0.2 * 30 - minkR_IC, 0.645 * 30 - 2 * minkR_IC], center = true);
            square([0.8 * 30 - 2 * minkR_IC, 0.001 * 30], center = true);
          }
        }
      }
    }
    rotate([0, 0, 0]) translate([-0.645 * 30 / 2, -0.645 * 30 / 2, 0]) fillet(minkR_IC);
    rotate([0, 0, 180]) translate([-0.645 * 30 / 2, -0.645 * 30 / 2, 0]) fillet(minkR_IC);
    rotate([0, 0, 90]) translate([-0.645 * 30 / 2, -0.645 * 30 / 2, 0]) fillet(minkR_IC);
    rotate([0, 0, -90]) translate([-0.645 * 30 / 2, -0.645 * 30 / 2, 0]) fillet(minkR_IC);
  }
}

module tSlot() {
  union() {
    translate([minkR_TS, 0, 0])
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_TS, center = true, $fn = 32);
      hull() {
        square([0.001 * 30, 0.585 * 30 - 2 * minkR_TS], center = true);
        translate([(0.233 * 30 - 2 * minkR_TS) / 2, 0, 0]) square([0.233 * 30 - 2 * minkR_TS, 0.2 * 30], center = true);
      }
    }
    translate([-0.255 * 30 / 2 + 0.01, 0, 0]) square(0.255 * 30, center = true);
    translate([-0.35 * 30 / 2 - 0.087 * 30 + 0.01, 0, 0]) square(0.35 * 30, center = true);
    translate([0, -0.255 * 30 / 2, 0]) fillet(minkR_TS / 2);
    translate([-0.087 * 30, -0.255 * 30 / 2, 0]) rotate([0, 0, 90]) fillet(minkR_TS / 2);
    scale([1, -1, 1]) translate([0, -0.255 * 30 / 2, 0]) fillet(minkR_TS / 2);
    scale([1, -1, 1]) translate([-0.087 * 30, -0.255 * 30 / 2, 0]) rotate([0, 0, 90]) fillet(minkR_TS / 2);
  }
}

module 3030Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  union() {
    difference() {
      minkowski() {
        translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
        square([1 * 30 - 2 * minkR_PF, 1 * 30 - 2 * minkR_PF], center = true);
      }
      translate([0, 0, 0]) circle(r = core / 2, $fn = 24);
      translate([-0.5 * 30 + 0.087 * 30, 0, 0]) tSlot();
      rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 0, 0]) tSlot();
      translate([0, -0.5 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
      translate([0, 0.5 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    }
  }
}

module 3040Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([1 * 30 - 2 * minkR_PF, 2 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0, 0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, -0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0, 0]) insideCutout();
    translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    translate([0, -1 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
    translate([0, 1 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}

module 3060Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([1 * 30 - 2 * minkR_PF, 3 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0, 0, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, -1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, -0.5 * 30, 0]) insideCutout();
    translate([0, 0.5 * 30, 0]) insideCutout();
    translate([-0.5 * 30 + 0.087 * 30, 0, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 0, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, 1 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 1 * 30, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, -1 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, -1 * 30, 0]) tSlot();
    translate([0, -1.5 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
    translate([0, 1.5 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}

module 3080Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([1 * 30 - 2 * minkR_PF, 4 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0, 0.5 * 30 + 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0.5 * 30 + 30 - 1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0.5 * 30 + 30 - 2 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0.5 * 30 + 30 - 3 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0.5 * 30 + 30 - 0.5 * 30, 0]) insideCutout();
    translate([0, 0, 0]) insideCutout();
    translate([0, -(0.5 * 30 + 30) + 0.5 * 30, 0]) insideCutout();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, -(0.5 * 30 + 30), 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, -(0.5 * 30), 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30 + 30, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30 + 30, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, -(0.5 * 30), 0]) tSlot();
    translate([-0.5 * 30 + 0.087 * 30, -(0.5 * 30 + 30), 0]) tSlot();
    translate([0, -2 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
    translate([0, 2 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}

module 4040Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([2 * 30 - 2 * minkR_PF, 2 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0.5 * 30, 0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, 0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, -0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, -0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 0, 0]) doubleCutout();
    translate([-1 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    translate([-0.5 * 30, 1 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30, 1 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    translate([0.5 * 30, 1 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    rotate([0, 0, 180]) translate([0.5 * 30, 1 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}

module 4060Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([2 * 30 - 2 * minkR_PF, 2 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0.5 * 30, 1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, 1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, 0, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, 0, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, -1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, -1 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-1 * 30 / 2, 1 * 30 / 2, 0]) insideCutout();
    translate([0, 2 * 30 / 2, 0]) rotate([0, 0, -90]) insideCutout();
    translate([1 * 30 / 2, 1 * 30 / 2, 0]) insideCutout();
    translate([0, -30 / 2, 0]) doubleCutout();
    translate([-1 * 30 + 0.087 * 30, 1 * 30, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, 0, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, -1 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, 1 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, 0, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, -1 * 30, 0]) tSlot();
    translate([-1 * 30 / 2, -1.5 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
    translate([1 * 30 / 2, -1.5 * 30 + 0.087 * 30, 0]) rotate([0, 0, 90]) tSlot();
    translate([-1 * 30 / 2, 1.5 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    translate([1 * 30 / 2, 1.5 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}

module 4080Profile(height, core = ProfileCore) {
  linear_extrude(height = height, center = true)
  difference() {
    minkowski() {
      translate([0, 0, 0]) circle(r = minkR_PF, center = true, $fn = 32);
      square([2 * 30 - 2 * minkR_PF, 4 * 30 - 2 * minkR_PF], center = true);
    }
    translate([0.5 * 30, 1.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, 1.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, 0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, 0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, -1.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, -1.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0.5 * 30, -0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([-0.5 * 30, -0.5 * 30, 0]) circle(r = core / 2, $fn = 24);
    translate([0, 1 * 30, 0]) doubleCutout();
    translate([0, -1 * 30, 0]) doubleCutout();
    translate([0.5 * 30, 0, 0]) insideCutout();
    translate([-0.5 * 30, 0, 0]) insideCutout();
    translate([-1 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, 0.5 * 30, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, -0.5 * 30, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, 1.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, 1.5 * 30, 0]) tSlot();
    translate([-1 * 30 + 0.087 * 30, -1.5 * 30, 0]) tSlot();
    rotate([0, 0, 180]) translate([-1 * 30 + 0.087 * 30, -1.5 * 30, 0]) tSlot();
    translate([-0.5 * 30, 2 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    rotate([0, 0, 180]) translate([-0.5 * 30, 2 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    translate([0.5 * 30, 2 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
    rotate([0, 0, 180]) translate([0.5 * 30, 2 * 30 - 0.087 * 30, 0]) rotate([0, 0, -90]) tSlot();
  }
}
