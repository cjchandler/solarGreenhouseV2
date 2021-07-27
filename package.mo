within ;
package solarGreenhouseV2 "version 2  of a model for solar greenhouse"
annotation (Icon(graphics={
      Line(points={{-52,-54},{-52,6},{8,36},{8,-52},{-52,-52},{-52,-54}}, color=
           {28,108,200}),
      Polygon(
        points={{-24,-16},{-32,-24},{-28,-30},{-24,-34},{-18,-32},{-18,-24},{
            -10,-12},{-16,-4},{-24,-2},{-18,-8},{-16,-14},{-22,-14},{-24,-22},{
            -24,-26},{-22,-26},{-24,-16}},
        lineColor={28,108,200},
        fillColor={61,255,90},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{-14,-18},{-10,-22}},
        lineColor={28,108,200},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-24,-34},{-26,-48}},
        lineColor={28,108,200},
        fillColor={0,255,0},
        fillPattern=FillPattern.Solid)}), uses(Modelica(version="4.0.0")));
end solarGreenhouseV2;
