within solarGreenhouseV2.Components;
model climateController
  "port a, filled connects directly to insie air, unfilled port b connects to outside air. controlls venting, heating, glazing, blanket deployment to optimise growing conditions
  
  input sun_zenith"
  parameter solarGreenhouseV2.greenhouseParameters Params;
  parameter solarGreenhouseV2.physicalConstants Consts;
  venting venting1(P=Params, C=Consts, flow_rate = venting_flow_rate)
                   annotation (Placement(transformation(extent={{-14,
            -6},{6,14}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-96,-28},{-76,-8}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{78,-30},{98,-10}})));
  Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
        transformation(extent={{-96,14},{-76,34}})));
  Interfaces.WaterMassPort_b waterMassPort_b annotation (Placement(
        transformation(extent={{74,10},{94,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-32,-52})));

  Modelica.Units.SI.HeatFlowRate heater_power "current heater power output";
  Real ACH "current air changes per hour";
  Real venting_flow_rate "air flow in m3/s";
  Modelica.Units.SI.Temperature inside_temp "air temperature in greenhouse";

  Real blanket_fraction;
  input Modelica.Units.SI.Angle sun_zenith annotation (Dialog);

equation
  prescribedHeatFlow.Q_flow = heater_power;
  heater_power =  solarGreenhouseV2.Functions.onBeforeSwitchVal(inside_temp, Params.min_temp,1000)*Params.heater_max_power;


  inside_temp = port_a.T;

  ACH = 60*60*venting_flow_rate/Params.air_volume;
  ACH =  max(Params.inflitration_ACH,   min( Params.max_ACH,  1000*(inside_temp-Params.max_temp)));


  blanket_fraction = 0.00005 + 0.9999*
    solarGreenhouseV2.Functions.onAfterSwitchVal(
    x=sun_zenith,
    switchval=Modelica.Units.Conversions.from_deg(85),
    scaleFactor=500);
  //venting1.flow_rate = venting_flow_rate;

  connect(prescribedHeatFlow.port, port_a) annotation (Line(points=
         {{-42,-52},{-86,-52},{-86,-18}}, color={191,0,0}));
  connect(port_a, venting1.port_a) annotation (Line(points={{-86,-18},
          {-86,3.2},{-10.2,3.2}}, color={191,0,0}));
  connect(venting1.port_b, port_b) annotation (Line(points={{2.6,3.2},
          {88,3.2},{88,-20}}, color={191,0,0}));
  connect(waterMassPort_b, venting1.waterMassPort_b) annotation (
      Line(
      points={{84,20},{84,6.8},{2.6,6.8}},
      color={0,0,255},
      thickness=1));
  connect(venting1.waterMassPort_a, waterMassPort_a) annotation (
      Line(points={{-10.2,6.6},{-86,6.6},{-86,24}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Rectangle(
          extent={{-72,68},{72,-32}},
          lineColor={217,67,180},
          fillColor={175,175,175},
          fillPattern=FillPattern.Sphere),
        Ellipse(
          extent={{-60,56},{-30,26}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Sphere,
          fillColor={175,175,175}),
        Ellipse(
          extent={{-16,56},{14,26}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Sphere,
          fillColor={175,175,175}),
        Ellipse(
          extent={{30,56},{60,26}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Sphere,
          fillColor={175,175,175})}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end climateController;
