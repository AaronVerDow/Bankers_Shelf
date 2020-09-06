function segment_radius(height, chord) = (height/2)+(chord*chord)/(8*height);
function segment_height(radius, chord) = radius*(1-cos(asin(chord/2/radius)));

function tab(width,step) = width/2-step/2;
function stem(width,step) = width/3-step/2;
function min_angle(width,step,minimum) = asin((minimum/2+stem(width,step)/2)/(tab(width,step)/2+minimum/2));
function tab_offset(width,step,minimum)=(stem(width,step)/2+minimum/2)/tan(min_angle(width,step,minimum));
function height(width,step,minimum)=tab_offset(width,step,minimum)+tab(width,step)/2+minimum/2+step/2;

puzzle_padding=0.1;
puzzle_fn=200;

module dirror_x(x=0) {
    children();
    mirror([1,0])
    children();
}

module negative_puzzle_blank(width,minimum=0,step=0,this_step=0,gap=0,stem_h=0,pad=puzzle_padding,fn=puzzle_fn,bit=0) {
    tab=tab(width,step);
    stem=stem(width,step);
    min_angle=min_angle(width,step,minimum);
    tab_offset=tab_offset(width,step,minimum);

    $fn=puzzle_fn;

    difference() {
        union() {
            //translate([0,tab/2-segment_height(tab/2,stem)+stem_h]) {
            translate([0,tab_offset+minimum/2]) {
                circle(d=tab+this_step+gap);
                //dirror_x() rotate([0,0,min_angle]) translate([0,-tab/2-minimum/2]) circle(d=minimum);
            }

            hull()
            dirror_x()
            translate([0,tab_offset+minimum/2])
            rotate([0,0,180+min_angle])
            square([1,tab/2+minimum/2]);


            
            translate([0,minimum/4-pad/2-bit/2])
            square([stem+minimum,minimum/2+pad+bit],center=true);

            // bottom square
            translate([-width/2-pad-bit/2,-pad-bit])
            square([width+pad*2+bit,this_step/2+pad+gap/2+bit]);


        }
        // cut in grips
        translate([0,tab_offset+minimum/2])
        dirror_x()
        rotate([0,0,min_angle])
        translate([0,-tab/2-minimum/2])
        circle(d=minimum-this_step-gap);
    }
}

module negative_puzzle_blank_step(width,minimum=0,step=0,this_step=0,gap=0,stem_h=0,pad=puzzle_padding,fn=puzzle_fn,bit=0) {
    difference() {
        negative_puzzle_blank(width,minimum,step,step,gap,stem_h,pad,fn,bit);
        negative_puzzle_blank(width,minimum,step,-bit,gap,stem_h,pad,fn,bit);
    }
}

module negative_puzzle_tab(width,minimum=0,step=0,this_step=0,gap=0,stem_h=0,pad=puzzle_padding,fn=puzzle_fn) {
    tab=tab(width,step);
    stem=stem(width,step);
    min_angle=min_angle(width,step,minimum);
    tab_offset=tab_offset(width,step,minimum);
    height=height(width,step,minimum);

    $fn=puzzle_fn;
    
    translate([0,-height])
    difference() {
        translate([-width/2-pad,0])
        square([width+pad*2,height+pad]);
        negative_puzzle_blank(width,minimum,step,this_step,gap,stem_h,pad,fn);
    }
}

module negative_puzzle_tab_step(width,minimum=0,step=0,this_step=0,gap=0,stem_h=0,pad=puzzle_padding,fn=puzzle_fn,bit=0) {
    tab=tab(width,step);
    stem=stem(width,step);
    min_angle=min_angle(width,step,minimum);
    tab_offset=tab_offset(width,step,minimum);
    height=height(width,step,minimum);

    $fn=puzzle_fn;
    
    translate([0,-height])
    intersection() {
        difference() {
            translate([-width/2-pad,0])
            square([width+pad*2,height+bit+pad]);
            negative_puzzle_blank(width,minimum,step,this_step,gap,stem_h,pad,fn);
        }
        negative_puzzle_blank(width,minimum,step,step,gap+bit,stem_h,pad,fn);
    }
}

