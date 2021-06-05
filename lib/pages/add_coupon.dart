import 'dart:io';
import 'package:admin_shop_app/data_base/category_database.dart';
import 'package:admin_shop_app/data_base/coupon_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_page_EID.dart';
class AddCoupon extends StatefulWidget
{
  @override
  _AddCouponState createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon>
{
  TextEditingController _productcontroler = TextEditingController();
  TextEditingController _desccontroler =  TextEditingController();
  TextEditingController _pricecontroller =  TextEditingController();
  CategoryService _categoryService = CategoryService();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String CATId;
  String selectedcat;
  bool loading = false;
  String productname="";
  String description="";
  String price="";
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اضف كوبون",
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
      body:  loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "اسم الكوبون",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                controller: _productcontroler,
                validator: (val)
                {
                  if (val.isEmpty ) {
                    return "ادخل كوبون من فضلك";
                  }
                  else{
                    setState(() {
                      productname = val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "وصف الكوبون",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintText: "ادخل وصف للكوبون",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                controller: _desccontroler,
                validator: (val) {
                  if (val.isEmpty ) {
                    return "ادخل وصف للكوبون";
                  }
                  else{
                    setState(() {
                      description = val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "الكود",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                ),
                controller: _pricecontroller,
                validator: (val)
                {
                  if (val.isEmpty) {
                    return "Enter Valid price";
                  }
                  else{
                    setState(() {
                      price=val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<List<String>>(
                future: _getelements("categories", "category"),
                builder: (context, snapshot)
                {
                  if (snapshot.hasData)
                  {
                    return DropdownButton<String>(
                      value: selectedcat,
                      isExpanded: true,
                      isDense: true,
                      onChanged: changecat,
                      hint: Text("Select Category"),
                      items: snapshot.data.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Text("Loading  . . . ");
                  }
                },
              ),
            ),



            Row(
             mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width-50,
                    child: RaisedButton(
                      onPressed: uploadimages,
                      child: Text("اضافة"),
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

  Future<List<String>> _getelements(String col_name, String snap_elements) async
  {
    QuerySnapshot querytSnapshot = await Firestore.instance.collection(col_name).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querytSnapshot.documents;
    List<String> list = [];
    for (int i = 0; i < documentSnapshot.length; i++)
    {
      list.add(documentSnapshot[i][snap_elements]);
    }
    return list;
  }
  // end get elements
  //**************************************************************
  // start change category and change brand
  void changecat(String value) async
  {
    setState(() {
      selectedcat = value;
    });
    CATId = await _categoryService.getCATID(selectedcat);

  }


  void uploadimages()
  {
    if (_formkey.currentState.validate() &&
        CATId!=null&&
        productname.isNotEmpty&&
        description.isNotEmpty
        )
      {

        ProductDatabase().uploadProduct(
            productname,
            description,
            CATId,

            price,
           );
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(msg: "product added");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
  }
    else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }

    }
  }




