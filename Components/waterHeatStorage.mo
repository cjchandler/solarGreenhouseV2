within solarGreenhouseV2.Components;
model waterHeatStorage
  parameter solarGreenhouseV2.greenhouseParameters P;



  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-78,0},{-58,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor water( C = P.water_volume_M3_per_M2*1000*P.floor_area*4184, T(
      fixed=true,
      start=293.15))
    annotation (Placement(transformation(extent={{18,-28},{38,-8}})));
  variableThermalResistor variableThermalResistor1( R = Rsi/P.floor_area) annotation (
      Placement(transformation(extent={{-30,-20},{-10,0}})));

  Modelica.Units.SI.Temperature air_temp;
  Modelica.Units.SI.Temperature water_temp;
  Real Rsi;

 // Interfaces.WaterMassPort_a waterMassPort_a annotation (Placement(
 //       transformation(extent={{-78,46},{-58,66}})));
  //Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
  //  latentHeatFlow annotation (Placement(transformation(extent={{-96,
   //         16},{-76,36}})));
equation
  //waterMassPort_a.MV_flow = solarGreenhouseV2.Functions.onAfterSwitchVal( air_temp,  29,  100) *(air_temp -29+273.15)*100;
  //latentHeatFlow.Q_flow = waterMassPort_a.MV_flow*

  Rsi =  + (P.water_Rsi_max)*solarGreenhouseV2.Functions.onAfterSwitchVal( air_temp,  P.water_discharge_temp,  1000)*solarGreenhouseV2.Functions.onBeforeSwitchVal( air_temp, P.water_recharge_temp,  1000)
  + (P.water_Rsi_min)*( 1- solarGreenhouseV2.Functions.onAfterSwitchVal( air_temp,  P.water_discharge_temp,  1000)*solarGreenhouseV2.Functions.onBeforeSwitchVal( air_temp, P.water_recharge_temp,  1000));

  water_temp = water.T;
  air_temp = port_a.T;
  connect(variableThermalResistor1.port_b, water.port) annotation (
     Line(points={{-10,-10},{12,-10},{12,-32},{28,-32},{28,-28}},
        color={191,0,0}));
  connect(variableThermalResistor1.port_a, port_a) annotation (
      Line(points={{-30,-10},{-68,-10},{-68,10}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-48,82},{86,-90}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-138,4},{174,-64}},
          textColor={28,108,200},
          textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end waterHeatStorage;
