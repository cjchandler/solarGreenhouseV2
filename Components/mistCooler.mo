within solarGreenhouseV2.Components;
model mistCooler
  "spray water into the air for cooling, connect ports to air directly"
  parameter solarGreenhouseV2.physicalConstants C;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a
    port_a annotation (Placement(transformation(extent={{-62,
            -42},{-42,-22}})));
  Interfaces.WaterMassPort_a waterMassPort_a annotation (
      Placement(transformation(extent={{-62,-4},{-42,16}})));
  parameter Modelica.Units.SI.Temperature set_temperature = 29+273.15;
equation
  port_a.Q_flow =  -waterMassPort_a.MV_flow*C.lambda "when water evaporates out of the mister, heat flows out of the air";
  -waterMassPort_a.MV_flow = max( 0,  solarGreenhouseV2.Functions.onAfterSwitchVal( port_a.T,  set_temperature,  100) *( 0.000001*( port_a.T - set_temperature)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end mistCooler;
