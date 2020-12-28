// https://matthewharvey.io/openscad-shortcuts-module/

// This module contains handy shortcuts to speed up writing 
// common translate and rotate commands. Most of the time,
// only one axis needs to be used and writing lots of square
// bracket commands can get tedious.
// Very similar to some of ShortCuts library by Parkinbot:
// http://www.thingiverse.com/thing:644830

// Version 1 - 03/03/16
// Version 1.1 - 03/03/16
// Overloaded t and r modules added.

// Version 1.2 - 14/03/16
// Fixed r(x,y,z) to do rotations in same order as rotate. i.e. x,y,z.
// Added reverse order rotate function rotzyx. Vector r is still of form [x,y,z].
// Added decimalp function to round to specified number of decimal places. 

//constants
PI=3.14159265359;

// helper modules to speed up code writing
module tx(x){translate([x,0,0]) children();}
module ty(y){translate([0,y,0]) children();}
module tz(z){translate([0,0,z]) children();}
//module t(v){tx(v[0])ty(v[1])tz(v[2]) children();}
module t(v){translate(v) children();} // a smidgen more efficient...
module trtheta(r,theta){ //translate in [x,y] by entering [r,θ]
  tx(r*sin(theta)) ty(r*cos(theta)) children();
}
module trphi(r,phi){ //translate in [x,z] by entering [r,phi]
  tx(r*sin(phi)) tz(r*cos(phi)) children();
}

module rx(x){rotate([x,0,0]) children();}
module ry(y){rotate([0,y,0]) children();}
module rz(z){rotate([0,0,z]) children();}
//module r(v){rotate(v) children();} //this doesn't work for some reason. Investigate!!!
module r(x,y,z){rz(z) ry(y) rx(x) children();}
module rotzyx(r){rx(r[0]) ry(r[1]) rz(r[2]) children();}

//function to return the number of desired decimal points
function decimalp(n,dp=1) = 
  let(x=n*pow(10,dp))
  round(x)/pow(10,dp);

function ndp(x,n=1) = 
  floor(x)+round(pow(10,n)*(x-floor(x)))/pow(10,n);

//function to give arc angle given arc radius and length along arc
function arcAng(r,s) = 180/PI*(s/r);