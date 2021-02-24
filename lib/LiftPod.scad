include <shortcuts.scad>;
include <roundedcube.scad>;
include <lockingSlot.scad>;

Socket_d = 20;
Socket_w = 8;
Socket_hole_d =10;

Socket_spacing_base = 116.5; //(125-Socket_d);
Socket_spacing_arms = 98.5; 
Socket_spacing_arms_inner = 80; // TODO: Verify!!

LOCKING_SOCKET = 0;
SCREWHEAD = 1;

module LockingHole(){
    lockingSlot(od=17.5, id=11.5, t=0.6, nSlots=16, MSR = 1/1.75);
}

module ScrewSocketHole() {
    cylinder(d=15, h=5.5, $fn=6);
}

module liftPodSocketHole(top, bottom, center = true){
    non_center_transform = center ? [0,0,0] : [Socket_d/2, Socket_d/2, Socket_w/2];
    t(non_center_transform)
    {
        cylinder(d=Socket_hole_d, h=Socket_w+2, center = true);
        
        tz(-Socket_w/2-0.01)         
            if (bottom == LOCKING_SOCKET)
                {LockingHole();}
            else if (bottom == SCREWHEAD)
                {ScrewSocketHole();}
        
        tz(+Socket_w/2+0.01) rx(180)  
            if (top == LOCKING_SOCKET)
                {LockingHole();}
            else if (top == SCREWHEAD)
                {ScrewSocketHole();}
    }
}

module liftPodArmSocket(top = LOCKING_SOCKET, bottom = LOCKING_SOCKET, center = true){
    difference(){
        union(){
            roundedcube([Socket_d, Socket_d , Socket_w], radius = 10, center=center);
            ty(center ? Socket_d/4 : Socket_d/2) cube([Socket_d, Socket_d/2, Socket_w], center=center);
        }
        liftPodSocketHole(top, bottom, center);
    }
}

module liftPodHalfArm(l, top = LOCKING_SOCKET, bottom = LOCKING_SOCKET, center = true){
    mid_section_length = l-Socket_d;
    t(center ? [0,Socket_d/2,0] : [Socket_d/2, l/2, Socket_w/2]){
    union(){
        cube([Socket_d, mid_section_length, Socket_w], center=true);
        ty(-mid_section_length/2-Socket_d/2+0.001)  liftPodArmSocket(top, bottom);       
    }}
}

module liftPodArm(l, begginingTop = LOCKING_SOCKET, begginingBottom = LOCKING_SOCKET, endTop = LOCKING_SOCKET, endBottom = LOCKING_SOCKET, center = true){
    mid_section_length = l-2*Socket_d;
    t(center ? [0,0,0] : [Socket_d/2, l/2, Socket_w/2]){
    union(){
        cube([Socket_d, mid_section_length, Socket_w], center=true);
        ty(-mid_section_length/2-Socket_d/2+0.001)        liftPodArmSocket(begginingTop, begginingBottom);       
        ty(mid_section_length/2+Socket_d/2-0.001) rz(180) liftPodArmSocket(endTop, endBottom);
    }}
}