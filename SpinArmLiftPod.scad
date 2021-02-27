include <lib/roundedcube.scad>;
include <lib/LiftPod.scad>;
include <lib/shortcuts.scad>;

/* [ Horizontal ] */
Horizontal_connector_length = 60; 
Horizontal_connector_width = "Socket_spacing_arms"; //[Socket_spacing_base : Base plate distance, Socket_spacing_arms : Middle Arms / B extender arms distance, Socket_spacing_arms_inner : Inner Arms / A extender arms distance ]
BaseMountSocketsInside = Horizontal_connector_width == "Socket_spacing_arms_inner"; 

/* [ Vertical ] */
Vertical_connector_length = 50;
Vertical_connector_offset = 30;
Vertical_connector_width = "Socket_spacing_arms"; //[Socket_spacing_base : Base plate distance, Socket_spacing_arms : Middle Arms / B extender arms distance, Socket_spacing_arms_inner : Inner Arms / A extender arms distance ]
RotatedMountSocketsInside = Vertical_connector_width == "Socket_spacing_arms_inner"; 

/* [Hidden] */
// Change these values only if you know what you are doing, hexagonal screwhead sockets on the outside of arm are probably not what you want.
BaseMountSocketsOutside = false; 
RotatedMountSocketsOutside = false;

BaseMountWidth = (Horizontal_connector_width == "Socket_spacing_base") ? Socket_spacing_base
               : (Horizontal_connector_width == "Socket_spacing_arms") ? Socket_spacing_arms
               : (Horizontal_connector_width == "Socket_spacing_arms_inner") ? Socket_spacing_arms_inner : 0;

RotatedMountWidth = (Vertical_connector_width == "Socket_spacing_base") ? Socket_spacing_base
                  : (Vertical_connector_width == "Socket_spacing_arms") ? Socket_spacing_arms
                  : (Vertical_connector_width == "Socket_spacing_arms_inner") ? Socket_spacing_arms_inner : 0;

// Default values of those are quite good to not to mess with them
Vertical_arm_length = RotatedMountWidth + Vertical_connector_offset + Socket_w;

module spin_arm(arms_l, base_l){

    joint_round = Socket_w/2;
    joint_thickness = Socket_w;

    tx( BaseMountWidth/2) ry(-90) liftPodHalfArm(arms_l, BaseMountSocketsInside ? SCREWHEAD : LOCKING_SOCKET, BaseMountSocketsOutside ? SCREWHEAD : LOCKING_SOCKET);
    tx(-BaseMountWidth/2) ry( 90) liftPodHalfArm(arms_l, BaseMountSocketsInside ? SCREWHEAD : LOCKING_SOCKET, BaseMountSocketsOutside ? SCREWHEAD : LOCKING_SOCKET);

    ty(arms_l/2) 
        roundedcube([BaseMountWidth+Socket_w, joint_thickness, Socket_d], radius=joint_round, center=true);
    
    base_bars_h = Vertical_connector_length;
    base_thickness = Socket_w;
    tx(BaseMountWidth/2) ty(arms_l/2+base_l/2-joint_round){
        roundedcube([base_thickness, base_l, Socket_d], radius = joint_round, center = true);
        ty((base_l-RotatedMountWidth)/2-joint_round) tx(base_bars_h/2+base_thickness/2-joint_round/2){ 
            ty( RotatedMountWidth/2) rx( 90) rz(90) liftPodHalfArm(base_bars_h+joint_round, RotatedMountSocketsInside ? SCREWHEAD : LOCKING_SOCKET, RotatedMountSocketsOutside ? SCREWHEAD : LOCKING_SOCKET);
            ty(-RotatedMountWidth/2) rx(-90) rz(90) liftPodHalfArm(base_bars_h+joint_round, RotatedMountSocketsInside ? SCREWHEAD : LOCKING_SOCKET, RotatedMountSocketsOutside ? SCREWHEAD : LOCKING_SOCKET);
        }
    }

    trapezoid = [
        [   -Socket_w/2, arms_l/2],
        [   +Socket_w/2, arms_l/2],
        [   BaseMountWidth/2, arms_l+45 ],
        [   BaseMountWidth/2, arms_l+45+Socket_w*1.75 ]
    ];
            
     trapezoid2 = [
        [   -Socket_w/2, arms_l/2],
        [   +Socket_w/2, arms_l/2],
        [   BaseMountWidth/2-Socket_w/2, base_l+8-Socket_w*0.25 ],
        [   BaseMountWidth/2-Socket_w/2, base_l+8+Socket_w*1.75 ]
    ];

    linear_extrude(height = Socket_d, center = true, convexity = 10) polygon(trapezoid); 
    linear_extrude(height = Socket_d, center = true, convexity = 10) polygon(trapezoid2); 
}

spin_arm(Horizontal_connector_length, Vertical_arm_length);


