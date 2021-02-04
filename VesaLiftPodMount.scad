include <roundedcube.scad>;
include <washing.scad>;
include <shortcuts.scad>;

/* [VESA Mount] */

//Mount standard
Mount_Size = 100; // [ 100:100x100, 75:75x75 ]

// Height of the part of VESA plate outside the mount
External_Plate_Height = 5;  

// Height of the part of VESA plate inside the mount - provides more rigidity and which connects VESA Mount with sockets
Internal_Plate_Height = 3;

// VESA mount screw thread diameter
Screw_Thread_Diameter = 4.5; 

// VESA mount screw Head or Washer diameter
Screw_Head_Diameter = 12;

// Height of the plate under the screw
Screw_plate_Thickness = 2;

/* [General] */

// Size of the cutout in the center of the Mount - reduces required matrial
Center_Cutout_Size = 94;

// ------------------------------------------------------
mount = Mount_Size;

vesa_h = External_Plate_Height; 
lift_pod_h = Internal_Plate_Height;

screw_size = Screw_Thread_Diameter; 
screw_head_size = Screw_Head_Diameter;
screw_plate_h = Screw_plate_Thickness;

cutout = Center_Cutout_Size;

module Vesa(mount,  vesa_h, lift_pod_h, inside_cutout){
    socket_d = 20;     
    socket_w = 8;
    socket_position = (125-8)/2;
    plate_size = 125;

    bar_length = 200;

    module mount_holes(mount = mount, d, h, z = 0){
        t([-mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([-mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
    } 
    
    module mounting_bar(){
        hole_center = [0,socket_d/2,-0.001];
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

    module bar_support(h, top_w, bottom_w){
        trapezoid = [
            [   -top_w/2,  h/2],
            [-bottom_w/2, -h/2],
            [ bottom_w/2, -h/2],
            [    top_w/2,  h/2]
        ];
            
        rx(90) linear_extrude(height = socket_w, center = true, convexity = 10) polygon(trapezoid);
    }  

    bars_z = vesa_h+lift_pod_h+9.999;

    difference(){
        union(){
            //Vesa Plate
            tz(vesa_h/2) roundedcube([mount+15,mount+15,vesa_h], true, radius = 3);
            
            //Bars Mount Plate
            tz(lift_pod_h/2+vesa_h-0.001) roundedcube([plate_size, plate_size, lift_pod_h], center = true);

            //Mount Bars
            tz(bars_z) tx(socket_position) mounting_bar();
            tz(bars_z) tx(-socket_position) mounting_bar();
            
            tz(bars_z) ty(socket_position) rz(90) mounting_bar();
            tz(bars_z) ty(-socket_position) rz(90) mounting_bar();

            //Mount Bars Supports
            tz(vesa_h+lift_pod_h/2-0.001) {
                ty(-socket_position) bar_support(lift_pod_h, (bar_length-socket_d), plate_size);
                ty(socket_position)  bar_support(lift_pod_h, (bar_length-socket_d), plate_size);
                rz(90) {
                    ty(-socket_position) bar_support(lift_pod_h, (bar_length-socket_d), plate_size);
                    ty(socket_position) bar_support(lift_pod_h, (bar_length-socket_d), plate_size);
                }
            }
        }

        // Center cutout
        roundedcube([cutout,cutout,(vesa_h+lift_pod_h+socket_d)*2], true, radius = 10);
        
        // Vesa Mount holes
        mount_holes(mount, screw_size, h=100, z=-10);
        mount_holes(mount, screw_head_size, h=100, z=screw_plate_h);
    }
}

Vesa(mount, vesa_h, lift_pod_h, cutout);
