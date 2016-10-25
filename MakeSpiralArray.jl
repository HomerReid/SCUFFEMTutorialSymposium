###################################################
# Simple julia routine to write a SCUFF-EM geometry file
# describing a Vogel array of particles.
#
# Usage example:
#
#  julia> MakeSpiralArray(1000, "Disc8", SpiralType="GSpiral")
#
# to make a 1000-particle G-spiral geometry with each particle 
# described by meshfile "Disc8.msh".
#
# SpiralType = {"GSpiral","A1Spiral","A2Spiral"}
#
###################################################
function MakeSpiralArray(N,MeshFileBase; SpiralType="GSpiral", a=0.2268, OutFileBase=0)

  ##################################################
  ##################################################
  ##################################################
  Alpha = (    (SpiralType=="A1Spiral") ? 137.3
             : (SpiralType=="A2Spiral") ? 137.6
             :                            137.50776405;
          );
  Alpha *= pi/180.0;

  ##################################################
  ##################################################
  ##################################################
  if (OutFileBase==0)
    OutFileBase=string(MeshFileBase,"_",SpiralType,N);
  end
  FileName=string(OutFileBase,".scuffgeo");
  f=open(FileName,"w");

  ##################################################
  ##################################################
  ##################################################
  ParticleRadius=0.1;
  AvgDelta=0.0;
  Lastx=0.0;
  Lasty=0.0;
  Maxx=0.0;
  for n=0:N-1

    r     = a*sqrt(n);
    Theta = n*Alpha;
    x     = r*cos(Theta);
    y     = r*sin(Theta);
   
    CenterCenterSeparation = sqrt( (x-Lastx)^2 + (y-Lasty)^2 );
    EdgeEdgeSeparation=CenterCenterSeparation - 2*ParticleRadius;
    if (n>0)
     AvgDelta += EdgeEdgeSeparation
    end
    Lastx=x;
    Lasty=y;

    @printf(f,"OBJECT Disc%i\n",n);
    @printf(f," MESHFILE %s.msh\n",MeshFileBase);
    @printf(f," DISPLACED %e %e 0.0\n",x,y);
    @printf(f,"ENDOBJECT\n\n");
    if (x>Maxx)
      Maxx=x;
    end

  end
  close(f)
  AvgDelta /= (N-1);

  @printf("Avg interparticle separation %e.\n",AvgDelta);
  @printf("Array dimensions roughly %e x %e microns.\n",2*Maxx,2*Maxx);
  @printf("SCUFF-EM geometry written to %s.\n",FileName);
  @printf("Thank you for your support.\n");

end    
