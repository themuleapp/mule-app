import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/stylized_button.dart';

abstract class Panel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController = null;
  final MapController mapController = null;
  final double radius = null;
  final double minHeight = null;
  final double maxHeight = null;
  final double buttonSpacing = null;
  final double buttonSize = null;
  final double _minHeight = null;
  final double _maxHeight = null;
  final bool _isDraggable = null;
  final bool _backdropTapClosesPanel = null;
  final double _backdropOpacity = null;
  final List<StylizedButton> _buttonList = null;
  final Function _mapStateCallback = null;
}
