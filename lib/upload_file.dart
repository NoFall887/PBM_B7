import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tourly/main.dart';
import 'package:tourly/ulasan.dart';

class Upload extends StatefulWidget {
  Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final ImagePicker picker = ImagePicker();

  @override

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    XFile? img = await picker.pickImage(source: media);
    print(img);
    if (img == null) return;
    Provider.of<UploadImageProvider>(context, listen: false).changeImage(img);
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    XFile? image = Provider.of<UploadImageProvider>(context).image;
    return image != null ? fotoBtn(image, context) : uploadBtn(context);
  }

  Widget fotoBtn(XFile? image, BuildContext context) {
    return InkWell(
      onTap: () => myAlert(),
      splashColor: Colors.white10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          //to show image, you type like this.
          File(image!.path),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 250,
        ),
      ),
    );
  }

  Widget uploadBtn(BuildContext context) {
    return TextButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_rounded,
            color: Colors.black,
          ),
          Text(
            "Lampirkan Gambar",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      onPressed: () => myAlert(),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.withOpacity(0.2),
        primary: Colors.grey.withOpacity(0.2),
        elevation: 0,
        fixedSize: Size(MediaQuery.of(context).size.width, 140),
      ),
    );
  }
}
