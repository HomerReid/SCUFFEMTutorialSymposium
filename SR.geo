DefineConstant [ T = 2 ];
DefineConstant [ W = 4 ];
DefineConstant [ Q = 14 ];
DefineConstant [ P = 22 ];
DefineConstant [ R = 24 ];
DefineConstant [ S = 22 ];
DefineConstant [ L = 1 ];

Point(1) = { S,   T,   0, L };
Point(2) = { S+R, T,   0, L };
Point(3) = { S+R, T+W, 0, L };
Point(4) = { S+W, T+W, 0, L };
Point(5) = { S+W, T+P-W, 0, L };
Point(6) = { S+R, T+P-W, 0, L };
Point(7) = { S+R, T+P+Q, 0, L };
Point(8) = { S,   T+P+Q, 0, L };
Point(9) = { S,   T+P+Q-W, 0, L };
Point(10) = { S+R-W,   T+P+Q-W, 0, L };
Point(11) = { S+R-W,   T+P, 0, L };
Point(12) = { S,   T+P, 0, L };

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,5};
Line(5) = {5,6};
Line(6) = {6,7};
Line(7) = {7,8};
Line(8) = {8,9};
Line(9) = {9,10};
Line(10) = {10,11};
Line(11) = {11,12};
Line(12) = {12,1};

Line Loop(1) = {1,2,3,4,5,6,7,8,9,10,11,12};
Ruled Surface(1) = {1};

