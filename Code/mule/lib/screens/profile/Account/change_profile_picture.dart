import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePicture extends StatefulWidget {
  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  File _image;
  final picker = ImagePicker();

  Future _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _getCurrentImage() async {
    // TODO get current image from server
  }

  Future _submitImage() async {
    // TODO upload image to server

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Change Profile Picture",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              _changeProfilePictureForm(context),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeProfilePictureForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CircleAvatar(
                radius: 150.0,
                backgroundImage: _image == null
                    ? AssetImage('assets/images/profile_photo_nick_miller.jpg')
                    : FileImage(_image)),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
              height: 45.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _ButtonWithText("Add with camera", _getImageFromCamera),
                  SizedBox(
                    width: 30.0,
                  ),
                  _ButtonWithText("Add from gallery", _getImageFromGallery),
                ],
              )),
          SizedBox(
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              color: AppTheme.lightBlue,
              child: Text(
                "SUBMIT",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              onPressed: () {
                _submitImage();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _ButtonWithText(String buttonText, Function callback) {
    return Container(
      child: FlatButton(
        color: AppTheme.lightBlue,
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        onPressed: () {
          callback();
        },
      ),
    );
  }
}
