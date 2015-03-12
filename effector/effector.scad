//import ("Effector_Ball_MK1.2.stl");
//translate([19.5,0,0]) #cube(40);
module tetra(d1 = 17, d2 = 14, h = 10) {
    translate([0, 0, -h / 2]) rotate([0, 0, 180])
    cylinder(d1 = sqrt(pow(d1, 2) * 4), d2 = sqrt(pow(d2, 2) * 4), h = h, $fn = 3);
}

module trapezoidal(d1, d2, h) {
    rotate([0, 0, 45])
    cylinder(d1 = sqrt(pow(d1, 2) * 2), d2 = sqrt(pow(d2, 2) * 2), h = h, $fn = 4);
}

module effector(fan_size = 40) {
    module mount() {
        rotate([90, 0, 0]) cylinder(h = 40, d = 6, $fn = 32, center = true);
    }




    //base
    module base() {
        difference() {
            tetra(d1 = 80, d2 = 80, h = 4);
            for (a = [0, 120, 240]) {
                rotate([0, 0, a + 60]) translate([90, 0, 0]) {
                    cylinder(d = 120, h = 5, center = true, $fn = 64);

                }
            }
        }
    }



    module top() {
        fan_angle = 15;
        module bolt_holes(d = 3.3, position = [], h = 5) {
            for (p = position) {
                translate([p[0] * 14, p[1] * 14, 0]) cylinder(d = d, h = h * 2, $fn = 20, center = true);
            }
        }



        difference() {
                translate([0, 0, 20]) rotate([0, 0, 120]) tetra(d1 = 60, d2 = 60 - sin(fan_angle) * 60, h = 40);

                //top big hole
                translate([0, 0, 40]) cylinder(d = 15, h = 10, center = true);
                //top small holes
                rotate([0, 0, 60]) translate([10 + 3.2 / 2, 0, 40]) cylinder(d = 3.2, h = 10, center = true, $fn = 20);
                rotate([0, 0, 60]) translate([-10 - 3.2 / 2, 0, 40]) cylinder(d = 3.2, h = 10, center = true, $fn = 20);
                //cutters small and big holes on sides
                for (a = [0, 120, 240]) {
                    rotate([fan_angle, 0, a - 30]) {

                        translate([0, 45, 0]) cube([40, 40, 80], true);

                        rotate([90, 0, 0]) translate([0, 15, -25]) {
                            //Big Hole
                            cylinder(d = 30, h = 10, center = true);
                            //Bolt Hole
                            if (a == 0)
                                bolt_holes(3.3, [
                                    [1, -1],
                                    [-1, -1]
                                ]);
                            if (a == 120)
                                bolt_holes(3.3, [
                                    [1, -1]
                                ]);
                            if (a == 240)
                                bolt_holes(3.3, [
                                    [-1, -1]
                                ]);

                        }
                    }
                }
            }
            //cooler shafts
        for (a = [0, 120, 240]) {
            rotate([fan_angle, 0, a - 30])
            rotate([90, 0, 0]) translate([0, 15, -25]) {
                //fanholders
                if (a == 0)
                    bolt_holes(2.8, [
                        [1, 1],
                        [-1, 1]
                    ], 3);
                if (a == 120)
                    bolt_holes(2.8, [
                        [1, 1],
                        [-1, 1],
                        [-1, -1]
                    ], 3);
                if (a == 240)
                    bolt_holes(2.8, [
                        [1, 1],
                        [1, -1],
                        [-1, 1]
                    ], 3);


            }
        }

    }


    module fan_ribs() {
module rib(){
        rotate([0, 0, -120]) {
            translate([-23.4, 17.75 - 1, -0.5])
            rotate([2, 0, -7.3]) {
                cube([10, 2, 41]);
                translate([44.7, 0, 0]) rotate([10.41, 0, 0]) cube([12, 2, 41]);
                translate([10, 0, 0])
                rotate([-90, 180, -90])
                linear_extrude(height = 44.7 - 10, convexity = 10, twist = -10.41, slices = 5)
                square([2, 41]);
                //#cube([44.7-10,2,41]);
            }
        }
}
rib();
rotate([0,0,120]) mirror([0,1,0]) rib();

    }

    module cuter() {
        fan_angle = 15;
        difference() {
            translate([0, 0, 20]) rotate([0, 0, 120]) tetra(d1 = 60, d2 = 60 - sin(fan_angle) * 60, h = 40);
            for (a = [0, 120, 240]) {
                rotate([fan_angle, 0, a - 30]) {
                    translate([0, 45, 0]) cube([40, 40, 80], true);
                }
            }
        }
    }


    module part_top() {

        difference() {
            union() {
                for (a = [0, 120, 240]) {
                    rotate([0, 0, a]) translate([40, 0, 0]) mount();
                }

                top();

                base();
            }
            translate([0, 0, -5]) cube([100, 100, 10.1], center = true);
            scale([54 / 60, 54 / 60, 54 / 60]) cuter();

        }
        intersection() {
            fan_ribs();
            cuter();
        }

    }


    //RENDER!!
    part_top();



}

effector();