import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';

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
      _image = pickedFile == null ? null : File(pickedFile.path);
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

  Future _updateImage() async {
    bool isSuccessfulUpload = await httpClient.uploadProfilePicture(_image);

    if (isSuccessfulUpload) {
      await GetIt.I.get<UserInfoStore>().updateProfilePicture();

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } else {
      createDialogWidget(context, "Something went wrong while uploading...",
          "Please try again");
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
            radius: 120,
            backgroundImage: _image == null
                ? GetIt.I.get<UserInfoStore>().profilePicture
                : FileImage(_image),
          )),
          SizedBox(
            height: 30.0,
          ),
          Container(
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _ButtonWithText(
                      "Camera", _getImageFromCamera, AppTheme.lightBlue),
                  SizedBox(
                    width: 40.0,
                  ),
                  _ButtonWithText(
                      "Gallery", _getImageFromGallery, AppTheme.lightBlue),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child:
                _ButtonWithText("Update", _updateImage, AppTheme.secondaryBlue),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "CANCEL",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ButtonWithText(String buttonText, Function callback, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 8.0),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: callback,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
