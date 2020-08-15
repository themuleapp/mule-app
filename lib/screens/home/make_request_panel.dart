import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/sliding_up_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MakeRequestPanel extends StatelessWidget {
  final PanelController panelController;
  final SlidingUpWidgetState slidingUpWidgetState;
  final double opacity = 1.0;

  MakeRequestPanel({this.panelController, this.slidingUpWidgetState});

  @override
  build(BuildContext context) {
    // Only animate after everything is done building
    WidgetsBinding.instance
        .addPostFrameCallback((_) => panelController.animatePanelToSnapPoint(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
            child: Text(
              'Confirm Details',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 0.27,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.people,
                      color: AppTheme.secondaryBlue,
                      size: 24,
                    ),
                    Text(
                      ' 12 ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 21,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                    Text(
                      'Mules around',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 21,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightGrey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: "From here - address",
                          prefixIcon: IconButton(
                            splashColor: AppTheme.lightBlue,
                            icon: Icon(
                              Icons.my_location,
                              color: AppTheme.secondaryBlue,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: "To here - address",
                          prefixIcon: IconButton(
                            splashColor: AppTheme.lightBlue,
                            icon: Icon(
                              Icons.place,
                              color: AppTheme.secondaryBlue,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        border: Border.all(
                            color: AppTheme.lightGrey.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppTheme.lightGrey.withOpacity(0.5),
                        size: 28,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: GestureDetector(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryBlue,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.secondaryBlue.withOpacity(0.5),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Request',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}
