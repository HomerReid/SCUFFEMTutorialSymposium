//////////////////////////////////////////////////
// GMSH geometry for circular slab/sheet
//
// usage:
//  gmsh -2 [ options] Disc.geo
//
// options: 
//  -setnumber R 0.080      // radius
//  -setnumber T 0.150      // thickness in z-direction (0 for sheet)
//  -clscale XX             // overall scaling factor for mesh resolution
//
// Homer Reid 9/2016
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// user-specifiable parameters 
////////////////////////////////////////////////////

// radius
DefineConstant[ R = 0.080 ];

// thickness
DefineConstant[ T = 0.150 ];

// meshing scale factor
DefineConstant[ MeshScale = 1.0 ];
LS = 0.5*R*MeshScale;

////////////////////////////////////////////////////
// end of user-specifiable parameters 
////////////////////////////////////////////////////
Point(0) = { 0,  0, -T/2, LS};
Point(1) = { R,  0, -T/2, LS};
Point(2) = { 0,  R, -T/2, LS};
Point(3) = {-R,  0, -T/2, LS};
Point(4) = { 0, -R, -T/2, LS};

Circle(1)={1,0,2};
Circle(2)={2,0,3};
Circle(3)={3,0,4};
Circle(4)={4,0,1};
Line Loop(1)={1,2,3,4};

Ruled Surface(1) = {1};

// for the finite-thickness case, extrude in the z direction
If (T!=0)

  NLayers = Ceil[T/LS];
  If (NLayers<2)
   NLayers=2;
  EndIf
  Extrude {0,0,T} { Surface{1}; Layers{NLayers}; }

EndIf
