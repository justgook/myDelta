hotend_type = "jhead"; //["jhead":j-head, "e3d":E3D]
fan_size = 30; // [20:20mm, 25:25mm ,30:30mm,40:40mm,50:50mm]
fan_adapter = 40; // [0:None,20:20mm, 25:25mm ,30:30mm,40:40mm,50:50mm]



//http://www.tridimake.com/2014/09/how-to-use-openscad-tricks-and-tips-to.html
$fa = 0.5; // default minimum facet angle is now 0.5
$fs = 0.5; // default minimum facet size is now 0.5 mm




//yaw roll pitch

module yaw(a) { rotate([0,0,a]) children(); }
module roll(a) { rotate([0,a,0]) children(); }
module pitch(a) { rotate([a,0,0]) children(); }
module x(p) { translate([p,0,0]) children(); }
module y(p) { translate([0,p,0]) children(); }
module z(p) { translate([0,0,p]) children(); }

module effector(mount_height = 4.8, mount_width = 16, mount_groove_height = 4.6, mount_groove_width = 12, heat_sink_width = 16, heat_sink_offset = 0, hot_end_height = 40, fan_size = 30, fan_adapter = 40) {

    cut = 1;

    mount_bottom_possition = hot_end_height - mount_height;
    grove_bottom_possition = hot_end_height - mount_height - mount_groove_height;
    heat_sink_top_possition = grove_bottom_possition - heat_sink_offset;

    shell_width = 3;
    ribs_width = 2;

    bolt_size = 3;
    bolt_hole = bolt_size + 0.2;

    module hot_end() {
            union() {
                //base
                cylinder(h = hot_end_height, d = mount_groove_width);
                //mount-top
                translate([0, 0, mount_bottom_possition]) cylinder(h = mount_height, d = mount_width);
                //mount-botom
                if (heat_sink_offset > 0) {
                    translate([0, 0, heat_sink_top_possition]) cylinder(h = heat_sink_offset, d = mount_width);
                }
                //heat_sink
                cylinder(h = heat_sink_top_possition, d = heat_sink_width);
            }
        }
        //p - array possition clockwise top-left, s=fan size, h= height, d = diameter, $fn = count of ribs
    module fan_shafts(p = [1, 1, 1, 1], s = 30, h = 10, d = 2.8) {
        pArr = [
            [-1, 1],
            [1, 1],
            [1, -1],
            [-1, -1]
        ];
        distance = s / 2;
        for (i = [0: 3]) {
            if (p[i] > 0)
                translate([distance * pArr[i][0], distance * pArr[i][1], 0]) cylinder(d = d, h = h, center = true);
        }
    }
    module adapter() {
        thickness = 5;
        distatnce = 10;
        difference() {
            hull() {
                translate([0, 0, thickness / 2]) cube([fan_size + shell_width * 2, fan_size + shell_width * 2, thickness], center = true);
                translate([0, fan_adapter / 2 - fan_size / 2, thickness / 2 + thickness / 2 + distatnce]) cube([fan_adapter + shell_width * 2, fan_adapter + shell_width * 2, thickness], center = true);
            }
            hull() {
                translate([0, 0, thickness]) cylinder(d = fan_size, h = 1, center = true);
                translate([0, fan_adapter / 2 - fan_size / 2, thickness / 2 + distatnce]) cylinder(d = fan_adapter, h = 1, center = true);

            }
            translate([0, 0, thickness / 2 - cut / 2]) cylinder(d = fan_size, h = thickness + cut, center = true);

            translate([0, fan_adapter / 2 - fan_size / 2, thickness / 2 + thickness / 2 + distatnce]) cylinder(d = fan_adapter, h = thickness + cut, center = true);


        }
    }


    //spring_height = 3;
    //cylinder_heiht = mount_height + spring_height + mount_groove_height;

    module holder() {
        difference() {
            //part
        
            union() {
                    cylinder(d = mount_width + shell_width, h = mount_groove_height);

                    for (i = [-1, 1])
                        top_holes(i) {
                            cylinder(d = bolt_hole + shell_width, h = mount_groove_height);
                            //TODO find better width - check by increasing size of shell
                            cube_width = bolt_hole / 2 + shell_width;
                            translate([cube_width / 2 * -i, 0, mount_groove_height / 2]) cube([cube_width, bolt_hole + shell_width, mount_groove_height], center = true);
                        }

                }
            //bolts
            for (i = [-1, 1])
                    translate([(mount_groove_width / 2 + bolt_hole / 2 + shell_width / 4) * i, 0, mount_groove_height / 2]) pitch(90) cylinder(d = bolt_hole, h = mount_width + shell_width + cut, center = true);
            //center hole
            z( - cut / 2) cylinder(d = mount_groove_width, h = mount_groove_height + cut);
        }
    }

	module top_holes(i = 1){
		    vertical_bolt = mount_width / 2 + shell_width * 1.5 /*+ bolt_hole*/;
            translate([vertical_bolt * i, 0, 0 /* *2/2 */]) children();
	}

	function fan_mount_width(size) = size+shell_width*2;
	function mount_offest_center() = 15;
	function fan_degree() = [0,120,240];
	function fan_angle() = -asin(grove_bottom_possition / fan_mount_width(fan_size));

	module fan_mount(size, height) {
		//#cylinder(d=1,h=10);
		y(fan_mount_width(size)/2) difference(){
			z(height/2) cube([fan_mount_width(size),fan_mount_width(size),height],center=true);
			z(-cut/2) cylinder(d=size,h=height+cut);
		}
		
	}

	//2d cap coords 0-5 outside, 6-11 insede
	function removeMe (a) = [
					[
						sin(a-120)*mount_offest_center() +cos(a-120)* fan_mount_width(fan_size)/2 , 
						-cos(a-120) * mount_offest_center()+sin(a-120)* fan_mount_width(fan_size)/2
					],
					[
						sin(a) * mount_offest_center() - cos(a)* fan_mount_width(fan_size)/2, 
						-cos(a) * mount_offest_center() - sin(a)* fan_mount_width(fan_size)/2
					],
					[
						sin(a) * (mount_offest_center()+cos(fan_angle()) * fan_mount_width(fan_size)) -cos(a)* fan_mount_width(fan_size)/2,
						-cos(a) * (mount_offest_center()+cos(fan_angle()) * fan_mount_width(fan_size)) -sin(a)* fan_mount_width(fan_size)/2
					],
					[
						sin(a-120)*(mount_offest_center()+cos(fan_angle()) * fan_mount_width(fan_size)) +cos(a-120)* fan_mount_width(fan_size)/2 , 
						-cos(a-120) * (mount_offest_center()+cos(fan_angle()) * fan_mount_width(fan_size))+sin(a-120)* fan_mount_width(fan_size)/2
					]
				];


		
	function cap_points(i) = i%4;//removeMe([0,120,240][floor(i/2) % 3])[0];
echo(cap_points(1));
	

	module fan_mounts_positing(){
	//TODO find correct distatnce from center
		for (a=fan_degree()) yaw(180 + a) y(mount_offest_center()) pitch(fan_angle()) {
			fan_mount(fan_size, shell_width);	
		}
	}
	

   color([0.1, 0.8, 0.8]) hot_end();
    difference() {
            translate([0,0, grove_bottom_possition]) holder();
		translate([0,0, grove_bottom_possition]) for (i=[-1,1]) top_holes(i) z(- cut / 2 - shell_width) cylinder(d = bolt_hole, h = mount_groove_height + cut + shell_width*2);

        }

z(grove_bottom_possition){ 
fan_mounts_positing();
color([0.8,0.1,0.1]) polygon(points=[cap_points(0),cap_points(1),cap_points(6), cap_points(7)], paths=[[0,1,2,3]]);


}
        //adapter();
}


if (hotend_type == "jhead") {
    //jhead http://www.robotdigg.com/upload/attach/201403/03abbd02212ab86d0902692cacc37f9b.jpg

    mount_height = 4.8;
    mount_width = 16;
    mount_groove_height = 4.6;
    mount_groove_width = 12;

    heat_sink_width = 16;
    heat_sink_offset = 0;

    hot_end_height = 40;


    effector(mount_height, mount_width, mount_groove_height, mount_groove_width, heat_sink_width, heat_sink_offset, hot_end_height, fan_size, fan_adapter);
}