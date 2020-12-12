use <joints.scad>;
use <puzzle_joints.scad>;
in=25.4;
box_x=12.5*in;
box_y=16.2*in;
box_z=10.5*in;
lid=0.25*in;
lid_h=2.5*in;

show_plywood=0;  // change to 1 to show plywood in cutsheet views
plywood_x=8*12*in;
plywood_y=4*12*in;

bit=1/4*in;
cut_gap=bit*3;

cubby_x=box_x+2*in;
cubby_y=box_y/3*2;
cubby_z=box_z+lid_h*1.5;

COLOR="";

big_fn=90;

function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);

// https://www.amazon.com/Pieces-Premium-Cedar-Wood-Shims/dp/B07V9PLBZM/
shim_x=1/4*in;
shim_y=(1+7/16)*in;
shim_z=8.75*in/2;

// extra on the bottom
stabilizer=2*in;

shim_target=shim_x;
shim_grip=shim_y/3*2+bit/2;

rows=5;
columns=4;
wood=0.5*in;

pad=0.1;

shelf_x_gap=in/8;
shelf_y_gap=0;

corner_x=lid_h;
corner_y=lid_h;
extra_top=corner_y;
extra_bottom=corner_y;

shelf_ends=cubby_x/3;

side_x=cubby_y;
side_y=(cubby_z+wood)*(rows-1)+extra_top+extra_bottom+wood;

echo(side_y/in);

shelf_x=wood+(cubby_x+wood)*columns+shelf_ends*2;
shelf_y=cubby_y/3;

room_height=76*in;
room_width=20*12*in;

unit=shelf_x+cubby_x-shelf_ends*2;
room_end=(room_width-unit*3+cubby_x-shelf_ends*2)/2;

side_cut=shelf_y;
end_holes=bit*1.2;
joint_gap=bit/8;

anchor=bit*1.2;

shelf_cut=shim_grip;

puzzle_width=shelf_y;
puzzle_minimum=bit*1.5;
puzzle_step=wood;
puzzle_fn=20;
puzzle_gap=bit/2;

module connector() {
    tab_h=height(puzzle_width,puzzle_step,puzzle_minimum);
    x=cubby_x-shelf_ends*2+tab_h*2;
    y=shelf_y;
    difference() {
        square([x,y],center=true);


        dirror_x()
        translate([-x/2,0,0])
        rotate([0,0,90])
        negative_puzzle_tab(puzzle_width,puzzle_minimum,puzzle_step,puzzle_step-puzzle_gap,fn=puzzle_fn);
    }
}

module end_connector() {
    tab_h=height(puzzle_width,puzzle_step,puzzle_minimum);
    x=room_end+tab_h;
    y=shelf_y;
    translate([x/2,0])
    mirror([1,0])
    difference() {
        square([x,y],center=true);
        translate([-x/2,0,0])
        rotate([0,0,90])
        negative_puzzle_tab(puzzle_width,puzzle_minimum,puzzle_step,puzzle_step-puzzle_gap,fn=puzzle_fn);
        translate([x/2,-y/2,0])
        mirror([1,0,0])
        negative_pins(y,wood,1,joint_gap,0,bit,0);
    }
}

module end_connector_3d() {
    difference() {
        wood()
        end_connector();
        translate([0,0,-wood/2])
        wood()end_connector_pocket();
    }
}

module end_connector_pocket() {
    tab_h=height(puzzle_width,puzzle_step,puzzle_minimum);
    x=room_end+tab_h;
    mirror([1,0])
    translate([-x,0,0])
    rotate([0,0,90]) {
    //negative_puzzle_tab(puzzle_width,puzzle_minimum,puzzle_step,-puzzle_gap,fn=puzzle_fn);
        //color("lime")
        translate([0,-tab_h,0])
        negative_puzzle_blank_step(puzzle_width,puzzle_minimum,puzzle_step,puzzle_step,fn=puzzle_fn,bit=bit/2);
    }
}

module connector_pocket() {
    tab_h=height(puzzle_width,puzzle_step,puzzle_minimum);
    x=cubby_x-shelf_ends*2+tab_h*2;
    dirror_x()
    translate([-x/2,0,0])
    rotate([0,0,90])
    negative_puzzle_tab(puzzle_width,puzzle_minimum,puzzle_step,-puzzle_gap,fn=puzzle_fn);
}

module connector_3d() {
    difference() {
        wood()
        connector();
        translate([0,0,-wood/2])
        wood()connector_pocket();
    }
}

module room_end() {
    translate([wood/2,0,side_y/2])
    rotate([90,0,90])
    wood()
    side(false);

    color("lime")
    for(row=[0:1:rows-1])
    translate([0,0,(cubby_z+wood)*row+extra_bottom+wood])
    dirror_y()
    translate([0,cubby_y/2-shelf_y/2,-wood/2])
    end_connector_3d();
}

// PREVIEW
// RENDER scad
// RENDER png
module room() {
    translate([0,cubby_z,0])
    rotate([90,0,0])
    square([room_width,room_height]);

    dirror_x(room_width)
    room_end();

    //translate([box_x/2,0,0]) box();
        
    translate([room_width/2-unit*1.5+shelf_ends/2,0,0]) {
        for(x=[0:unit:room_width-cubby_x-shelf_ends])
        translate([x+shelf_ends+cubby_x/2+wood,0,0])
        preview();

        color("lime")
        for(x=[ shelf_x+cubby_x-shelf_ends*2 :shelf_x+cubby_x-shelf_ends*2:room_width-cubby_x-shelf_ends])
        translate([x+shelf_ends-cubby_x/2,0,0])
        for(row=[0:1:rows-1])
        translate([0,0,(cubby_z+wood)*row+extra_bottom+wood])
        dirror_y()
        translate([0,cubby_y/2-shelf_y/2,-wood/2])
        connector_3d();
    }
}

// PREVIEW
// RENDER scad
// RENDER png --camera=0,0,0,0,0,0,0
module cutsheets() {
    end_cutsheet()
    end_cutsheet_pockets()
    side_cutsheet()
    shelf_cutsheet()
    shelf_cutsheet_pockets();
}

module if_color(_color) {
    if(COLOR == _color || COLOR == "")
    color(_color)
    children();
}

// RENDER svg
module shelf_cutsheet(display="profile") {
    translate([-cubby_x/2,0])
    plywood();
    gap=shelf_y+cut_gap;
    max=cut_gap*rows*2+shelf_y*rows*2-cut_gap;
    for(y=[0:gap*2:max])
    translate([shelf_x/2,shelf_y/2+y+(plywood_y-max)/2])
    if (display=="profile" ) {
        shelf();
    } else if (display=="pocket") {
        shelf_pocket();
    }

    for(y=[gap:gap*2:max])
    translate([shelf_x/2+cubby_x/2+shelf_ends/2,shelf_y/2+y+(plywood_y-max)/2+17])
    mirror([0,1])
    if (display=="profile" ) {
        shelf();
    } else if (display=="pocket") {
        shelf_pocket();
    }

    translate([0,plywood_y*1.2])
    children();

    color("lime")
    dirror_y(max+gap+cut_gap*2)
    dirror_x(shelf_x+cubby_x/2+shelf_ends/2+cut_gap)
    translate([-cut_gap,plywood_y/2-max/2-cut_gap])
    circle(d=anchor);
    
}

// RENDER svg
module end_cutsheet(display="profile") {
    columns=1;
    less_gap=90;
    gap=side_x+cut_gap-less_gap;
    max=cut_gap*columns+side_x*columns+side_x-less_gap*columns-less_gap;
    //translate([-10*in,0]) plywood();

    color("lime")
    dirror_y(plywood_y)
    dirror_x(shelf_x+cubby_x/2+shelf_ends/2+cut_gap)
    translate([-cut_gap,2*in])
    circle(d=anchor);

    if (display=="profile") {
        rotate([0,0,90])
        for(x=[0:gap*2:max])
        translate([side_x/2+x+(plywood_y-max)/2-less_gap/2,-side_y/2])
        mirror([0,1])
        side(false);

        rotate([0,0,90])
        for(x=[gap:gap*2:max])
        translate([side_x/2+x+(plywood_y-max)/2-less_gap/2,-side_y/2-cubby_x/2-extra_top/2-wood/2])
        side(false);
    }

    end_gap=shelf_y+cut_gap*5;
    ends=10;
    module end_connectors_sheet() {
        for(x=[0:end_gap:end_gap*ends-10])
        translate([x-end_gap*ends/2+end_gap/2+side_y/2+gap/2,plywood_y/2-max-less_gap])
        rotate([0,0,40])
        if (display=="profile") {
        end_connector();
        } else if (display=="pocket") {
            end_connector_pocket();
        }
    }

    end_connectors_sheet();
    translate([shelf_x+cubby_x/2+shelf_ends/2,0])
    mirror([1,0])
    translate([0,plywood_y])
    mirror([0,1])
    end_connectors_sheet();

    translate([0,plywood_y*1.2])
    children();
}

// RENDER svg
module end_cutsheet_pockets() {
    end_cutsheet("pocket")
    children();
}

// RENDER svg
module shelf_cutsheet_pockets() {
    shelf_cutsheet("pocket")
    children();
}

// RENDER svg
module side_cutsheet() {
    less_gap=90;
    gap=side_x+cut_gap-less_gap;
    max=cut_gap*columns+side_x*columns+side_x-less_gap*columns-less_gap;
    //translate([-10*in,2*in]) plywood();

    rotate([0,0,90])
    for(x=[0:gap*2:max])
    translate([side_x/2+x+(plywood_y-max)/2,-side_y/2])
    mirror([0,1])
    side();

    rotate([0,0,90])
    for(x=[gap:gap*2:max])
    translate([side_x/2+x+(plywood_y-max)/2,-side_y/2-cubby_x/2-extra_top/2-wood/2])
    side();


    translate([0,plywood_y*1.2])
    children();
}

// RENDER svg
module pockets() {
    shelf_cutsheet("pocket");
}

module plywood() {
    if(show_plywood)
    translate([0,0,-1])
    #square([plywood_x,plywood_y]);
}

// RDR obj
module assembled() {
    if_color("wheat")
    sides();
    if_color("rosybrown")
    shelves();
}

// RDR obj
module assembled_with_shims() {
    if_color("chocolate") shims();
    assembled();
}

// PREVIEW
// REDNER scad
// RDR obj
module preview() {
    boxes();
    assembled_with_shims();
}

module shims() {
    difference() {
        union() {
            for(row=[0:1:rows-1])
            for(column=[0:1:columns])
            translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row])
            dirror_y()
            translate([-cubby_x/2,-cubby_y/2+shelf_y+shim_y/2-shim_grip,extra_bottom+wood/2])
            dirror_x(-wood)
            shim();
        }
        translate([-cubby_x,-cubby_y/2,-shim_z])
        cube([(columns+1)*cubby_x,cubby_y,shim_z]);
    }
}

module shim() {
    translate([0,-shim_y/2,-shim_z/2])
    hull() {
        cube([pad,shim_y,shim_z]);
        translate([0,0,shim_z-pad])
        cube([shim_x,shim_y,pad]);
    }
}

module corner() {
    hull() {
        square([corner_x*2+wood,wood],center=true);
        translate([0,-wood/2-corner_y/2])
        square([wood,corner_y],center=true);
    }
}

module corners() {
    for(row=[0:1:rows-1])
    for(column=[0:1:columns])
    translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row+extra_bottom+wood])
    dirror_y()
    translate([-cubby_x/2-wood/2,-cubby_y/2+shelf_y/2,-wood/2])
    rotate([90,0,0])
    wood()
    corner();
}

// RDR obj
module box() {
    translate([0,0,box_z/2-lid_h/2+pad]) {
        if_color("white")
        cube([box_x,box_y,box_z-lid_h],center=true);
        if_color("gray")
        translate([0,0,box_z/2])
        cube([box_x+lid*2,box_y+lid*2,lid_h],center=true);
    }
}


module cubby() {
    translate([0,0,cubby_z/2])
    #cube([cubby_x,cubby_y,cubby_z],center=true);
}

module fill_cubbies() {
    for(row=[0:1:rows-1])
    for(column=[0:1:columns-1])
    translate([(cubby_x+wood)*column,0,(cubby_z+wood)*row+extra_bottom+wood])
    children();
}

module boxes() {
    fill_cubbies() {
        box();
        //cubby();
    }
}

module shelf() {
    radius=segment_radius(shelf_cut,cubby_x-shim_target*2);
    slot_x=wood+shim_target*2;
    slot_y=shim_grip+pad;
    difference() {
        square([shelf_x,shelf_y],center=true);

        for(column=[0:1:columns])
        translate([column*(cubby_x+wood)-shelf_x/2+shelf_ends+wood/2,-shelf_y/2+shim_grip/2])
        dirror_x()
        translate([-slot_x/2,-slot_y/2])
        negative_slot(slot_y,slot_x,bit,0);


        gap=cubby_x+wood;
        max=cubby_x*columns+wood*columns-wood;
        for(x=[-shim_target:gap:max])
        translate([x-max/2+gap/2,-radius-shelf_y/2+shelf_cut])
        circle(r=radius,$fn=big_fn);

        dirror_x()
        translate([shelf_x/2,0])
        rotate([0,0,90])
        negative_puzzle_blank(puzzle_width,puzzle_minimum,puzzle_step,0,fn=puzzle_fn);

    }
}

module shelf_pocket() {
    dirror_x()
    translate([shelf_x/2,0])
    rotate([0,0,90])
    negative_puzzle_blank_step(puzzle_width,puzzle_minimum,puzzle_step,puzzle_step,fn=puzzle_fn,bit=bit/2);
}

module dirror_x(x=0) {
    children();
    translate([x,0,0])
    mirror([1,0,0])
    children();
}

module dirror_y(y=0) {
    children();
    translate([0,y,0])
    mirror([0,1,0])
    children();
}

module shelf_3d() {
    difference() {
        wood()
        shelf();
        translate([0,0,wood/2])
        wood()
        shelf_pocket();
    }
}


module shelves() {
    for(row=[0:1:rows-1])
    translate([0,0,(cubby_z+wood)*row+extra_bottom+wood])
    dirror_y()
    translate([shelf_x/2-cubby_x/2-wood-shelf_ends,cubby_y/2-shelf_y/2,-wood/2])
    shelf_3d();
}

module side(slots=true) {
    radius=segment_radius(side_cut, cubby_z);
    slot_x=shelf_y+pad+shelf_x_gap-shim_grip;
    slot_y=wood+shelf_y_gap;
    difference() {
        union() {
            square([side_x,side_y],center=true);
            translate([0,-side_y/2+extra_bottom/2])
            square([side_x+stabilizer*2,extra_bottom],center=true);
        }
        dirror_x()
        for(row=[0:1:rows-1])
        translate([side_x/2-shelf_y-shelf_x_gap+shim_grip,(cubby_z+wood)*row+extra_bottom-side_y/2])
        translate([slot_x,0])
        rotate([0,0,90])
        dirror_x(slot_y)
        if(slots) {
            negative_slot(slot_x,slot_y,bit,0);
        } else {
            negative_tails(shelf_y,wood,1,joint_gap,end_holes,bit,0);
        }

        dirror_x()
        for(y=[0:cubby_z+wood:side_y-extra_top-extra_bottom-wood*2])
        translate([-radius-side_x/2+side_cut,y-side_y/2+extra_bottom+wood+cubby_z/2])
        circle(r=radius,$fn=big_fn);
    }
}

module wood() {
    linear_extrude(height=wood,center=true)
    children();
}

module sides() {
    for(column=[0:1:columns]) {
        translate([column*(cubby_x+wood)-cubby_x/2-wood/2,0,side_y/2])
        rotate([90,0,90])
        wood()
        side();
    }
}

module vr() {
    scale(1/1000)
    children();
}

// PREVIEWS

room();
// preview();
// assembled(); 
// assembled_with_shims(); 
// cutsheets();

// PARTS

// shelf(); 
// shelf_3d();
// side();
// side(false);
// end_connector();
// end_connector_3d();
// connector();
// connector_3d();

// CUTSHEETS (use these to export and cut)

// shelf_cutsheet();
// shelf_cutsheet_pockets();
// side_cutsheet();
// end_cutsheet();
// end_cutsheet_pockets();
