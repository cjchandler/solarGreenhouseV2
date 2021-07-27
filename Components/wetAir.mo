within solarGreenhouseV2.Components;
model wetAir
  "bulk air volume, with humidity, no inputs "
      /******************** Parameters ********************/
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;

  Modelica.Units.SI.Temperature T(start = 286.15);
  Modelica.Units.SI.HeatCapacity c_humidair;
  Real RH "relative humidity";
  Modelica.Units.SI.Density AH( start = 0.004)  "absolute humidity in kg/m3";
  Modelica.Units.SI.PartialPressure vP "water vapour partial pressure";
  Modelica.Units.SI.Pressure Psat "water saturation pressure at this temperature";
  Modelica.Units.SI.Temperature dew_point_temp;

  parameter Modelica.Units.SI.Density rho= C.air_density;
  parameter Modelica.Units.SI.Volume V = P.air_volume "air volume";
  parameter Modelica.Units.SI.Pressure p = C.atm "about 1 atm of pressure";



  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation (
          Placement(transformation(extent={{-34,-22},{-14,-2}}), iconTransformation(
              extent={{-34,-22},{-14,-2}})));
  Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
        transformation(extent={{14,-22},{34,-2}})));

equation
  solarGreenhouseV2.Functions.saturatedVapourPressure(dew_point_temp) =
    vP;
  AH = C.A*vP/T;
  Psat = solarGreenhouseV2.Functions.saturatedVapourPressure(T);
  RH = vP/Psat;
  c_humidair = C.air_specific_heat_capacity*V*rho + C.water_vapour_specific_heat_capacity*V*AH;

  T = heatPort_a.T;
  der(T)*c_humidair = heatPort_a.Q_flow;

  waterMassPort_a.VP = vP;
  der(AH)*V = waterMassPort_a.MV_flow;


      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Ellipse(
              extent={{-64,52},{64,-76}},
              lineColor={28,108,200},
              fillColor={170,255,255},
              fillPattern=FillPattern.Sphere), Text(
          extent={{-48,-26},{48,-58}},
          textColor={28,108,200},
          textString="%name")}),                 Diagram(coordinateSystem(
              preserveAspectRatio=false)));
end wetAir;
