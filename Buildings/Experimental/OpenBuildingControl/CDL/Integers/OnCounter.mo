within Buildings.Experimental.OpenBuildingControl.CDL.Integers;
block OnCounter "Increment the output if the input switches to true"

  parameter Integer y_start = 0
    "Initial and reset value of y if input reset switches to true";

  Modelica.Blocks.Interfaces.IntegerOutput y "Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Modelica.Blocks.Interfaces.BooleanInput trigger "Boolean input signal"
    annotation (Placement(transformation(extent={{-180,-60},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanInput reset "Reset the counter" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

initial equation
  pre(y) = y_start;
equation
  when {trigger, reset} then
     y = if reset then y_start else pre(y) + 1;
  end when;
  annotation (       Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        initialScale=0.06), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
          Text(
            visible=use_reset,
            extent={{-64,-62},{58,-86}},
            lineColor={0,0,0},
            textString="reset")}),
    Documentation(info="<html>
<p>
Block that outputs how often the <code>trigger</code> input changed to <code>true</code>
since the last invocation of <code>reset</code>.
</p>
<p>
This block can be used as a counter. Its output <code>y</code> starts
at the parameter value <code>y_start</code>.
Whenever the input signal <code>trigger</code> changes to <code>true</code>,
the output is incremented by <i>1</i>.
When the input <code>reset</code> changes to <code>true</code>,
then the output is reset to <code>y = y_start</code>.
If both inputs <code>trigger</code> and <code>reset</code> change
simultaneously, then the ouput is <code>y = y_start</code>.
</p>
</html>"));
end OnCounter;