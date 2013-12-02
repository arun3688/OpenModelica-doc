model heatPID
  record Room
    extends DomainBlock3D;
    Region0D sensorPosition(shape = shapeFunc, range = {{1,1},{0.5,0.5},{0.5,0.5}})  ;
  end Room

  parameter Real lx = 1, ly = 1, lz = 1;
  Room room(Lx=lx, Ly=ly, Lz=lz);
  field Real T(domain = room, start = Tout);
  field Real[3] W(domain = room, start = {0,0,0});
  parameter Real c = 1012, rho = 1.204, lambda = 0.0257;
  parameter Real Tout = 0, kappa = 0.2;
  Real Ts, P, eInt;
  parameter Real kp = 100, ki = 200, kd = 100, Td = 20;
 equation
  1/(c*rho)*diverg(W) = - pder(T,t)    in room.interior;
  W = -lambda*grad(T)                  in room.interior;
  W*region.n = P/(lx*ly)               in room.left;
  W*region.n = 0                       in room.front, room.rare, room.top, room.bottom;
  W*region.n = kappa*(T - Tout)        in room.right;
  Ts = T                               in room.sensorPosition;
  e = Td - Ts;
  der(eInt) = e;
  P = kp*e + ki*eInt + kd*der(e);
end heatPid;