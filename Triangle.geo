//////////////////////////////////////////////////
// GMSH geometry for rounded triangular slab/sheet
//
// usage:
//  gmsh -2 [ options] Triangle.geo
//
// options: 
//  -setnumber L 0.300      // triangle side length in microns
//  -setnumber R 0.025      // corner rounding radius
//  -setnumber T 0.150      // slab thickness in z-direction (0 for sheet)
//  -clscale XX             // overall scaling factor for mesh resolution
//
// Homer Reid 9/2016
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// user-specifiable parameters 
////////////////////////////////////////////////////

// side length
DefineConstant[ L = 0.300 ];

// corner rounding radius
DefineConstant[ R = 0.025 ];

// thickness
DefineConstant[ T = 0.150 ];

// meshing lengthscale
LS = 0.2*L;

////////////////////////////////////////////////////
// end of user-specifiable parameters 
////////////////////////////////////////////////////

// define first point of triangle to lie at the origin
Point(1) = {0, 0, -T/2, LS};

// extrude through circular arcs to define a rounded corner
Extrude { {0,0,1}, {0, 2*R, 0}, +Pi/3 } { Point{1}; }
Extrude { {0,0,1}, {0, 2*R, 0}, -Pi/3 } { Point{1}; }

// replicate the lines (really "arcs") just created
// to define the other two triangle corners
Rotate { {0,0,1}, {0,R+L*Sqrt[3]/4, 0}, +2*Pi/3  } { Duplicata{Line{1,2}; }}
Rotate { {0,0,1}, {0,R+L*Sqrt[3]/4, 0}, -2*Pi/3  } { Duplicata{Line{1,2}; }}

// connect endpoints to define a closed loop bounding a surface
Line(10) = {2,12};
Line(11) = {7,20};
Line(12) = {15,4};
Line Loop(1) = {1, 10, -4, 3, 11, -6, 5, 12, -2};
Plane Surface(1) = {1};

// for the finite-thickness case, extrude in the z direction
If (T!=0)
  Extrude {0,0,T} { Surface{1}; }
EndIf
