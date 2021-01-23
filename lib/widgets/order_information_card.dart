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
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        top: AppTheme.elementSize(
                            screenHeight, 10, 12, 13, 14, 15, 16, 16, 18)),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 15, 15, 16, 16, 18, 20, 22, 24),
                      color: AppTheme.lightGrey,
                    ),
                    hintText: place,
                    prefixIcon: IconButton(
                      splashColor: AppTheme.lightBlue,
                      icon: Icon(
                        Icons.my_location,
                        color: AppTheme.secondaryBlue,
                      ),
                      onPressed: () {},
                    ),
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(
                  height: AppTheme.elementSize(
                      screenHeight, 0, 0, 0, 2, 8, 10, 10, 10)),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        top: AppTheme.elementSize(
                            screenHeight, 10, 12, 13, 14, 15, 16, 16, 18)),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 15, 15, 16, 16, 18, 20, 22, 24),
                      color: AppTheme.lightGrey,
                    ),
                    hintText: destination,
                    prefixIcon: IconButton(
                      splashColor: AppTheme.lightBlue,
                      icon: Icon(
                        Icons.place,
                        color: AppTheme.secondaryBlue,
                      ),
                      onPressed: () {},
                    ),
                    enabled: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
