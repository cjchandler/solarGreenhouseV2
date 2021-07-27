within solarGreenhouseV2.UnitTests;
model canopyTestUnfinished
    //I put these parameters in explicitly so that even if I change params so an example it won't mess up this unit test
  parameter physicalConstants Consts
    annotation (Placement(transformation(extent={{-100,66},{-80,86}})));
  parameter greenhouseParameters Params annotation (Placement(
        transformation(extent={{-100,42},{-80,62}})));

   Modelica.Units.SI.HeatFlowRate PAR_incident[2] = { 45,  45};
   Modelica.Units.SI.HeatFlowRate NIR_incident[2] = {55,  55};

  Components.CanopyTranspiring canopyTranspiring(
    P=Params,
    C=Consts,
    PAR_incident_vec = PAR_incident,
    NIR_incident_vec = NIR_incident) annotation (Placement(transformation(extent={{-32,4},
            {-12,24}})));

  Interfaces.fixedWaterVapourFlow fixedWaterVapourFlow(M_flow=0)
    annotation (Placement(transformation(extent={{44,-44},{64,-24}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    fixedTemperature(T=293.15) annotation (Placement(
        transformation(extent={{42,44},{62,64}})));
  Real Q_test;
equation
  Q_test = 45*0.8 + 45*0.8 + 55*0.8 + 55*0.8;
  when time > 0.5 then
     assert( Q_test==canopyTranspiring.port_a.Q_flow,    " check");
  end when;

  connect(fixedWaterVapourFlow.waterMassPort_a, canopyTranspiring.waterMassPort)
    annotation (Line(points={{54.2,-33.8},{54.2,0},{-20,0},{-20,9.8}},
                     color={0,0,255}));
  connect(fixedTemperature.port, canopyTranspiring.port_a)
    annotation (Line(points={{62,54},{66,54},{66,14},{-20,14}},
                     color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4320000, __Dymola_Algorithm="Dassl"));
end canopyTestUnfinished;
