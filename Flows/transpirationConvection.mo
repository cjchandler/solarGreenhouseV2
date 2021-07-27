within solarGreenhouseV2.Flows;
model transpirationConvection
  "flow of heat and water from canopy (filled a) to air (unfilled b),
  Q_flow is Heat flow rate from port_a -> port_b. dT is port_a.T - port_b.T. 
  MV_flow is  Mass flow rate from port_a -> port_b"
  extends solarGreenhouseV2.Flows.element1D;

  parameter solarGreenhouseV2.physicalConstants C;
  parameter solarGreenhouseV2.greenhouseParameters P;
 //input Modelica.Units.SI.HeatFlux Radiation_incident "radiation flux on crops on 1 m2 of floor area"  annotation (Dialog);
  input Modelica.Units.SI.HeatFlux Radiation_absorbed "PAR and NIR radiation flux absorbed by crops on 1 m2 of floor area"  annotation (Dialog);
  parameter Modelica.Units.SI.Area floor_area = P.floor_area "floor area of canopy";
  input Real LAI  annotation (Dialog);
  input Modelica.Units.SI.HeatFlowRate Radiation_thermal "thermal radiation exchanged by canopy with surroundings, usually cooling durring the day. Should be negative for cooling, canopy T > surroundings T"  annotation (Dialog);

  Modelica.Units.SI.HeatFlowRate H "convection heat transfer";
  Modelica.Units.SI.HeatFlowRate LE "latent heat transfer";
  Real re "stanghellini external resistance";
  Real ri "stanghellini internal resistance";
  Real Is "total radiation absorbed by canopy divided by 2LAI";
  Real delta;
  Real VPD "vapour pressure deficit of the air";
  Modelica.Units.SI.Temperature canopy_temp "computed by stanghellini calcualtions";
  parameter Real gamma = C.psychrometric_constant;
  parameter Real cp = C.air_specific_heat_capacity;
  parameter Real rho_a = C.air_density;
  Modelica.Units.SI.HeatFlux Radiation_net;

equation
  Radiation_net = Radiation_absorbed + Radiation_thermal/floor_area;
  Is = Radiation_absorbed/(2.0*LAI);
  re = (1174*(P.leaf_length)^0.5)*(    P.leaf_length*abs(dT) + 207*P.wind_speed_indoors*P.wind_speed_indoors)^(-0.25); //stanghellini87 eq 2.53
  ri = 82*(( Is +4.3)/(Is + 0.54))*( 1 + 0.023*(  Modelica.Units.Conversions.to_degC(HeatPort_a.T) - 24.5)^2)*1.3;

  H = floor_area*2*LAI*rho_a*cp*dT/re;//eq 3.2
  //LE = Radiation_absorbed*floor_area + Radiation_thermal -H;

  //LE =  1e-6*floor_area*C.lambda*( 0.224*Radiation_incident +  12.7*dP*1e3);
  VPD = solarGreenhouseV2.Functions.saturatedVapourPressure(HeatPort_b.T) - MassPort_b.VP;

  delta =solarGreenhouseV2.Functions.slopeOfSaturatedVapourPressure( HeatPort_b.T);
  LE=  floor_area*(  ((delta/gamma)*Radiation_net) + 2*LAI*cp*rho_a*VPD/(gamma*re)) /( 1 +  delta/gamma + ri/re);
  //delta = solarGreenhouseV1.Functions.slopeOfSaturatedVapourPressure(HeatPort_b.T);
  canopy_temp = HeatPort_a.T; //+ ( ((ri+re)/(2*LAI*C.airDensity*C.airSpecificHeatCapacity))*Radiation_absorbed - VPD/gamma) /( 1 +  delta/gamma + ri/re);

  Q_flow = H + LE;
  MV_flow =  max( 0,  LE/C.lambda);

  annotation (Diagram(graphics={Ellipse(
          extent={{-76,28},{80,-36}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.CrossDiag)}), Icon(graphics={
          Ellipse(
          extent={{-74,20},{74,-30}},
          lineColor={28,108,200},
          fillColor={85,255,255},
          fillPattern=FillPattern.CrossDiag), Text(
          extent={{-268,-26},{280,-72}},
          textColor={28,108,200},
          textString="%name")}));
end transpirationConvection;
