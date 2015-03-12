use <T-Slot.scad>;

radius = 175;
height = 1150;
profileWidth = 30;

hex_side_length = 2 * radius / sqrt(3);
//hex_side_length = 150;
hex_side_length_rod_offset = 30 + 7.073; //just to get nice size
hex_side_length_joint_offset = 15;
bottom_profile_distance = 30;
result_hex_side_length = hex_side_length - hex_side_length_rod_offset - hex_side_length_joint_offset;
//result_hex_side_length = 300;

nema_shaft = 25;
pulley_offset = 1;
mgn12h_height = 13;

carriage_tickness = 8;

belt_from_rail = mgn12h_height + carriage_tickness;

rack_offset = 45;
top_center_offset = 20;

use <MCAD/motors.scad>;

    //function get_coords(angle, distance) = [cos(angle)*distance, sin(angle)*distance];
use <nut.scad>;
module joint_cut(){
     nut_height = 9.3;
    translate([-20, 0, profileWidth / 2 - nut_height / 2 + 0.5]) nut();
     translate([-20, 0, -profileWidth / 2 + nut_height / 2 - 1.6]) rotate([0, 180, 0]) nut();
    rotate([90, 0, 0]) {
      translate([-20, 0, profileWidth / 2 - nut_height / 2 + 1]) nut();
      translate([-20, 0, -profileWidth / 2 + nut_height / 2 - 1]) rotate([0, 180, 0]) nut();
    }
}
 module hex_joint(top = true) {
     difference() {
             rotate([0, 0, -120]) translate([-(cos(120) * 30) / 2, 0, 0]) cube([sin(120) * profileWidth, 43, profileWidth], center = true);
		for (i = [0,13])
		{
rotate([0, 0, -120])  translate([i,0,0])  {
			cylinder(d=4.1,h=profileWidth + 0.5, $fn=20, center=true);
	if(top){
			translate([0,0,+profileWidth/2-5.5+0.1]) cylinder(d=8,h=11+0.2, $fn=32, center=true);

			rotate([0,0,30]) translate([0,0,-profileWidth/2+1.5-0.1]) cylinder(d=8,h=3, $fn=32, center=true);
	} else {
			rotate([0,0,30]) translate([0,0,-profileWidth/2+3.5-0.1]) cylinder(d1=7.66*1.1,d2=7.66,h=7, $fn=6, center=true);
			translate([0,0,+profileWidth/2-1.5+0.1]) cylinder(d=8,h=3, $fn=32, center=true);
}

		}
		}

		
         for (i = [0, -240]) {
             rotate([0, 0, i]) {
                 translate([-result_hex_side_length / 2 - 15, 0, 0]) cube([result_hex_side_length, profileWidth * 3, profileWidth * 3], center = true);
             }
         }

     }
difference(){
     for (i = [0, -240])  rotate([0, 0, i])joint_cut();
     rotate([0, 0, -120]) translate([-(cos(120) * 30) / 2 - sin(120) * profileWidth, 0, 0]) cube([sin(120) * profileWidth, 43, profileWidth], center = true);
}

 }

module perimeter(top=false) {
    for (a = [0, 60, 120, 180, 240, 300]) {
        direction = a % 120 / -30 + 1;
        rotate([0, 0, a])
        translate([0, radius, 0])
            //MOVE for rod away
        translate([(hex_side_length_rod_offset - hex_side_length_joint_offset) * direction / 2, 0, 0]) {
            if (direction > 0) {
                translate([result_hex_side_length / 2 + hex_side_length_joint_offset, 0, 0]) color([0.3,0.3,0.3]) hex_joint(top);
            }
            rotate([0, 90, 0]) %3030Profile(result_hex_side_length);
//	     #cube(40, center = true);
        }
    }

}


translate([0, 0, profileWidth * 0.5]) perimeter(false);
translate([0, 0, bottom_profile_distance + profileWidth * 1.5]) perimeter(true);


centerRod = radius + rack_offset - top_center_offset;
use <plates.scad>;
for (a = [0, 120, 240]) {
    rotate([0, 0, a + 30]) translate([0, radius + rack_offset + profileWidth / 2, height / 2]) {
        translate([0, 0, height / 2 - profileWidth / 2]) rotate([90, 0, 0]) translate([0, 0, centerRod / 2 + profileWidth / 2]) color([0.8, 0.8, 0.8]) %3030Profile(centerRod);
        color([0.8, 0.8, 0.8]) %3030Profile(height);
	//translate([0, -22.5 -15, -height / 2 +70]) #cube(5, center=true);
        translate([0, -profileWidth / 2 - nema_shaft - belt_from_rail - pulley_offset, -(height / 2 - profileWidth / 2)]) rotate([90, 0, 180]) stepper_motor_mount(17);

        // plates
	translate([0,0,-height / 2]) #rotate([0,0,-90]) plate();

    }
}

echo("Top rod x 3", centerRod);
echo("Side rods x 12 ", result_hex_side_length);
echo("vertival rods x 3", height);


translate([0, 0, bottom_profile_distance + profileWidth * 2 + 2]) %cylinder(r = radius, h = 4, center = true, $fn = 256);