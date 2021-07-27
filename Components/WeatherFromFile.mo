within solarGreenhouseV2.Components;
model WeatherFromFile "all the weather data loaded, no imputs other than tab1 table"

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="tab1",
    fileName="C:/Users/carlj/Documents/dymolaModels/solcast3monthtestP.txt",
    columns=1:20)
    annotation (Placement(transformation(extent={{-90,58},{-70,78}})));
  Modelica.Blocks.Sources.RealExpression airTempC(y=combiTimeTable.y[2])
    "air Temp" annotation (Placement(transformation(extent={{-50,64},{-30,84}})));
  Modelica.Blocks.Sources.RealExpression azimuthDeg1(y=combiTimeTable.y[3])
    annotation (Placement(transformation(extent={{-50,46},{-30,66}})));
  Modelica.Blocks.Sources.RealExpression Dhi(y=combiTimeTable.y[6])
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Sources.RealExpression Dni(y=combiTimeTable.y[7])
    annotation (Placement(transformation(extent={{-50,14},{-30,34}})));
  Modelica.Blocks.Sources.RealExpression zenithDeg1(y=combiTimeTable.y[16])
    annotation (Placement(transformation(extent={{-20,32},{0,52}})));
  Weather            weather
    annotation (Placement(transformation(extent={{40,34},{88,90}})));
  Modelica.Blocks.Sources.RealExpression skyTempC(y=combiTimeTable.y[18])
    annotation (Placement(transformation(extent={{-20,56},{0,76}})));
  Modelica.Blocks.Sources.RealExpression relativeHumidityPercent1(y=combiTimeTable.y[
        11]) annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  Modelica.Blocks.Sources.RealExpression snowdepth(y=combiTimeTable.y[12])
    annotation (Placement(transformation(extent={{-48,-22},{-28,-2}})));
  Modelica.Blocks.Sources.RealExpression windspeed(y=combiTimeTable.y[15])
    annotation (Placement(transformation(extent={{-50,-42},{-30,-22}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_sky_temp annotation (
      Placement(transformation(extent={{38,32},{58,52}}), iconTransformation(
          extent={{38,32},{58,52}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_air_temp annotation (
      Placement(transformation(extent={{36,-18},{56,2}}), iconTransformation(
          extent={{36,-18},{56,2}})));
equation

  port_sky_temp.T = weather.sky_temp;
  port_air_temp.T = weather.air_temp;

  connect(weather.relativeHumidityIn, relativeHumidityPercent1.y) annotation (Line(
        points={{42.88,35.68},{16,35.68},{16,6},{-29,6}}, color={0,0,127}));
  connect(weather.snowDepthIn,snowdepth. y) annotation (Line(points={{42.88,28.4},{
          18,28.4},{18,-12},{-27,-12}}, color={0,0,127}));
  connect(weather.windSpeedIn,windspeed. y) annotation (Line(points={{42.88,21.12},
          {20,21.12},{20,-32},{-29,-32}},   color={0,0,127}));
  connect(airTempC.y,weather. airTempIn) annotation (Line(points={{-29,74},{-24,74},
          {-24,84.4},{42.88,84.4}}, color={0,0,127}));
  connect(skyTempC.y,weather. skyTempIn) annotation (Line(points={{1,66},{6,66},{6,
          76},{42.88,76}},      color={0,0,127}));
  connect(weather.azimuthDegIn, azimuthDeg1.y) annotation (Line(points={{42.88,67.6},
          {8,67.6},{8,56},{-29,56}}, color={0,0,127}));
  connect(weather.zenithDegIn, zenithDeg1.y) annotation (Line(points={{42.88,59.2},
          {10,59.2},{10,42},{1,42}}, color={0,0,127}));
  connect(weather.dhiIn, Dhi.y) annotation (Line(points={{42.88,51.36},{12,51.36},
          {12,28},{-24,28},{-24,40},{-29,40}}, color={0,0,127}));
  connect(weather.dniIn, Dni.y) annotation (Line(points={{42.88,43.52},{14,43.52},
          {14,24},{-29,24}}, color={0,0,127}));
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
end WeatherFromFile;
