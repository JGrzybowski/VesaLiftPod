// https://matthewharvey.io/useful-openscad-shapes-and-tools/

// shapesAndCuttingTools.scad

////////////////////////////////
//Cylinder/circle based shapes//
////////////////////////////////
include<shortcuts.scad>;
module tube(od,id,h){
  difference(){
    cylinder(d=od,h=h);
    tz(-1) cylinder(d=id,h=h+2);
  }
}

module splitTube(OD,ID,T,ST,SW){
  //T=thickness of tube
  //ST=thickness of split
  //SW=split width
  difference(){
    cylinder(d=OD,h=T);
    tz(-1) cylinder(d=ID,h=T+2);
    ty(-SW/2) tz(-1) cube([OD/2+1,SW,T+2]);
  }
}

module slot(drillD,length,h){
  tx(drillD/2){
    cylinder(d=drillD,h=h);
    ty(-drillD/2) cube([length-drillD,drillD,h]);
  }
  tx(length-drillD/2) cylinder(d=drillD,h=h);
  
}
//slot(10,30,1);

module cylSector(r,a,h,n=24){
  // creates a cylinder sector starting on x-axis and moving clockwise around z-axis
  angles=[for(i=[0:n-1]) -a*i/(n-1) ];
  points = [for(i=angles)[r*cos(i),r*sin(i)]];
  linear_extrude(height=h){
    polygon(concat(points,[[0,0]]));
  }
}
//cylSector(10,30,1);

module cylArc(ro,ri,a,h,n=24){
  difference(){
    cylSector(r=ro,a=a,h=h,n=n);
    tz(-1) rz(1) cylSector(r=ri,a=a+2,h=h+2,n=n);
  }
}
//cylArc(20,18,60,1);
module roundedSlot(r,drillD,a,h,n=24){
  ro=r+drillD/2;
  ri=r-drillD/2;
  roundedCylArc(ro=ro,ri=ri,a=a,h=h,n=n);
}
//roundedSlot(r=5,drillD=4,a=90,h=4);

module roundedCylArc(ro,ri,a,h,n=24){
  //as if milled by a drill bit
  $fn=n;
  drillR=(ro-ri)/2;
  arcR=(ro+ri)/2;
  startAng=180/PI*(drillR/arcR);
  endAng=a-startAng*2;
  rz(90-startAng){
    tx(arcR) cylinder(d=(ro-ri),h=h);
    cylArc(ro,ri,endAng,h,n);
    rz(-endAng) tx(arcR) cylinder(d=(ro-ri),h=h);
  }
}
//roundedCylArc(20,18,180,1,60);


module cylOuterChamfer(pr,cr,cd){
  //chamfers the outer edge off a cylinder
  //pr is outer radius of part to be chamfered
  //cr is the chamfer radius
  //cd is the depth (height) to chamfer by
  tz(-cd){
    difference(){ //chamfer off 0.5mm sharp edges
      tz(-cd) cylinder(r=pr+(pr-cr),h=3*cd);
      tz(-2*cd) cylinder(r1=pr+2*(pr-cr),r2=pr-3*(pr-cr),h=5*cd);
    }
  }
}
//cylOuterChamfer(pr=47.5,cr=46,cd=1);

module socketScrew(dia,length,clr="silver"){
  //makes a ISO metric socket screw as defined by http://www.metrication.com/engineering/fastener.html
  //the origin is at the bottom of the cap.
  //make cap socket head
  color(clr){
    difference(){
      cylinder(d=1.5*dia,h=1.25*dia);
      tz(0.5*dia) cylinder(d=0.8*dia/(pow(3,0.5)/2),h=dia,$fn=6);
    }
    //add shaft
    tz(-length) cylinder(d=dia,h=length);
  }
}

module M4socketScrew(length){
  color("silver"){
    difference(){
      cylinder(d=6.8,h=3.9);
      tz(3.9-2.8) cylinder(d=3/(pow(3,0.5)/2),h=2.8+1,$fn=6);
    }
    //add shaft
    tz(-length) cylinder(d=4,h=length);
  }
}

module post(h=50){
  difference(){
    cylinder(d=12.7,h=h);
    tz(h-5) cylinder(d=4,h=6);
    tz(-1) cylinder(d=6,h=6);
  }
}

module nut(dia){
  //hexagon ISO nut. Standard structural dimensions
  color("silver") difference(){
    cylinder(d=dia*2,h=dia*0.9,$fn=6);
    tz(-1) cylinder(d=dia,h=dia*0.9+2);
  }
}
//nut(4,$fn=50);

module washer(dia,t){
  //standard ISO washer of thickness t
  color("silver") difference(){
    cylinder(d=dia*2,h=t);
    tz(-1) cylinder(d=dia,h=t+2);
  }
}

/*
r=2;
length=20;
points=[for(theta=[0:60:300])[r*cos(theta),r*sin(theta)]];
linear_extrude(height=10){
  polygon(points);
}
*/