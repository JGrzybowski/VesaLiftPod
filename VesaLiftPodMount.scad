include <lib/LiftPod.scad>;
include <lib/roundedcube.scad>;
include <lib/lockingSlot.scad>;
include <lib/shortcuts.scad>;

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

// Should LiftPod mounts have additional support(angle depends on the height of the external plate)
Support_Bars = true; //[on:true, off:false]

// ------------------------------------------------------
mount = Mount_Size;

vesa_h = External_Plate_Height; 
lift_pod_h = Internal_Plate_Height;

screw_size = Screw_Thread_Diameter; 
screw_head_size = Screw_Head_Diameter;
screw_plate_h = Screw_plate_Thickness;

cutout = Center_Cutout_Size;

module Vesa(mount,  vesa_h, lift_pod_h, inside_cutout){
    plate_size = 125;
    bar_length = 200;

    module mount_holes(mount = mount, d, h, z = 0){
        t([-mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2, -mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([-mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
        t([ mount/2,  mount/2, z+h/2]) cylinder(d = d, h = h, center = true);
    }

    module bar_support(h, top_w, bottom_w){
        trapezoid = [
            [   -top_w/2,  h/2],
            [-bottom_w/2, -h/2],
            [ bottom_w/2, -h/2],
            [    top_w/2,  h/2]
        ];
            
        rx(90) linear_extrude(height = Socket_w, center = true, convexity = 10) polygon(trapezoid);
    }  

    bars_z = vesa_h+lift_pod_h+9.999;

    difference(){
        union(){
            //Vesa Plate
            tz(vesa_h/2) roundedcube([mount+15,mount+15,vesa_h], true, radius = 3);
            
            //Bars Mount Plate
            tz(lift_pod_h/2+vesa_h-0.001) roundedcube([plate_size, plate_size, lift_pod_h], center = true);

            //Mount Bars
            t([ Socket_spacing_base/2,0,bars_z]) ry(90)        liftPodArm(bar_length);
            t([-Socket_spacing_base/2,0,bars_z]) ry(90)        liftPodArm(bar_length);
            t([0, Socket_spacing_base/2,bars_z]) rz(90) ry(90) liftPodArm(bar_length);
            t([0,-Socket_spacing_base/2,bars_z]) rz(90) ry(90) liftPodArm(bar_length);

            //Mount Bars Supports
            if(Support_Bars) {
                tz(vesa_h+lift_pod_h/2-0.001) {
                    ty(-Socket_spacing_base/2) bar_support(lift_pod_h, (bar_length-Socket_d), plate_size);
                    ty(Socket_spacing_base/2)  bar_support(lift_pod_h, (bar_length-Socket_d), plate_size);
                    rz(90) {
                        ty(-Socket_spacing_base/2) bar_support(lift_pod_h, (bar_length-Socket_d), plate_size);
                        ty(Socket_spacing_base/2) bar_support(lift_pod_h, (bar_length-Socket_d), plate_size);
                    }
                }
            }
        }

        // Center cutout
        roundedcube([cutout,cutout,(vesa_h+lift_pod_h+Socket_d)*2], true, radius = 10);
        
        // Vesa Mount holes
        mount_holes(mount, screw_size, h=100, z=-10);
        mount_holes(mount, screw_head_size, h=100, z=screw_plate_h);
    }
}

Vesa(mount, vesa_h, lift_pod_h, cutout);
