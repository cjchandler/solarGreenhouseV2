within solarGreenhouseV2.Components;
model ventingController
  "control venting rate based on air state parameters like RH and T
  
  input venting_flow_rate ACH
  "
  parameter solarGreenhouseV2.physicalConstants C;
  parameter solarGreenhouseV2.greenhouseParameters P;
  input Real T "inside air temperature"  annotation (Dialog);
  input Real RH "inside relative humidity"  annotation (Dialog);

  Real venting_flow_rate;
  Real ACH;

  parameter Real infiltration_ACH = P.inflitration_ACH;
  parameter Real max_ACH = P.max_ACH;
  parameter Modelica.Units.SI.Temperature maxTemp = P.max_temp;

equation
  ACH = 60*60*venting_flow_rate/P.air_volume;
  ACH =  max(infiltration_ACH,  max_ACH*(T-maxTemp));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-64,80},{82,-56}},
          lineColor={175,175,175},
          lineThickness=1), Ellipse(
          extent={{-52,64},{0,14}},
          lineColor={175,175,175},
          lineThickness=1)}),
      Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-74,70},{72,-66}},
          lineColor={175,175,175},
          lineThickness=1), Ellipse(
          extent={{-62,54},{-10,4}},
          lineColor={175,175,175},
          lineThickness=1)}));
end ventingController;
