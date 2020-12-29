include <roundedcube.scad>;
include <washing.scad>;
include <shortcuts.scad>;

/*[VESA Mount] */
mount = 100; // [ 100:100x100, 75:75x75 ]
vesa_h = 5;  // Height of VESA plate in mm
screw_size = 7; 
screw_head_size = 12;

cutout = 94;  // [ 10 : 5 : 95 ]

lift_pod_h = 5;
plate_size = mount + 25;
vesa_screw_plate_h = 2;

module Vesa(mount = 100, vesa_h, lift_pod_h, inside_cutout = 65){

    module mount_holes(mount = mount, d, h, z = 0){
        translate([-mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        translate([ mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        translate([-mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        translate([ mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
    } 
    
    socket_d = 20;     
    socket_w = 8;
    socket_position = (125-8)/2;

    module mounting_bar(){
        hole_center = [0,socket_d/2,-0.001];
        bar_length = 200;
        block_size = [socket_w, bar_length, socket_d];
        
        ry(90) difference(){
            roundedcube([block_size.z, block_size.y, block_size.x], radius = 10, center=true);
            ty((bar_length-socket_d)/2) socket();
            ty(-(bar_length-socket_d)/2) socket();
        }
    }

    //hole and locking drilling
    module socket(w = socket_w){
        cylinder(r=5, h=100, center=true);
        tz(-w/2-0.01) chopperWheel(od=17.5, id=11.5, t=0.6, nSlots=16, MSR = 1/1.75);
        tz(+w/2+0.01) rx(180) chopperWheel(od=17.5, id=11.5, t=0.6, nSlots=16, MSR = 1/1.75);
    }
    

    bars_z = vesa_h+lift_pod_h+9.999;

    difference(){
        union(){
            //Vesa Plate
            tz(vesa_h/2) roundedcube([mount+15,mount+15,vesa_h], true, radius = 3);
            
            //Bars Mount Plate
            tz(lift_pod_h/2+vesa_h-0.001) roundedcube([plate_size, plate_size, lift_pod_h], true, radius = 5);

            tz(bars_z) tx(socket_position) mounting_bar();
            tz(bars_z) tx(-socket_position) mounting_bar();
            
            tz(bars_z) ty(socket_position) rz(90) mounting_bar();
            tz(bars_z) ty(-socket_position) rz(90) mounting_bar();
        }

        // external_cutout = 94;
        roundedcube([cutout,cutout,(vesa_h+lift_pod_h+socket_d)*2], true, radius = 10);
        mount_holes(mount, screw_size, h=100, z=-10);
        mount_holes(mount, screw_head_size, h=100, z=2);
    }
}

cut = 400;
difference(){
    Vesa(mount, vesa_h, lift_pod_h, cutout);
  
    // translate([0,-cut/2,-10]) cube([cut, cut, 50]);
    // translate([-cut/2,0,-10]) cube([cut, cut, 50]);
}
