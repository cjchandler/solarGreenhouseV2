within solarGreenhouseV2.Components;
model heater
  "control air heater based on air temperature"
  parameter solarGreenhouseV2.physicalConstants C;
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter  Modelica.Units.SI.Temperature setTemp;
  Modelica.Units.SI.Temperature T "inside air temperature";

  Real heating_power;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-70,2},{-50,22}})));
equation
  T = port_a.T;
  port_a.Q_flow = -heating_power;
  heating_power = max(solarGreenhouseV2.Functions.onBeforeSwitchVal(
    T,
    setTemp,
    1000)*1000, 0);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-64,80},{82,-56}},
          lineColor={175,175,175},
          lineThickness=1), Ellipse(
          extent={{-52,64},{0,14}},
          lineColor={175,175,175},
          lineThickness=1,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end heater;
