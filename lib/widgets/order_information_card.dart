import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

Widget orderInformationCard(
    String place, String destination, double screenHeight) {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 500),
    opacity: 1.0,
    child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.my_location,
                    color: AppTheme.secondaryBlue,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      place,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.lightGrey,
                        fontSize: AppTheme.elementSize(
                            screenHeight, 14, 15, 15, 16, 17, 20, 24, 26),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 12, 14, 15, 16, 17, 18, 20, 20)),
              Row(
                children: [
                  Icon(
                    Icons.place,
                    color: AppTheme.secondaryBlue,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      destination,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.lightGrey,
                        fontSize: AppTheme.elementSize(
                            screenHeight, 14, 15, 15, 16, 17, 20, 24, 26),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
