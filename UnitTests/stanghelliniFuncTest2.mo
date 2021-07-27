within solarGreenhouseV2.UnitTests;
model stanghelliniFuncTest2
  "testing the example of transpiration from a leaf surface on pg. 44 fig stanghellini 1987"
 parameter Real re = 200;
 parameter Real ri = 200;
 parameter Real T_air = 293.15;
 parameter Real RH =  0.75;
 Real rR  "This defined by eq 2.65";
 parameter Real gamma = 66;
 parameter Real rho_a= 1.225;
 parameter Real cp = 1000;
 Real Psat;
 Real vP;
 parameter Real Rnet = 500;
 Real LE;
 Real LE_R;
 Real H_def "eq 2.36 ";
 Real LE_def "this is LE as defined in the begning, func of re,ri and VPD, not explicitly on R";
 Real deltaOverGamma;
 Real T_canopy;
 Real T_canopyrR;

 Real dT "temperature diff T_leaf-T_air";
 Real dT_with_rR;
 Real powerSum_def;
 Real powerSum;
 Real power_thermal_radiation;

  parameter physicalConstants Consts annotation (Placement(transformation(
          extent={{-122,24},{-102,44}})));
  parameter greenhouseParameters Params annotation (Placement(transformation(
          extent={{-124,-4},{-104,16}})));
equation
  power_thermal_radiation =Modelica.Constants.sigma*(T_canopy^4 - T_air^4);
  rR = cp*rho_a/( 4*Modelica.Constants.sigma*T_air^3);//eq 2.65
  Psat = solarGreenhouseV2.Functions.saturatedVapourPressure( T_air);
  RH = vP/Psat;
  (LE,deltaOverGamma,LE_R,T_canopy,T_canopyrR) =
    solarGreenhouseV2.Functions.leafStanghelliniLE(
    re,
    ri,
    Rnet,
    Psat - vP,
    T_air,
    rR);
  dT = T_canopy-T_air;
  dT_with_rR = T_canopyrR - T_air
    annotation (Placement(transformation(extent={{-24,4},{-4,24}})),
              Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  LE_def = rho_a*cp*(
    solarGreenhouseV2.Functions.saturatedVapourPressure(T_canopy)
     - vP)/(gamma*(re + ri));                                                                                  //eq 2.21
  H_def = rho_a*cp*(T_canopy - T_air)/re;

  powerSum_def = Rnet - LE_def -H_def;
  powerSum = Rnet - LE -H_def;

  assert( 190 <LE_R and LE_R < 210, "range taking from fig by stanghellini pg 44 1987");

end stanghelliniFuncTest2;
