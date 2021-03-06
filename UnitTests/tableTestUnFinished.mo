within solarGreenhouseV2.UnitTests;
model tableTestUnFinished
  "test of using data from a table into record"
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="tab1",
    fileName="C:/Users/carlj/Documents/dymolaModels/solcast3monthtestP.txt",
    columns=1:20)
    annotation (Placement(transformation(extent={{-140,64},{-120,84}})));
  Modelica.Blocks.Sources.RealExpression airTempC(y=combiTimeTable.y[2])
    "air Temp" annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Sources.RealExpression azimuthDeg(y=combiTimeTable.y[3])
    annotation (Placement(transformation(extent={{-100,52},{-80,72}})));
  Modelica.Blocks.Sources.RealExpression Dhi(y=combiTimeTable.y[6])
    annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
  Modelica.Blocks.Sources.RealExpression Dni(y=combiTimeTable.y[7])
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.RealExpression zenithDeg(y=combiTimeTable.y[16])
    annotation (Placement(transformation(extent={{-70,38},{-50,58}})));
  Components.Weather weather(P=Params)
    annotation (Placement(transformation(extent={{-10,42},{38,98}})));
  Modelica.Blocks.Sources.RealExpression skyTempC(y=combiTimeTable.y[18])
    annotation (Placement(transformation(extent={{-70,62},{-50,82}})));
  Components.Soil soil(P=Params, C=Consts)
    annotation (Placement(transformation(extent={{2,-66},{22,-46}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T=6)
    annotation (Placement(transformation(extent={{-20,-92},{0,-72}})));
  Flows.greyBodyRadiation greyBodyRadiation(
    epsilon_a=1,
    epsilon_b=1,
    A_a=1,
    A_b=1,
    AF=1) annotation (Placement(transformation(extent={{52,-56},{72,-36}})));
  Flows.greyBodyRadiation greyBodyRadiation1(
    epsilon_a=1,
    epsilon_b=1,
    A_a=1,
    A_b=1,
    AF=1) annotation (Placement(transformation(extent={{84,-46},{
            104,-26}})));
  parameter physicalConstants Consts
    annotation (Placement(transformation(extent={{-104,-96},{-84,-76}})));
  parameter greenhouseParameters Params(
    deepSoilTemp=279.15,
    floorArea=2,
    soilDepth=0.4,
    soilEmissivity=0.8)
    annotation (Placement(transformation(extent={{-106,-76},{-86,-56}})));
  Modelica.Blocks.Sources.RealExpression relativeHumidityPercent(y=combiTimeTable.y[
        11]) annotation (Placement(transformation(extent={{-100,2},{-80,22}})));
  Modelica.Blocks.Sources.RealExpression snowdepth(y=combiTimeTable.y[12])
    annotation (Placement(transformation(extent={{-98,-16},{-78,4}})));
  Modelica.Blocks.Sources.RealExpression windspeed(y=combiTimeTable.y[15])
    annotation (Placement(transformation(extent={{-100,-36},{-80,-16}})));
equation

  connect(fixedTemperature.port, soil.port_b) annotation (Line(points={{0,-82},
          {4,-82},{4,-68},{-2,-68},{-2,-64.8},{5.8,-64.8}},
                                                    color={191,0,0}));
  connect(greyBodyRadiation.port_a, soil.port_a) annotation (Line(points={{52,-46},
          {26,-46},{26,-42},{-2,-42},{-2,-51},{5.6,-51}}, color={191,0,0}));
  connect(greyBodyRadiation1.port_a, soil.port_a) annotation (Line(points={{84,-36},
          {76,-36},{76,-32},{4,-32},{4,-42},{-2,-42},{-2,-51},{5.6,
          -51}},                                     color={191,0,0}));
  connect(weather.relativeHumidityIn, relativeHumidityPercent.y) annotation (Line(
        points={{-7.12,43.68},{-34,43.68},{-34,12},{-79,12}}, color={0,0,127}));
  connect(weather.snowDepthIn, snowdepth.y) annotation (Line(points={{-7.12,36.4},{
          -32,36.4},{-32,-6},{-77,-6}}, color={0,0,127}));
  connect(weather.windSpeedIn, windspeed.y) annotation (Line(points={{-7.12,29.12},
          {-30,29.12},{-30,-26},{-79,-26}}, color={0,0,127}));
  connect(airTempC.y, weather.airTempIn) annotation (Line(points={{-79,80},{-74,80},
          {-74,92.4},{-7.12,92.4}}, color={0,0,127}));
  connect(skyTempC.y, weather.skyTempIn) annotation (Line(points={{-49,72},{-44,72},
          {-44,84},{-7.12,84}}, color={0,0,127}));
  connect(weather.azimuthDegIn, azimuthDeg.y) annotation (Line(points={{-7.12,75.6},
          {-42,75.6},{-42,62},{-79,62}}, color={0,0,127}));
  connect(weather.zenithDegIn, zenithDeg.y) annotation (Line(points={{-7.12,67.2},{
          -40,67.2},{-40,48},{-49,48}}, color={0,0,127}));
  connect(weather.dhiIn, Dhi.y) annotation (Line(points={{-7.12,59.36},{-38,59.36},
          {-38,34},{-74,34},{-74,46},{-79,46}}, color={0,0,127}));
  connect(weather.dniIn, Dni.y) annotation (Line(points={{-7.12,51.52},{-36,51.52},
          {-36,30},{-79,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end tableTestUnFinished;
