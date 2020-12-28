// Higher definition curves
$fs = 0.01;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5) {
    // If single value, convert to [x, y, z] vector
    size = (size[0] == undef) ? [size, size, size] : size;
    
    obj_translate = (center == false) ?
        [0, 0, 0] : [
            -(size[0] / 2),
            -(size[1] / 2),
            -(size[2] / 2)
        ];

    translate(v = obj_translate) {
        hull() {
            translate([radius,radius,0]) cylinder(h=size.z,r=radius);
            translate([size.x-radius,radius,0]) cylinder(h=size.z,r=radius);
            translate([radius,size.y-radius,0]) cylinder(h=size.z,r=radius);
            translate([size.x-radius,size.y-radius,0]) cylinder(h=size.z,r=radius);	
        }
    }
}