within solarGreenhouseV2.Components;
model CanopyTranspiring
  "plant leaves and vines heat and water out. 
  
  inputs: NIR_absorbed,PAR_absorbed,
  
  this uses P.panel_canopy_absorptions which is all absorbtion from light coming from that panel. In practice panel canopy absorbtion is a complex function of sun angle, panel, soil albedo etc."
  parameter solarGreenhouseV2.greenhouseParameters P;
  parameter solarGreenhouseV2.physicalConstants C;

  input Modelica.Units.SI.HeatFlowRate PAR_absorbed "refer to light absorbtion model for how much light absorbed"  annotation (Dialog);

  input Modelica.Units.SI.HeatFlowRate NIR_absorbed "refer to light absorbtion model for how much light absorbed"  annotation (Dialog);

  Modelica.Units.SI.HeatFlux PARNIR_flux_absorbed "PAR and NIR absorbed per m2 of floor area";
  Real LAI "leaf area index, default at 3, in future this is determined by a plant growth and yield model included in canopy model";
  Modelica.Units.SI.Temperature T "canopy leaf temperature";


  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(
        transformation(extent={{10,-10},{30,10}}), iconTransformation(extent={{10,-10},
            {30,10}})));
  Interfaces.WaterMassPort_a waterMassPort annotation (Placement(
        transformation(extent={{10,-52},{30,-32}}),
        iconTransformation(extent={{10,-52},{30,-32}})));


  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow annotation (Placement(transformation(extent=
           {{-72,-2},{-52,18}})));
equation

  PARNIR_flux_absorbed = (PAR_absorbed + NIR_absorbed)/P.floor_area;
  prescribedHeatFlow.Q_flow = PAR_absorbed + NIR_absorbed;
  port_a.T = T;
  LAI = 3;
  waterMassPort.VP =
    solarGreenhouseV2.Functions.saturatedVapourPressure(T);

  connect(prescribedHeatFlow.port, port_a) annotation (Line(points=
         {{-52,8},{4,8},{4,0},{20,0}}, color={191,0,0}));
  annotation (Dialog(group="Varying inputs"),
                  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Polygon(
              points={{-6,-72},{-6,-18},{-8,-16},{-12,-18},{-18,-20},{-24,-14},{-20,-10},
                  {-12,-10},{-6,-10},{-4,-16},{-8,6},{-16,10},{-30,6},{-30,14},{-20,18},
                  {-10,20},{-8,12},{-4,32},{-6,44},{-16,42},{-24,38},{-32,42},{-26,48},
                  {-12,54},{-6,52},{-4,46},{-2,68},{-10,76},{-16,78},{-16,84},{-16,88},
                  {-6,82},{0,76},{0,82},{2,72},{0,64},{14,68},{16,64},{12,58},{10,56},{
                  6,58},{2,58},{0,58},{-2,46},{-2,42},{6,46},{14,46},{16,40},{18,34},{12,
                  34},{6,38},{2,38},{-2,34},{-2,28},{-6,14},{4,16},{10,10},{10,8},{2,6},
                  {-4,8},{-6,8},{-2,-14},{4,-16},{14,-18},{16,-24},{14,-30},{6,-26},{4,
                  -24},{0,-22},{-2,-20},{-2,-22},{-6,-72}},
              lineColor={0,140,72},
              fillColor={78,217,28},
              fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
              preserveAspectRatio=false)));
end CanopyTranspiring;
