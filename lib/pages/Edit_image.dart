import 'dart:io';

import 'package:admin_shop_app/data_base/Image_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditImages extends StatefulWidget
{
  DocumentSnapshot _documentSnapshot;
  EditImages(this._documentSnapshot);
  @override
  _EditImagesState createState() => _EditImagesState(_documentSnapshot);
}

class _EditImagesState extends State<EditImages>
{
  DocumentSnapshot _documentSnapshot;
  _EditImagesState(this._documentSnapshot);
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<String> imgsurl = [];
  File image1, image2, image3,image4,image5,image6,image7;
  bool loading = false;

  @override
  void initState()
  {
    super.initState();

    for(int i=0;i<_documentSnapshot["images url"].length;i++)
    {
      imgsurl.add(_documentSnapshot["images url"][i]);
    }

  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صور التطبيق",
          style: TextStyle(color: Colors.blueGrey),
        ),
        backgroundColor: Colors.red[900],
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [
            Container(
              height: 1000,
              width:300,
              child: Column(
                children:
                [
                  _Custombutton(1, imgsurl[0]),
                  _Custombutton(2, imgsurl[1]),
                  _Custombutton(3, imgsurl[2]),
                  _Custombutton(4, imgsurl[3]),
                  _Custombutton(5, imgsurl[4]),
                  _Custombutton(6, imgsurl[5]),
                  _Custombutton(7, imgsurl[6]),

                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: ()
                      {
                        _EditImages();
                      },
                      child: Text("تعديل الصور"),
                      color: Colors.red[900],
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //***********************************************************
  // start custom button
  Widget _Custombutton(int imagnum, String imageurl)
  {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
            onPressed: ()
            {
              (_pickimage(imagnum));
            },
            child: imageurl == null ? Padding(padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
              child: Text("No available image"),) : Container(
              height: 120,
              child: Stack(
                children:
                [
                  Image.network(
                    imageurl,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    height: 120,
                    color: Colors.black54,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text("edit",style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
  _pickimage(int imgnum) async
  {
    File tempimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    switch (imgnum)
    {
      case 1:
        setState(() {
          image1 = tempimage;
        });
        break;
      case 2:
        setState(() {
          image2 = tempimage;
        });
        break;
      case 3:
        setState(() {
          image3 = tempimage;
        });
        break;
      case 4:
        setState(() {
          image4 = tempimage;
        });
        break;

      case 5:
        setState(() {
          image5 = tempimage;
        });
        break;

      case 6:
        setState(() {
          image6 = tempimage;
        });
        break;

      case 7:
        setState(() {
          image7 = tempimage;
        });
        break;
    }
  }
  // end custom button

  // start edit product
  void _EditImages()
  {
    if (_formkey.currentState.validate())
    {
      setState(() {
        loading = false;
      });
      ImageDatabase().updateProduct(
          _documentSnapshot.documentID,

          imgsurl,
          );
      Fluttertoast.showToast(msg: "Image Edited");

    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }
// end edit product
}