within solarGreenhouseV2.Components;
model perscribedWetAir
  "bulk air volume
  
  inputs relative_humidity_percent air_temp"
      /******************** Parameters ********************/
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;
  parameter Modelica.Units.SI.Density rho= C.air_density;
  parameter Modelica.Units.SI.Volume V = P.air_volume "air volume";
  parameter Modelica.Units.SI.Pressure p = C.atm "about 1 atm of pressure";

  Modelica.Units.SI.Temperature T(start = 286.15);
  //Modelica.Units.SI.HeatCapacity c_humidair;
  Real RH "relative humidity";
  Modelica.Units.SI.Density AH( start = 0.004)  "absolute humidity in kg/m3";
  Modelica.Units.SI.PartialPressure vP "water vapour partial pressure";
  Modelica.Units.SI.Pressure Psat "water saturation pressure at this temperature";

  input Real relative_humidity_percent  annotation (Dialog);
  input Real air_temp  annotation (Dialog);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a annotation (
          Placement(transformation(extent={{-34,-22},{-14,-2}}), iconTransformation(
              extent={{-34,-22},{-14,-2}})));

  Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
        transformation(extent={{14,-22},{34,-2}})));
equation
  T = air_temp;
  RH = relative_humidity_percent*0.01;

  AH = C.A*vP/T;
  Psat = 610.94*exp( 17.625*Modelica.Units.Conversions.to_degC(T)/(  Modelica.Units.Conversions.to_degC(T) + 237.3));
  RH = vP/Psat;

  //c_humidair = C.airSpecificHeatCapacity*V*rho + C.waterVapourSpecificHeatCapacity*V*AH;

  T = heatPort_a.T;
  //der(T)*c_humidair = heatPort_a.Q_flow;

  waterMassPort_a.VP = vP;
  //der(AH)*V = waterMassPort_a.MV_flow;

      /*
      p = Modelica.Media.Air.MoistAir.pressure( moistAir);
      T = Modelica.Media.Air.MoistAir.temperature( moistAir);
      waterFraction[1] = Modelica.Media.Air.MoistAir.xsaturation(moistAir);
      moistAir = Modelica.Media.Air.MoistAir.setState_pTX( p,  T,  waterFraction);

      //waterMassPort_a.VP = p*0.00000001;
      //change in water mass of air is equal to water flow in/out
      //der(waterMass) = waterMassPort_a.MV_flow;
      //ideal gas assumption for waterMass to vapourPressure
      //Modelica.Media.Air.MoistAir.xsaturation(moistAir) = waterFraction[1];
      //waterFraction[1] = waterMass/(V*rho);
      //RH = Modelica.Media.Air.MoistAir.relativeHumidity_pTX(p,  T,  waterFraction);


      T = heatCapacitor.T;
      connect(heatCapacitor.port, heatPort_a)
        annotation (Line(points={{34,4},{34,-12},{-24,-12}}, color={191,0,0}));
       */
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
end perscribedWetAir;
