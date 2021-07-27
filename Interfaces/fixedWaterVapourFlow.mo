within solarGreenhouseV2.Interfaces;
model fixedWaterVapourFlow "testing source of water vapor"

  parameter Modelica.Units.SI.MassFlowRate M_flow
    "Fixed heat flow rate at port";
  parameter Modelica.Units.SI.PartialPressure VP = Modelica.Media.Air.MoistAir.saturationPressure(300)
    "Reference pressure";
  parameter Real alpha=0
    "pressue coefficient of mass flow rate";

  WaterMassPort_a waterMassPort_a annotation (Placement(
        transformation(extent={{-8,-8},{12,12}})));
equation
  waterMassPort_a.MV_flow = -M_flow*(1 + alpha*(waterMassPort_a.VP - VP))
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-42,66},{48,-66}},
          lineColor={0,0,255},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end fixedWaterVapourFlow;
