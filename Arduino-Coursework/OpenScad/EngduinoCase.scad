// Base of Engduino case
// Units in mm , e.g. 85 = 85mm
// Parts are connected together using super glue

use <write.scad>

// 1. Main body

difference() {
	color([2,1,1])
	cube([85, 65, 0.5], center = true);
	// Thin cube for transparency so lights on Engduino may be seen
	translate([55, 40, 0]) {
		rotate([0, 0, 45]) {
			cube([40,40,50], center = true);
		}	
	}
	translate([-55, 40, 0]) {
		rotate([0, 0, 45]) {
			cube([40,40,50], center = true);
		}
	}
	translate([-55, -40, 0]) {
		rotate([0, 0, 45]) {
			cube([40,40,50], center = true);
		}
	}
	translate([55, -40, 0]) {
		rotate([0, 0, 45]) {
			cube([40,40,50], center = true);
		}
	}
}

// 2. Straight vertical sides

difference() {
color([2,1,1])
translate([-35,32.5, 0], center = true) {
	cube([71,4,20]);
}
translate([-45,24,0], center = true) {
	rotate([0,0,45]){
	cube([16,4,20]);
	}
}
for (p = [-30, 4, -14]) {
color([2,1,1])
translate([p, 38.25, -3]) {
	cylinder(h = 30, r1 = 4, r2 = 4, centre = true);
	}
}
}

difference() {
color([2,1,1])
translate([-36,-36.5, 0], center = true) {
	cube([70,4,20]);
}
translate([40,-37, 0], center = true) {
	rotate([0,0,135]){
	cube([71,4,20]);
	}
}
for (p = [-30, 4, -14]) {
translate([p, -38.25, -3]) {
	cylinder(h = 30, r1 = 4, r2 = 4, centre = true);
	}
}
}

difference() {
color([2,1,1])
translate([-42.5,-25.75,0], center = true) {
	rotate([0,0,90]) {
		cube([51,4,20]);
	}
}
translate([-45,24,0], center = true) {
	rotate([0,0,45]){
	cube([16,4,20]);
	}
}
}

// 3. Diagonal vertical sides

// 3.1. Modified diagonal side 
// 		Needed for attaching the Lid/Cover

difference() {
color([2,1,1])
translate([-43.6,22.5,0], center = true) {
	rotate([0,0,45]){
	cube([16,2,20]);
	}
}
translate([-36,28,17.5], center = true) {
	rotate([0,0,135]){
	cube([7, 1.4, 5]);
	}
}
translate([-39,30,17], center = true) {
	sphere(r = 1.7);
}
}

color([2,1,1])
translate([46.5,25.9,0], center = true) {
	rotate([0,0,135]){
	cube([15,4,20]);
	}
}

color([2,1,1])
translate([-33,-33.5,0], center = true) {
	rotate([0,0,135]){
	cube([15,4,20]);
	}
}

// 4. Hole for Switch

difference () {
color([2,1,1])
translate([46.5,-24,0], center = true) {
	rotate([0,0,90]){
	cube([49.9,4,20]);
	}
}
translate([50.5,-25.75,0], center = true) {
		rotate([0,0,100]) {
			cube([30, 4, 20]);
		}
	}
translate([45.25, -4,0], center = true) {
		rotate([0,0,80]) {
			cube([30, 4, 20]);
		}
	}
translate([45.25, -4,0], center = true) {
		rotate([0,0,0]) {
			cube([10, 10, 20]);
		}
	}
translate([50,-27.5, 0], center = true) {
	rotate([0,0,135]){
	cube([71,4,20]);
	}
}
}

// 5. Part that will fit into the modified diagonal side

difference() {
color([2,1,1])
translate([-50,70,0], center = true) {
	rotate([90,0,0]){
	cube([16,2,20]);
	}
}
translate([-42,66,2], center = true) {
	sphere(r = 1.7);
	}
}

// 6. Parts connecting lid with main body

// 6.1. Ball/Pivot

for (a = [66, 5, 71])  {
difference () {
color([1,2,1])
translate([0,a,0], center = true) {
	sphere(r = 1.6);
	}
translate([-3, a - 3, -3.2], centre = true) {
	cube([5, 5, 3.2]);
	}
translate([-20, 0, 0], centre = true) {
	cube([50, 50, 50]);
	}
}
}

// 6.2 Hinge connecting to Ball/Pivot

for (b = [-5, -5, -10]) {
difference () {
color([1,2,1])
translate([b, 68, 0], centre = true){
	rotate([90, 0, 0]){
	cylinder(h = 12, r1 = 0.65, r2 = 0.65, centre = true);
	}
}
translate([-5 + b, 54, -8], centre = true){
	cube([8, 20, 8]);
	}
}
}

// 7. Lid/Cover

difference() {
	color([1,2,1])
	translate([0, 200, 2]) {
		cube([80.5, 60.5, 2], center = true);
	}
	translate([55, 240, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}	
	}
	translate([-55, 240, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([-55, 160, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([55, 160, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([-38, 172, 3], centre = true){
	rotate([90, 216, 135]){
	cylinder(h = 12, r1 = 0.65, r2 = 0.65, centre = true);
	}
}
}

difference() {
	color([1,2,1])
	translate([0, 120, 2]) {
		cube([80.5, 60.5, 2], center = true);
	}
	translate([55, 160, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}	
	}
	translate([-55, 160, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([-55, 80, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([55, 80, 2]) {
		rotate([0, 0, 45]) {
			cube([44.5,44.5,50], center = true);
		}
	}
	translate([-38, 148, 3], centre = true){
	rotate([90, 216, 45]){
	cylinder(h = 12, r1 = 0.65, r2 = 0.65, centre = true);
	}
}
}

// 8. Engduino Logo

difference() {
	color([1,2,2])
	translate([100,30,0]){
		write("engduino",t=10.5,h=10,center=true);translate([0,0,0]);
	}
	translate([30,0,-100]) {
	cube([100,100,100]);
	}
}

color([2,2,1])
translate([70,20,0]) {
	cube([60, 18,2]);
}