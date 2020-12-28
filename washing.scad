include <shortcuts.scad>;
include <shapesAndCuttingTools.scad>;
$fn=24;
module chopperWheel(od = 100, id = 25.5, t=1, nSlots = 20, MSR = 0.5){
    //od = wheel outer diameter
    //id = wheel inner diameter
    //t = thickness of disk
    //nSlots = number of slots
    //MSR = mark space ratio. MSR > 0.5 means bigger holes
    
    module wedge(){
        rz(360/nSlots/4) cylSector(r = od/2,a = MSR* 360/(nSlots),h = t,n=24);
    }
    
    difference(){
        union(){
            for (i = [0:360/nSlots:360-360/nSlots]){
                rz(i) wedge();
            }
        }
        tz(-1) cylinder(d=id, h=t+2);
    }
}