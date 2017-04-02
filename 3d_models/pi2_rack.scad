//preview[view:east, tilt:top]

/* A remix of http://www.thingiverse.com/thing:664343 designed to:
   - put boards upright and hold them in place
   - provide minimal convection airflow
   - provide some headroom to prevent bumping the Micro SD card */

/* [Global] */
//how many raspis to stack on each other
rack_height=5; //[1:10]


/* [Hidden] */
rpi_width=57.5;
rpi_length=87;
u_height=23;
wall=2;
ledge=2;
port_height=11;
port_len=61;

module rack_side(){
    translate([0,-3*wall,-wall])
        cube([rpi_width+2*wall,rpi_length+wall*4,wall]);
}

module one_u(){
    difference(){
        translate([0,-wall*3,0])
            cube([rpi_width+2*wall,rpi_length+wall*4,u_height]);

        // cut out main area
        translate([wall,-wall*5,wall])
            cube([rpi_width,rpi_length+wall*4,u_height]);
        //cut floor
        translate([wall+ledge,-wall*4,-wall])
            cube([rpi_width-2*ledge,rpi_length+wall*3,3*wall]);
        //back
        translate([wall+1,rpi_length-2*wall,ledge+1])
            cube([rpi_width-2,5*wall,u_height-1-2*wall]);
        //top ports
        translate([rpi_width,-wall*4,wall])
            cube([5*wall,port_len+wall*4,port_height]);
        //power plug clearance
        translate([rpi_width-wall,wall*3,-wall])
            cube([4*wall,wall*7,port_height-wall*2]);
        //bottom ports
        translate([-wall,wall*2,wall*3])
            cube([3*wall,port_len-wall*3,port_height]);
        // remove leading edge of rails
        translate([wall,-wall*4,-wall])
            cube([rpi_width,wall*2,u_height]);
    }
}

module board_clips(index) {
    translate([0,wall,wall*1.2])
        difference(){
            union() {
                cube([2*wall,2*wall,2*wall]);
                if(index>1) {/* remove top clip so board will slide in */
                    translate([rpi_width,0,-wall])
                        cube([2*wall,2*wall,3*wall]);
                	    // breakaway support
	                translate([rpi_width+wall,wall*2-0.4,-wall*2])
    		                cube([wall,0.4,u_height]);
                }
                translate([0,rpi_length-wall*3,0])
                    cube([2*wall,2*wall,2*wall]);
                translate([rpi_width,rpi_length-wall*3,0])
                    cube([2*wall,2*wall,2*wall]);
            }
            translate([0,-wall,-0.4])
                cube([rpi_width+wall,rpi_length+2*wall,wall*1.2]);
        }
}

module raspi_rack(){
    rack_side();
    for(i=[1:rack_height]){
        translate([0,0,(i-1)*u_height])
            one_u();
        translate([0,0,(i-1)*u_height])
            board_clips(i);
    }
    // mirror side
    translate([0,0,rack_height*u_height])
        rack_side();
    // feet
    translate([-wall*2,wall,u_height/2+wall*4])
        cube([3*wall,4*wall,4*wall]);
    translate([-wall*2,rpi_length-4*wall,wall*2])
        cube([3*wall,4*wall,4*wall]);
    translate([0,0,rack_height*u_height-wall*13]){
        translate([-wall*2,wall,-wall])
            cube([3*wall,4*wall,4*wall]);
        translate([-wall*2,rpi_length-4*wall,u_height/2])
            cube([3*wall,4*wall,4*wall]);
    }
    // adhesion pads to prevent warping
    translate([-wall*4,rpi_length+wall-0.2,-wall*5])
        cube([10,0.2,10]);
    translate([rpi_width+wall,rpi_length+wall-0.2,-wall*5])
        cube([10,0.2,10]);
	translate([0,0,rack_height*u_height+wall*4]) {
    		translate([-wall*4,rpi_length+wall-0.2,-wall*5])
            cube([10,0.2,10]);
    		translate([rpi_width+wall,rpi_length+wall-0.2,-wall*5])
            cube([10,0.2,10]);
    }
    
}

//rotate & center
translate([(rack_height*u_height)/2,-(rpi_width+2*wall)/2,rpi_length+wall])
    rotate([-90,0,90])
        raspi_rack();
