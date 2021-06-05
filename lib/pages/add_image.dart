
import 'dart:io';

import 'package:admin_shop_app/data_base/Image_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_page_EID.dart';
class AddImages extends StatefulWidget
{
  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages>
{

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<String> imgsurl = [];
  File image1, image2, image3,image4,image5,image6,image7;
  bool loading = false;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صور التطبيق",
        ),
        centerTitle: true,
        backgroundColor: Colors.red[900],
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body:  loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [
            Container(
              height: 1000,
              width:300,
              child: Column(
                children: <Widget>[
                  Text("صورة الكوبونات الرئيسية"),
                  _Custombutton(1, image1),
                  Text("صورة العروض الرئيسية"),

                  _Custombutton(2, image2),
                  Text("صورة الكوبونات العلوية"),

                  _Custombutton(3, image3),
                  Text("صورة العروض العلوية"),

                  _Custombutton(4, image4),
                  Text("صورة الكوبونات الكارد "),
                  _Custombutton(5, image5),
                  Text("صورة الكوبونات المنتجات"),

                  _Custombutton(6, image6),
                  Text("صورة العروض المنتجات"),

                  _Custombutton(7, image7),

                ],
              ),
            ),

            Row(
              children:
              [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: uploadimages,
                      child: Text("Add product"),
                      color: Colors.red[900],
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  //************************************************************
  // start custom button
  Widget _Custombutton(int imagnum, File image)
  {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: OutlineButton(
            onPressed: ()
            {
              (_pickimage(imagnum));
            },
            child: image == null ? Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 40, 14, 40),
              child: Icon(Icons.add),
            ) : Container(
              height: 120,
              child: Image.file(
                image,
                width: double.infinity,
                fit: BoxFit.fill,
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
 
  // start upload images
  void uploadimages()
  {
    if (_formkey.currentState.validate() )
    {
      if (image1 != null && image3 != null && image2 != null &&image4 != null &&image5 != null&&image6 != null&&image7 != null)
      {
        setState(() {
          loading = true;
        });
        ImageDatabase().uploadimages(image1, image2, image3, image4,image5,image6,image7).then((list)
        {
          setState(() {
            imgsurl = list;
          });
          if (imgsurl.isNotEmpty)
          {
            ImageDatabase().uploadProduct(

                imgsurl,
                );
            setState(() {
              loading = false;
            });
            Fluttertoast.showToast(msg: "product added");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
          } else {
            Fluttertoast.showToast(msg: "something wrong had happened ");
            setState(() {
              loading = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: "pick the images of the pictures");
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }
// end upload images
}