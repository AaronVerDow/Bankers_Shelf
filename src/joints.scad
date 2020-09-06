$fn=20;

module pintail_gaps(edge,depth,pins,gap=0,ear=0,extra=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment:edge-1]) {
        translate([0,y-gap/2])
        square([depth,gap]);
    }
}

module ear_dot(ear,extra=0) {
    rotate([0,0,45])
    translate([0,ear/2-extra])
    circle(d=ear);
}

module ear(ear=0,extra=0) {
    if(ear)
    if(!extra) {
        ear_dot(ear);
    } else {
        hull() {
            ear_dot(ear,0);
            ear_dot(ear,extra);
        }
    }
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

module tail_ears(edge,depth,pins,gap=0,ear=0,extra=0) {
    segments=pins*2+1;
    segment=edge/segments;

    // middle ears
    for(y=[segment-gap/2:segment*2:edge-segment*2])
    translate([depth,y])
    dirror_y(segment+gap)
    ear(ear,extra);
}

module pin_ears(edge,depth,pins,gap=0,ear=0,extra=0) {
    segments=pins*2+1;
    segment=edge/segments;

    // middle ears
    for(y=[segment*2-gap/2:segment*2:edge-segment*2])
    translate([depth,y])
    dirror_y(segment+gap)
    ear(ear,extra);

    // end ears
    dirror_y(edge)
    translate([depth,edge-segment-gap/2])
    ear(ear,extra);
}


module negative_pins(edge,depth,pins,gap=0,hole=0,ear=0,extra=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[0:segment*2:edge])
    translate([0,y])
    square([depth,segment]);

    pintail_gaps(edge,depth,pins,gap,ear,extra);
    pin_ears(edge,depth,pins,gap,ear,extra);

    if(hole)
    pin_holes(edge,depth,pins,hole);

}

module pintail_test(edge=200,depth=12,pins=4,gap=3,hole=6,ear=3,extra=0) {
    //color("lime")negative_pins(edge,depth,pins,gap,hole,ear,extra);
    color("blue")negative_tails(edge,depth,pins,gap,hole,ear,extra);
    //color("blue")negative_slot(edge,depth,ear,extra);
}

module tail_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment/2:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}


module pin_holes(edge,depth,pins,hole) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment*1.5:segment*2:edge])
    translate([depth/2,y])
    circle(d=hole);
}

module negative_tails(edge,depth,pins,gap=0,hole=0,ear=0,extra=0) {
    segments=pins*2+1;
    segment=edge/segments;

    for(y=[segment:segment*2:edge-1])
    translate([0,y])
    square([depth,segment]);
    pintail_gaps(edge,depth,pins,gap);

    tail_ears(edge,depth,pins,gap,ear,extra);

    if(hole)
    tail_holes(edge,depth,pins,hole);
}

module negative_slot(edge,depth,ear=0,extra=0) {
    square([depth,edge]);
    translate([depth,edge])
    rotate([0,0,90])
    ear(ear,extra);
}

pintail_test();
