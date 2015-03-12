radius = 175;
height = 1150;
profileWidth = 30;

hex_side_length = 2 * radius / sqrt(3);
//hex_side_length = 150;
hex_side_length_rod_offset = 30 + 7.073; //just to get nice size
hex_side_length_joint_offset = 15;
bottom_profile_distance = 30;
result_hex_side_length = hex_side_length - hex_side_length_rod_offset - hex_side_length_joint_offset;

nema_shaft = 25;
pulley_offset = 1;
mgn12h_height = 13;

carriage_tickness = 8;

belt_from_rail = mgn12h_height + carriage_tickness;

rack_offset = 45;
top_center_offset = 20;

module plate() {
	hull() {
		square(30, center=true);
		for (i = [1,-1]) translate([ rack_offset - (radius / cos(30)- radius) + profileWidth * 0.5  ,0 , 0])  rotate([0,0,60*i]) translate([50,0 ,0]) square(30, center=true);
		
	}
}

plate();
echo(radius / cos(30)- radius);