include <roundedcube.scad>;
include <lockingSlot.scad>;
include <shortcuts.scad>;

Socket_d = 20;
Socket_w = 8;
Socket_hole_d =10;

Socket_spacing_base = (125-8);

module liftPodSocketHole(center = true){
    non_center_transform = center ? [0,0,0] : [Socket_d/2, Socket_d/2, Socket_w/2];
    t(non_center_transform)
    {
        cylinder(d=Socket_hole_d, h=Socket_w+2, center = true);
        tz(-Socket_w/2-0.01)         lockingSlot(od=17.5, id=11.5, t=0.6, nSlots=16, MSR = 1/1.75);
        tz(+Socket_w/2+0.01) rx(180) lockingSlot(od=17.5, id=11.5, t=0.6, nSlots=16, MSR = 1/1.75);
    }
}

module liftPodArmSocket(center = true){
    difference(){
        union(){
            roundedcube([Socket_d, Socket_d , Socket_w], radius = 10, center=center);
            ty(center ? Socket_d/4 : Socket_d/2) cube([Socket_d, Socket_d/2, Socket_w], center=center);
        }
        liftPodSocketHole(center);
        liftPodSocketHole(center);
    }
}

module liftPodArm(l, center = true){
    mid_section_length = l-2*Socket_d;
    t(center ? [0,0,0] : [Socket_d/2, l/2, Socket_w/2]){
    union(){
        cube([Socket_d, mid_section_length, Socket_w], center=true);
        ty(-mid_section_length/2-Socket_d/2+0.001)        liftPodArmSocket();       
        ty(mid_section_length/2+Socket_d/2-0.001) rz(180) liftPodArmSocket();
    }}
}

// liftPodArm(100);