include <lib/roundedcube.scad>;
include <lib/LiftPod.scad>;
include <lib/shortcuts.scad>;

Horizontal_connector_length = 60;
Vertical_connector_length = Socket_spacing_base+30;

module spin_arm(arms_l, base_l){

    joint_round = Socket_w/2;
    joint_thickness = Socket_w;

    tx( Socket_spacing_arms/2) ry(90) liftPodHalfArm(arms_l);
    tx(-Socket_spacing_arms/2) ry(90) liftPodHalfArm(arms_l);

    ty(arms_l/2) 
        roundedcube([Socket_spacing_arms+Socket_w, joint_thickness, Socket_d], radius=joint_round, center=true);
    
    base_bars_h = 50;
    base_thickness = Socket_w;
    tx(Socket_spacing_arms/2) ty(arms_l/2+base_l/2-joint_round){
        roundedcube([base_thickness, base_l, Socket_d], radius = joint_round, center = true);
        ty((base_l-Socket_spacing_arms)/2-joint_round) tx(base_bars_h/2+base_thickness/2-joint_round/2){ 
            ty( Socket_spacing_arms/2) rx(90) rz(90) liftPodHalfArm(base_bars_h+joint_round);
            ty(-Socket_spacing_arms/2) rx(90) rz(90) liftPodHalfArm(base_bars_h+joint_round);
        }
    }

    trapezoid = [
        [   -Socket_w/2, arms_l/2],
        [   +Socket_w/2, arms_l/2],
        [   Socket_spacing_arms/2, arms_l+45 ],
        [   Socket_spacing_arms/2, arms_l+45+Socket_w*1.75 ]
    ];
            
     trapezoid2 = [
        [   -Socket_w/2, arms_l/2],
        [   +Socket_w/2, arms_l/2],
        [   Socket_spacing_arms/2-Socket_w/2, base_l+8-Socket_w*0.25 ],
        [   Socket_spacing_arms/2-Socket_w/2, base_l+8+Socket_w*1.75 ]
    ];

    linear_extrude(height = Socket_d, center = true, convexity = 10) polygon(trapezoid); 
    linear_extrude(height = Socket_d, center = true, convexity = 10) polygon(trapezoid2); 
}

//spin_arm(Horizontal_connector_length, Vertical_connector_length);
liftPodScrewSocketHole();
