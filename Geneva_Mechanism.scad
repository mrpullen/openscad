//Kevin Toppenberg, MD
//4/5/18
//This is a remix of Geneva Mechanism by Jasper_Pues: 
//  https://www.thingiverse.com/thing:484513
//I have remodel this in OpenSCAD

//--------------------------------


explode = 0;
show_slots              = 0;

show_geneva_wheel = 0;
show_geneva_pin_wheel = 0;
show_geneva_base = 0;
//--------------------------------

offset = 0.2;


// NOTE drive_crank_radius shoudl alwasy be == or > than shaft_diameter + drive_pin_diameter.

// shaft_diameter

shaft_diameter = 21;

// a
drive_crank_radius = 26;

// n
driven_slot_quantity = 6;

//p
drive_pin_diameter = 5;

//t
allowed_clearance = 0.4;

height = 4;

// c
center_distance = drive_crank_radius / sin(180 / driven_slot_quantity);
//b
geneva_wheel_radius = sqrt(center_distance^2 - drive_crank_radius ^2);
//s
slot_center_length = (drive_crank_radius + geneva_wheel_radius) - center_distance;
//w
slot_width = drive_pin_diameter + allowed_clearance;
//y
stop_arc_radius = drive_crank_radius - (drive_pin_diameter * 1.5);
//z
stop_disk_radius = stop_arc_radius + allowed_clearance;
//v
clearance_arc = (geneva_wheel_radius * stop_disk_radius) / drive_crank_radius;

slot_center_distance = geneva_wheel_radius - slot_center_length;


if(show_geneva_wheel == 1) {
    if(explode == 1) {
        translate([100,100,-height])
        geneva_wheel();
    }
    else {
        geneva_wheel();
    }
}

if(show_geneva_pin_wheel == 1) {
    if(explode == 1) {
        translate([-100,-100,0])
        pin_gear();
    }
    else {
        pin_gear();
    }
}

if(show_geneva_base == 1) {
    if(explode == 1) {
        translate([100,-100,height])
        base();
    }
    else {
        base();
    }
}
module geneva_wheel() {
  layer = height+offset;
  color("red")
  translate([0,0, offset])  
  //cylinder(r=drive_crank_radius + drive_pin_diameter, h=height, $fn=100);
  color("red")
  translate([0,0, layer])
  difference() {
    cylinder(r = geneva_wheel_radius, h=height, $fn=100);
    union() {
        translate([0,0,-0.5])
        cylinder(d=shaft_diameter, h=height*3, $fn=100);
        
        for(angle = [0:(360 / driven_slot_quantity):360]) {
            translate([center_distance * cos(angle), center_distance * sin(angle), -(0.5)])
            cylinder(r=stop_disk_radius, h=height+1, $fn=100);
        
        }
        
        for(angle = [(180/ driven_slot_quantity):(360 / driven_slot_quantity): 360]) {
        
            translate([(slot_center_distance) * cos(angle), slot_center_distance * sin(angle), -0.5])
            cylinder(d=slot_width, h=height+1, $fn=100);
            color("red")
            rotate([0,0, angle])
            translate([slot_center_distance, - slot_width/2, - 0.5])
            cube([slot_center_length,slot_width, layer+1]); 
        } 
    }
  }
  if(show_slots == 1) {
      translate([0, 0, layer*2])
      for (angle = [(180/ driven_slot_quantity):(360 / driven_slot_quantity): 360]) {
            color("blue")
            translate([(slot_center_distance) * cos(angle), slot_center_distance * sin(angle), -0.5])
            cylinder(d=slot_width, h=height+1, $fn=100);
            color("yellow")
            rotate([0,0, angle])
            translate([slot_center_distance, - slot_width/2, - 0.5])
            cube([slot_center_length,slot_width, height+1]); 
            
       
        } 
    }


}


module pin_gear() {
  layer = offset;  
  layer1 = height + offset;
    union() {
     translate([center_distance, 0, height])
        color("white")
        translate([0, drive_crank_radius, -0.5])
          cylinder(d=drive_pin_diameter, h=height, $fn=100);
    
    difference() {
        union() {
           
        color("blue")
        translate([center_distance, 0, layer])
        difference() {
           cylinder(r=drive_crank_radius + drive_pin_diameter, h=height, $fn=100);
           translate([0, 0, -0.5])
            cylinder(d = shaft_diameter, h=height+1, $fn=100); 
        }
        
    translate([center_distance, 0, layer1])
   
        color("green")
        cylinder(d=(stop_disk_radius*2) - allowed_clearance, h=height, $fn=100);
    }
        
        color("red")
        translate([center_distance, clearance_arc, height+offset + .01])
        cylinder(d=(clearance_arc * 2), h=height+2, $fn=100);
            
        //translate([0, 0,0])
        //cylinder(d=shaft_diameter, h=height, $fn=100);
    
   }
 }
}



use_pins = 1;
use_bearings = 0;
show_pins = 1;
module base() {
    
   
/* module explode( distance) {
    
  for (i =[0:1:$children-1])
    translate([ i * distance, 0, 0]) {
        children(i);
    }  
  
}

explode_objects = 1;
if(explode_objects == 1) {
    explode( 100 ) {
        union() {
        geneva_wheel();
        }
        
        union() {
        pin_gear();
        }
        union() {
        base();
        }
    }

}
*/
  layer0 = offset - height;
  layer1 = offset;
    
  color("green")
  translate([0,0,0])
  
  difference() {
    union() {
      translate([center_distance / 2,0, layer0 / 2])
      cube([center_distance,stop_disk_radius * 2, height - offset],true);
      translate([0,0,layer0])
      cylinder(r=stop_disk_radius * 2, h= height - offset, $fn=100);
      translate([0,0,layer1])
      cylinder(r=stop_disk_radius, h= height - offset, $fn=100);
      
      translate([center_distance,0,layer0])
      cylinder(r=stop_disk_radius * 2, h= height - offset, $fn=100);
    
      if(use_pins == 1) {
        color("yellow")
        translate([0,0,layer0])
        cylinder(d=shaft_diameter-allowed_clearance, h=height*3, $fn=100);
  
        color("yellow")
        translate([center_distance,0,layer0])
        cylinder(d=shaft_diameter-allowed_clearance, h=height*2, $fn=100);
      }
        
    };
    if(use_bearings == 1) {
      color("yellow")
      translate([0,0,layer0-0.5])
      cylinder(d=shaft_diameter-allowed_clearance, h=height*3, $fn=100);
  
      color("yellow")
      translate([center_distance,0,layer0-0.5])
      cylinder(d=shaft_diameter-allowed_clearance, h=height*2, $fn=100);
    }
    

    }
    
    /*difference() {
      translate([0,0,-0.5])
      cylinder(d=shaft_diameter, h=height+1, $fn=100);
   }
   
   color("green")
   translate([center_distance,0,layer0])
   difference() {
    cylinder(r=drive_crank_radius+allowed_clearance, h= height - offset, $fn=100);
    translate([0,0,-0.5])
    cylinder(d=shaft_diameter, h=height+1, $fn=100);
    
   }  
 */ 
    
}


