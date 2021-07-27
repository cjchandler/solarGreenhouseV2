within solarGreenhouseV2.Components;
model Weather "all the weather data inputs in a class"
  Modelica.Units.SI.HeatFlux Dhi;
  Modelica.Units.SI.HeatFlux Dni;
  Modelica.Units.SI.Angle azimuth;
  Modelica.Units.SI.Angle zenith;
  Modelica.Units.SI.Temperature air_temp;
  Modelica.Units.SI.Temperature sky_temp;
  Real relative_humidity_percent;
  Modelica.Units.SI.Length snow_depth "snow depth on ground in m";
  Modelica.Units.SI.Velocity wind_speed;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_skyTemp
    "sky temperature C" annotation (Placement(transformation(extent={{40,20},{60,40}}),
        iconTransformation(extent={{40,20},{60,40}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_airTemp
    "air temperature" annotation (Placement(transformation(extent={{40,-48},{60,-28}}),
        iconTransformation(extent={{40,-48},{60,-28}})));

  Modelica.Blocks.Interfaces.RealInput airTempIn
    annotation (Placement(transformation(extent={{-108,60},{-68,100}})));
  Modelica.Blocks.Interfaces.RealInput skyTempIn
    annotation (Placement(transformation(extent={{-108,30},{-68,70}})));
  Modelica.Blocks.Interfaces.RealInput azimuthDegIn
    annotation (Placement(transformation(extent={{-108,0},{-68,40}})));
  Modelica.Blocks.Interfaces.RealInput zenithDegIn
    annotation (Placement(transformation(extent={{-108,-30},{-68,10}})));
  Modelica.Blocks.Interfaces.RealInput dhiIn
    annotation (Placement(transformation(extent={{-108,-58},{-68,-18}})));
  Modelica.Blocks.Interfaces.RealInput dniIn
    annotation (Placement(transformation(extent={{-108,-86},{-68,-46}})));
  Modelica.Blocks.Interfaces.RealInput relativeHumidityIn
    annotation (Placement(transformation(extent={{-108,-114},{-68,-74}})));
  Modelica.Blocks.Interfaces.RealInput snowDepthIn
    annotation (Placement(transformation(extent={{-108,-140},{-68,-100}})));
  Modelica.Blocks.Interfaces.RealInput windSpeedIn
    annotation (Placement(transformation(extent={{-108,-166},{-68,-126}})));
equation
  air_temp = Modelica.Units.Conversions.from_degC(airTempIn);
  sky_temp =  Modelica.Units.Conversions.from_degC(skyTempIn);
  azimuth = Modelica.Units.Conversions.from_deg( azimuthDegIn);
  zenith = Modelica.Units.Conversions.from_deg(zenithDegIn);
  Dhi = dhiIn;
  Dni = dniIn;
  relative_humidity_percent = relativeHumidityIn;
  snow_depth = snowDepthIn*0.1;
  wind_speed = windSpeedIn;

  port_skyTemp.T = sky_temp;
  port_airTemp.T = air_temp;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-20,28},{24,-16}},
          lineColor={175,175,175},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-100,74},{32,12}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,38},{-8,-26}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Weather;
