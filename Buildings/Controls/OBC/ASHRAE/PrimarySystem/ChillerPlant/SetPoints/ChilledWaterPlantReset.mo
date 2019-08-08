﻿within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints;
block ChilledWaterPlantReset
  "Sequences to generate chilled water plant reset"

  parameter Integer nPum = 2 "Total number of chilled water pumps";
  parameter Modelica.SIunits.Time holTim = 900
    "Time to fix plant reset value";
  parameter Real iniSet = 0 "Initial setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real minSet = 0 "Minimum setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real maxSet = 1 "Maximum setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Modelica.SIunits.Time delTim = 900
    "Delay time after which trim and respond is activated"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Modelica.SIunits.Time samplePeriod = 300
    "Sample period time"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real triAmo = -0.02 "Trim amount"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real resAmo = 0.03
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real maxRes = 0.07
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(group="Trim and respond parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Plant staging status that indicates if the plant is in the staging process"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPlaRes(
    final min=0,
    final max=1,
    final unit="1") "Chilled water plant reset"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond triRes(
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Calculate chilled water plant reset"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample last reset value when there is chiller stage change"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=holTim)
    "Hold the true input with given time"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Check if the input changes from false to true"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch plant reset value depends on if there is chiller stage change"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nPum] "Logical not"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=nPum) "Logical and"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Check if these is any CHW pump is proven on"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

equation
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={255,0,255}));
  connect(TChiWatSupResReq, triRes.numOfReq)
    annotation (Line(points={{-140,20},{10,20},{10,52},{18,52}},
      color={255,127,0}));
  connect(mulAnd.y, not2.u)
    annotation (Line(points={{-38,60},{-22,60}},   color={255,0,255}));
  connect(not2.y, triRes.uDevSta)
    annotation (Line(points={{2,60},{10,60},{10,68},{18,68}},
      color={255,0,255}));
  connect(uChiWatPum, not1.u)
    annotation (Line(points={{-140,60},{-102,60}}, color={255,0,255}));
  connect(triRes.y, triSam.u)
    annotation (Line(points={{42,60},{58,60}}, color={0,0,127}));
  connect(truHol.y, swi.u2)
    annotation (Line(points={{2,-40},{78,-40}}, color={255,0,255}));
  connect(triRes.y, swi.u3)
    annotation (Line(points={{42,60},{50,60},{50,-48},{78,-48}},
      color={0,0,127}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{82,60},{100,60},{100,-20},{60,-20},{60,-32},{78,-32}},
      color={0,0,127}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{2,0},{70,0},{70,48.2}}, color={255,0,255}));
  connect(swi.y, yChiWatPlaRes)
    annotation (Line(points={{102,-40},{140,-40}}, color={0,0,127}));
  connect(uStaCha, truHol.u)
    annotation (Line(points={{-140,-40},{-22,-40}},color={255,0,255}));
  connect(uStaCha, edg.u)
    annotation (Line(points={{-140,-40},{-60,-40},{-60,0},{-22,0}},
      color={255,0,255}));

annotation (
  defaultComponentName="chiWatPlaRes",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-120,-100},{120,100}}),graphics={Rectangle(
          extent={{-118,98},{78,-18}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-108,96},{44,80}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate the plant reset, hold its last value when there is chiller stage change")}),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,68},{-36,56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-94,12},{-10,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="TChiWatSupResReq"),
        Text(
          extent={{-94,-52},{-56,-66}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaCha"),
        Text(
          extent={{38,12},{96,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPlaRes")}),
Documentation(info="<html>
<p>
Block that output chilled water plant reset <code>yChiWatPlaRes</code> according
to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), section 5.2.5.1.
</p>
<p>
Following implementation is for plants with primary-only and primary-secondary 
systems serving differential pressure controlled pumps.
</p>
<ul>
<li>
Chilled water plant reset <code>yChiWatPlaRes</code> shall be reset 
using trim-respond logic with following parameters:
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>Any chilled water pump</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>minSet</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>maxSet</code></td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td><code>delTim</code></td><td>Delay timer</td></tr>
<tr><td>T</td><td><code>samplePeriod</code></td><td>Time step</td></tr>
<tr><td>I</td><td><code>numIgnReq</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>TChiWatSupResReq</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>triAmo</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>resAmo</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>maxRes</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>
<ul>
<li>
Plant reset loop shall be enabled when the plant is enabled (any chilled water
pump is enabled, <code>uChiWatPum</code> = true) and disabled when 
the plant is disabled (all chilled water pumps are disabled, <code>uChiWatPum</code> = false). 
</li>
</ul>
<ul>
<li>
When the plant stage change is initiated (<code>uStaCha</code>=true), the plant 
reset <code>yChiWatPlaRes</code> shall be disabled and value fixed at its last 
value for the longer of <code>holTim</code> and the time it takes for the plant 
to successfully stage.
</li>
</ul>
<p>
For primary-secondary plants serving more than one set of differential pressure
controlled pumps, an unique instance of the reset shall be used for each set of 
differential pressure controlled secondary pumps.
</p>
<ul>
<li>
Chilled water reset requests from all loads served by a set of pumps shall be
directed to those pumps reset loop only.
</li>
<li>
The differential pressure setpoint output from each reset shall be used in the 
pressure control loop for the associated set of pumps only.
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
April 15, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterPlantReset;
