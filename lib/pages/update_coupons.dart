import 'dart:io';

import 'package:admin_shop_app/data_base/category_database.dart';
import 'package:admin_shop_app/data_base/coupon_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget
{
  DocumentSnapshot _documentSnapshot;
  EditProduct(this._documentSnapshot);
  @override
  _EditProductState createState() => _EditProductState(_documentSnapshot);
}

class _EditProductState extends State<EditProduct>
{
  DocumentSnapshot _documentSnapshot;
  _EditProductState(this._documentSnapshot);
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  CategoryService _categoryService = CategoryService();
  String selectedcat;
  String CATId;

  bool loading = false;
  String productname="";
  String description="";
  String price="";

  @override
  void initState()
  {
    super.initState();

    productname=_documentSnapshot["name"];
    description=_documentSnapshot["description"];
    price=_documentSnapshot["price"];
    _categoryService.getcat(_documentSnapshot["category"]).then((value){setState(() {
      selectedcat= value;
      CATId=_documentSnapshot["category"];
    });});

  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تعديل الكوبون",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[900],
        elevation: 0.4,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: Navigator.of(context).pop),
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : Form(
        key: _formkey,
        child: ListView(
          children:
          [

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                initialValue: productname,
                decoration: InputDecoration(
                  labelText: "اسم الكوبون",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                validator: (val) {
                  if (val.isEmpty ) {
                    return "ادخل اسم للكوبون";
                  }
                  else{
                    setState(() {
                    productname=val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,0,15.0,15.0),
              child: TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: "الوصف",
                  hintText: "ادخل الوصف",
                  labelStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                validator: (val) {
                  if (val.isEmpty ) {
                    return "ادخل الوصف";
                  }
                  else{
                    setState(() {
                    description=val;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Expanded(
                child: TextFormField(
                  initialValue: price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "الكود",
                    labelStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  validator: (val) {
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
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FutureBuilder<List<String>>(
                future: _getelements("categories", "category"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton<String>(
                      value: selectedcat==null?"Categories":selectedcat,
                      isExpanded: true,
                      isDense: true,
                      onChanged: changecat,
                      hint: Text("Select Category"),
                      items: snapshot.data
                          .map<DropdownMenuItem<String>>((String value) {
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
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: ()
                      {
                        _editproduct();
                      },
                      child: Text("تعديل "),
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
  //************************************************************
  // start make change category and change brand
  void changecat(String value)async
  {
    setState(() {
      selectedcat = value;
    });
    CATId = await _categoryService.getCATID(selectedcat);
  }

  //****************************************************************
  // start change check

  // end change check
  //*********************************************************************
  // start build dialog call

  // end build dialog call
  //**************************************************************************
  // start edit product
  void _editproduct()
  {
    if (_formkey.currentState.validate() &&
        CATId!=null&&
        productname.isNotEmpty&&
        description.isNotEmpty&&
        price.isNotEmpty
       )
    {
      setState(() {
        loading = false;
      });
      ProductDatabase().updateProduct(
          _documentSnapshot.documentID,
          productname,
          description,
          CATId,

          price,
          );
      Fluttertoast.showToast(msg: "product Edited");

    } else {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: "required information missing");
    }
  }
  // end edit product
}
