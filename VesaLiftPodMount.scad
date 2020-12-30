include <roundedcube.scad>;
include <washing.scad>;
include <shortcuts.scad>;

/* [VESA Mount] */

//Mount standard
Mount_Size = 100; // [ 100:100x100, 75:75x75 ]

// Height of the part of VESA plate outside the mount (mm)
External_VESA_Plate_Height = 5;  
// Height of the part of VESA plate inside the mount - provides more rigidity (mm)
Internal_VESA_PlateHeight = 3;

// VESA mount screw thread diameter (mm)
Screw_Thread_Diameter = 7; 

// VESA mount screw Head or Washer diameter (mm)
Screw_Head_Diameter = 12;

// Height of the plate under the screw (mm)
Screw_plate_Thickness = 2;


/* [ General ] */

//Height of LiftPod plate (without height of the sockets)
LiftPod_Plate_Size = 5;

// Size of the cutout in the center of the Mount - reduces required matrial
Center_Cutout_Size = 94;

// ------------------------------------------------------
/* [ Hidden ] */
mount = Mount_Size;

vesa_h = External_VESA_Plate_Height + Internal_VESA_PlateHeight; 
lift_pod_h = Internal_VESA_PlateHeight;

screw_size = Screw_Thread_Diameter; 
screw_head_size = Screw_Head_Diameter;
screw_plate_h = Screw_plate_Thickness;

cutout = Center_Cutout_Size;

module Vesa(mount, h, lift_pod_h, inside_cutout){
    plate_size = 125;

    vesa_h = h-lift_pod_h;
    module mount_holes(mount = mount, d, h, z = 0){
        t([-mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([-mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
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
            tz(vesa_h/2+lift_pod_h/2) roundedcube([mount+15,mount+15,vesa_h+lift_pod_h], true, radius = 3);
            
            //Bars Mount Plate
            //tz(lift_pod_h/2+vesa_h-0.001) roundedcube([plate_size, plate_size, lift_pod_h], true, radius = 5);

            tz(bars_z) tx(socket_position) mounting_bar();
            tz(bars_z) tx(-socket_position) mounting_bar();
            
            tz(bars_z) ty(socket_position) rz(90) mounting_bar();
            tz(bars_z) ty(-socket_position) rz(90) mounting_bar();

            tz(vesa_h+lift_pod_h/2) {
                ty(-socket_position) bar_support(lift_pod_h, (200-socket_d), plate_size);
                ty(socket_position)  bar_support(lift_pod_h, (200-socket_d), plate_size);
                rz(90) {
                    ty(-socket_position) bar_support(lift_pod_h, (200-socket_d), plate_size);
                    ty(socket_position) bar_support(lift_pod_h, (200-socket_d), plate_size);
                }
            }
        }

        // external_cutout = 94;
        roundedcube([cutout,cutout,(vesa_h+lift_pod_h+socket_d)*2], true, radius = 10);
        mount_holes(mount, screw_size, h=100, z=-10);
        mount_holes(mount, screw_head_size, h=100, z=screw_plate_h);
    }
}

cut = 400;
difference(){
    Vesa(mount, vesa_h, lift_pod_h, cutout);
  
    // t([0,-cut/2,-10]) cube([cut, cut, 50]);
    // t([-cut/2,0,-10]) cube([cut, cut, 50]);
}
