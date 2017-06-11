within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsSingleZone "Based on the design outdoor airflow rate (DesOA) 
  and minimum outdoor airflow rate (MinOA), as well as the corresponded damper positions to achieve these flow rates 
  when the fan in minimum and maximum speed, given the outdoor airflow rate setpoint and current fan speed,
  to reset the min limit of the economizer damper positionBased on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."


  // fixme: add keep previous pos if VOut>VOutSet AND outDamPos>outDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)
  // fixme: potentially a better name since used in communication with Brent: OA control loop

  parameter Real minFanSpe(min=0, max=1, unit="1") = 0.1 "Minimum supply fan operation speed";
  parameter Real maxFanSpe(min=0, max=1, unit="1") = 0.9 "Maximum supply fan operation speed";
  parameter Real minPosMin(min=0, max=1, unit="1") = 0.4
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow";
  parameter Real desPosMin(min=0, max=1, unit="1") = 0.9
    "Outdoor air damper position, when fan operating at minimum speed to supply design outdoor air flow";
  parameter Real minPosMax(min=0, max=1, unit="1") = 0.2
    "Outdoor air damper position, when fan operating at maximum speed to supply minimum outdoor air flow";
  parameter Real desPosMax(min=0, max=1, unit="1") = 0.8
    "Outdoor air damper position, when fan operating at maximum speed to supply design outdoor air flow";
  parameter Modelica.SIunits.MassFlowRate minOutAir = 1.0
    "fixme: minimum outdoor airflow rate (Vbz_A/EzC). Should we use unit kg/s as the unit?";
  parameter Modelica.SIunits.MassFlowRate desOutAir = 2.0
    "fixme: design outdoor airflow rate (Vbz_A+Vbz_p)/EzH. Should we use unit kg/s as the unit?";

  CDL.Interfaces.RealInput uSupFanSpd(min=minFanSpe, max=maxFanSpe, unit="1") "Current supply fan speed"
    annotation (Placement(transformation(extent={{-220,36},{-180,76}})));
  CDL.Interfaces.RealInput uVOutMinSet(min=minOutAir, max=desOutAir)
    "fixme: Minimum outdoor airflow requirement (setpoint, kg/s?), output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-220,118},{-180,158}}),
        iconTransformation(extent={{-220,118},{-180,158}})));
  //fixme add units, should be percentage

  CDL.Continuous.Constant minFanSpd(k=minFanSpe) "Minimum supply fan speed"
    annotation (Placement(transformation(extent={{-140,-18},{-120,2}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,10},{200,30}}),  iconTransformation(extent={{180,10},
            {200,30}})));
  CDL.Continuous.Constant outDamPhyPosMinSig(k=0)
    "If the minimum outdoor airflow setpoint becomes zero (when the zone is in other than occupied mode), the outdoor damper shall be zero."
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  CDL.Logical.Switch outDamPosMin
    "If zone is in other than occupied mode, uVOutMinSet shall be zero, so that the yOutDamPosMin shall be zero"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));

  CDL.Continuous.Constant maxFanSpd(k=maxFanSpe) "Maximum supply fan speed"
    annotation (Placement(transformation(extent={{-140,18},{-120,38}})));

  CDL.Continuous.Constant minPosAtMinSpd(k=minPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-140,64},{-120,84}})));
  CDL.Continuous.Constant desPosAtMinSpd(k=desPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Continuous.Constant minPosAtMaxSpd(k=minPosMax)
    "Outdoor air damper position, when fan operating at maximum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-140,102},{-120,122}})));
  CDL.Continuous.Constant desPosAtMaxSpd(k=desPosMax)
    "Outdoor air damper position, when fan operating at maximum speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));
  CDL.Continuous.Constant minOA(k=minOutAir) "Minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-10,88},{10,108}})));
  CDL.Continuous.Constant desOA(k=desOutAir) "Design outdoor airflow rate"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  CDL.Continuous.Line minPosAtCurSpd(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-10,46},{10,66}})));
  CDL.Continuous.Line desPosAtCurSpd(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  CDL.Continuous.Line minOutDamForOutMinSet(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply setpoint outdoor air flow"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
equation
  connect(uAHUMod, outDamPosMin.u2)
    annotation (Line(points={{-200,-100},{118,-100}}, color={255,0,255}));
  connect(outDamPhyPosMinSig.y, outDamPosMin.u3) annotation (Line(points={{-119,
          -130},{-76,-130},{-76,-108},{118,-108}}, color={0,0,127}));
  connect(minOA.y, minOutDamForOutMinSet.x1) annotation (Line(points={{11,98},{
          26,98},{26,48},{58,48}},
                                color={0,0,127}));
  connect(desOA.y, minOutDamForOutMinSet.x2) annotation (Line(points={{11,20},{
          26,20},{26,36},{58,36}},
                                color={0,0,127}));
  connect(minPosAtCurSpd.y, minOutDamForOutMinSet.f1) annotation (Line(points={{11,56},
          {22,56},{34,56},{34,44},{58,44}},        color={0,0,127}));
  connect(desPosAtCurSpd.y, minOutDamForOutMinSet.f2) annotation (Line(points={{11,-20},
          {34,-20},{34,32},{58,32}},         color={0,0,127}));
  connect(uVOutMinSet, minOutDamForOutMinSet.u) annotation (Line(points={{-200,
          138},{-86,138},{30,138},{30,40},{58,40}},
                                               color={0,0,127}));
  connect(minOutDamForOutMinSet.y, outDamPosMin.u1) annotation (Line(points={{81,40},
          {88,40},{88,-92},{118,-92}},     color={0,0,127}));
  connect(outDamPosMin.y, yOutDamPosMin) annotation (Line(points={{141,-100},{
          148,-100},{148,20},{190,20}},
                                    color={0,0,127}));
  connect(minFanSpd.y, desPosAtCurSpd.x1) annotation (Line(points={{-119,-8},{
          -66,-8},{-66,-12},{-12,-12}},
                                    color={0,0,127}));
  connect(desPosAtMinSpd.y, desPosAtCurSpd.f1) annotation (Line(points={{-119,
          -80},{-66,-80},{-66,-16},{-12,-16}},
                                          color={0,0,127}));
  connect(maxFanSpd.y, desPosAtCurSpd.x2) annotation (Line(points={{-119,28},{
          -98,28},{-74,28},{-74,-24},{-12,-24}},
                                             color={0,0,127}));
  connect(desPosAtMaxSpd.y, desPosAtCurSpd.f2) annotation (Line(points={{-119,
          -44},{-102,-44},{-74,-44},{-74,-28},{-12,-28}},
                                                     color={0,0,127}));
  connect(minFanSpd.y, minPosAtCurSpd.x1) annotation (Line(points={{-119,-8},{-66,
          -8},{-66,64},{-12,64}}, color={0,0,127}));
  connect(minPosAtMinSpd.y, minPosAtCurSpd.f1) annotation (Line(points={{-119,74},
          {-98,74},{-74,74},{-74,60},{-12,60}}, color={0,0,127}));
  connect(maxFanSpd.y, minPosAtCurSpd.x2) annotation (Line(points={{-119,28},{-74,
          28},{-74,52},{-12,52}}, color={0,0,127}));
  connect(minPosAtMaxSpd.y, minPosAtCurSpd.f2) annotation (Line(points={{-119,112},
          {-90,112},{-58,112},{-58,48},{-12,48}}, color={0,0,127}));
  connect(uSupFanSpd, minPosAtCurSpd.u)
    annotation (Line(points={{-200,56},{-12,56}},          color={0,0,127}));
  connect(uSupFanSpd, desPosAtCurSpd.u) annotation (Line(points={{-200,56},{
          -146,56},{-86,56},{-86,-20},{-12,-20}},
                                             color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMinOAPos",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,200}}),
                                                                graphics={
        Rectangle(
        extent={{-180,-140},{180,200}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-176,154},{-112,122}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uVOutMinSet"),
        Rectangle(
          extent={{-112,130},{148,-80}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{104,40},{174,0}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMin"),
        Text(
          extent={{-174,-90},{-128,-116}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uAHUMod"),
        Text(
          extent={{-176,80},{-116,32}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uSupFanSpd"),
        Line(
          points={{-112,130},{-112,-80},{148,-80}},
          color={95,95,95},
          thickness=0.5),
        Ellipse(
          extent={{-88,124},{-84,120}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-26},{-84,-30}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,96},{100,92}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,-48},{100,-52}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-86,122},{98,94}},
          color={135,135,135},
          pattern=LinePattern.Dash),
        Line(
          points={{-86,-28},{98,-50}},
          color={135,135,135},
          pattern=LinePattern.Dash),
        Line(
          points={{14,-40},{14,108}},
          color={135,135,135},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{12,8},{16,4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-38},{16,-42}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,110},{16,106}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{14,6},{-112,6}},
          color={135,135,135},
          pattern=LinePattern.Dot),
        Polygon(
          points={{-112,10},{-116,6},{-112,2},{-108,6},{-112,10}},
          lineColor={127,127,0},
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,244},{104,208}},
          lineColor={85,0,255},
          textString="%name"),
        Text(
          extent={{102,90},{172,50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yMinPosAtCurSpd"),
        Text(
          extent={{102,-10},{172,-50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yDesPosAtCurSpd")}),
    Diagram(coordinateSystem(                           extent={{-180,-180},{
            180,180}},
        initialScale=0.1)),
    Documentation(info="<html>      
<p>
This atomic sequence sets the minimum economizer damper position limit. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.P.4.d.
</p>   
<p>
The controller is enabled when the zone is in occupied mode. Otherwise, the outdoor air damper position limit is set to
minimum physical or at commissioning fixed limits. The state machine diagram below illustrates this.

</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsStateMachineChart_SingleZone.png\"/>
</p>
<p>
According to article from G36, 
<ul>
<li>
based on current supply fan speed (<code>uSupFanSpd</code>), it calculates outdoor air damper position (<code>minPosAtCurSpd</code>), 
to ensure minimum outdoor air flow rate (<code>minOutAir</code>); 
</li>
</ul>
<ul>
<li>
based on current supply fan speed (<code>uSupFanSpd</code>), it calculates outdoor air damper position (<code>desPosAtCurSpd</code>), 
to ensure design outdoor air flow rate (<code>desOutAir</code>);
</li>
</ul>
<ul>
<li>
given the calculated air damper positions (<code>minPosAtCurSpd</code>, <code>desPosAtCurSpd</code>) 
and the outdoor air flow rate limits (<code>minOutAir</code>, <code>desOutAir</code>), 
it caculates the minimum outdoor air damper position (<code>yOutDamPosMin</code>), 
to ensure outdoor air flow rate setpoint (<code>uVOutMinSet</code>) 
under current supply fan speed (<code>uSupFanSpd</code>).
</li>
</ul>
Both the outdoor air flow rate setpoint (code>uVOutMinSet</code>) 
and current supply fan speed (<code>uSupFanSpd</code>) are output from separate sequences.
</p>
<p>
Control charts below show the input-output structure and a damper limit 
position sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control diagram\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlDiagram_SingleZone.png\"/>
</p>
<p>
Expected control performance, upon tuning:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlChart_SingleZone.png\"/>
</p>
<p>
fixme: additional text about the functioning of the sequence
Note that VOut depends on whether the economizer damper is controlled to a 
position higher than it's minimum limit. This is defined by the EconEnableDisable
and EconModulate [fixme check seq name] sequences. Fixme feature add: For this reason
we may want to implement something like:
while VOut > VOutSet and outDamPos>outDamPosMin, keep previous outDamPosMin.
fixme: add option for separate minimum outdoor air damper.
</p>

</html>", revisions="<html>
<ul>
<li>
April 04, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconDamperPositionLimitsSingleZone;