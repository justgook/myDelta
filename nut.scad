nut_size = 6.01;
bolt_d = 3.5;
top_width = 8;
top_height = 2;//2
width = 13.3;//13.5
height = 9.1;//9.5
length = 15;
bottom_edge_cut = 3;
nut_depth = 4;



module trapezoid(width_base, width_top, height, thickness, center = true) {
  linear_extrude(height = thickness) polygon(points=[[0,0],[width_base,0],[width_base-(width_base-width_top)/2,height],[(width_base-width_top)/2,height]], paths=[[0,1,2,3]]); 
  
}

module nut(){
difference(){
	union(){
		translate([0,0,(height - bottom_edge_cut - top_height)/2]) cube([length, top_width, top_height], true);
		translate([0,0,-top_height/2]) cube([length, width, height - bottom_edge_cut - top_height], true);
		translate([-length/2,-width/2 + bottom_edge_cut , -height/2- bottom_edge_cut/2]) rotate([90,0,90]) trapezoid(width - bottom_edge_cut*2, width, bottom_edge_cut, length);
	}
cylinder(center=true,$fn=20, d=bolt_d, h= height+bottom_edge_cut+0.1);
translate([0,0,-height/2-bottom_edge_cut/2 + nut_depth/2]) cylinder(center=true, $fn=6,d1=nut_size*1.1, d2=nut_size, h=nut_depth+0.1);
}
}
nut();