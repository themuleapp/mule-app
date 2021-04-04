import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class StylizedButton extends StatelessWidget {
  final double size;
  final Color color;
  final EdgeInsets margin;
  final IconData icon;
  final Color iconColor;
  final Function callback;

  StylizedButton({
    this.size = 20,
    this.color,
    this.margin,
    this.icon,
    this.iconColor,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      margin: margin,
      child: FittedBox(
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          backgroundColor: color,
          child: Icon(
            icon,
            color: iconColor,
          ),
          onPressed: () {
            try {
              callback(context);
            } catch (_) {
              callback();
            }
          },
        ),
      ),
    );
  }
}

class CurrentLocationButton extends StylizedButton {
  CurrentLocationButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: AppTheme.white,
          margin: margin,
          iconColor: AppTheme.darkGrey,
          callback: callback,
          icon: Icons.near_me,
        );
}

class CancelButton extends StylizedButton {
  CancelButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: Colors.red,
          margin: margin,
          iconColor: AppTheme.white,
          callback: callback,
          icon: Icons.close,
        );
}

class CompletedButton extends StylizedButton {
  CompletedButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: Colors.green,
          margin: margin,
          iconColor: AppTheme.white,
          callback: callback,
          icon: Icons.check,
        );
}

class NavigateButton extends StylizedButton {
  NavigateButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: AppTheme.secondaryBlue,
          margin: margin,
          iconColor: AppTheme.white,
          callback: callback,
          icon: Icons.directions,
        );
}

class HelpButton extends StylizedButton {
  HelpButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: Colors.red,
          margin: margin,
          iconColor: AppTheme.white,
          callback: callback,
          icon: Icons.help,
        );
}

class ChatButton extends StylizedButton {
  ChatButton({double size, Function callback, EdgeInsets margin})
      : super(
          size: size,
          color: AppTheme.white,
          margin: margin,
          iconColor: AppTheme.secondaryBlue,
          callback: callback,
          icon: Icons.chat,
        );
}
