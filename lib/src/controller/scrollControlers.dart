import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flutter/physics.dart';



class ScrollsScrollPhysics extends ClampingScrollPhysics {

  const ScrollsScrollPhysics({super.parent});

  @override
  final Tolerance tolerance = const Tolerance(
    distance: 1e-3,
    time: 1e-3,
    velocity: 1e-3
  );


  
  @override
  ClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ScrollsScrollPhysics(parent: buildParent(ancestor));
  }
  

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent) {
        end = position.maxScrollExtent;
      }
      if (position.pixels < position.minScrollExtent) {
        end = position.minScrollExtent;
      }
      assert(end != null);
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        end!,
        math.min(0.0, velocity),
        tolerance: tolerance,
      );
    }
    if (velocity.abs() < tolerance.velocity) {
      return null;
    }
    if (velocity > 0.0 && position.pixels >= position.maxScrollExtent) {
      return null;
    }
    if (velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: 0.8 * velocity,
      tolerance: tolerance,
      friction: 0.05
    );
  }
}