within solarGreenhouseV2.Components;
model venting "humid air exchange between inside (filled port a) and outside greenhouse (unfilled port b)
  
  input flow_rate"
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;
  //input Real ACH "air changes per hour";

  input Real flow_rate  annotation (Dialog);
  Modelica.Units.SI.VolumeFlowRate volume_exchange "air exhaused in m3/s";

  Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
        transformation(extent={{-72,16},{-52,36}})));
  Interfaces.WaterMassPort_b waterMassPort_b annotation (Placement(
        transformation(extent={{56,18},{76,38}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    annotation (Placement(transformation(extent={{56,-18},{76,2}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-72,-18},{-52,2}})));

  //inside humidity (port a side)
  Modelica.Units.SI.PartialPressure vP_greenhouse;
  Modelica.Units.SI.PartialPressure vP_outside;

  Modelica.Units.SI.Density AH_greenhouse;
  Modelica.Units.SI.Density AH_outside;

//  Real E_outside "this is enthalpy/sec ot air volume from outside exchanged";
//  Real E_inside "this is enthalpy/sec ot air volume from inside exchanged";

equation
  volume_exchange  = flow_rate;

  //no storage of water
  waterMassPort_a.MV_flow = -waterMassPort_b.MV_flow;
  //set the vapour pressure potential
  vP_greenhouse = waterMassPort_a.VP;
  vP_outside = waterMassPort_b.VP;

  //net water movement is = ouside air water coming in - inside air water going out
  waterMassPort_b.MV_flow = volume_exchange*AH_outside - volume_exchange*AH_greenhouse;

  port_b.Q_flow = -port_a.Q_flow;
  port_b.Q_flow = solarGreenhouseV2.Functions.enthalpyOfHumidAir(
    port_b.T,
    AH_outside,
    volume_exchange) -
    solarGreenhouseV2.Functions.enthalpyOfHumidAir(
    port_a.T,
    AH_greenhouse,
    volume_exchange);

  AH_greenhouse = solarGreenhouseV2.Functions.absoluteHumidity(
    C.A,
    vP_greenhouse,
    port_a.T);
  AH_outside = solarGreenhouseV2.Functions.absoluteHumidity(
    C.A,
    vP_outside,
    port_b.T);

  //c_p_inside = C.airSpecificHeatCapacity*volume_exchange*C.airDensity + C.waterVapourSpecificHeatCapacity*volume_exchange*AH_greenhouse;
  //c_p_outside = C.airSpecificHeatCapacity*volume_exchange*C.airDensity + C.waterVapourSpecificHeatCapacity*volume_exchange*AH_outside;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Ellipse(
          extent={{-4,50},{10,10}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,14},{10,-26}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-7,20},{7,-20}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={21,12},
          rotation=90),
        Ellipse(
          extent={{-7,20},{7,-20}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-13,12},
          rotation=90),
        Rectangle(
          extent={{-40,64},{50,-36}},
          lineColor={175,175,175},
          lineThickness=1)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end venting;
