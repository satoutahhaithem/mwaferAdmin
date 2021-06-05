import 'package:firebase_storage/firebase_storage.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ProductDatabase
{
  Firestore _firestore = Firestore.instance;
  // start upload images

  // end upload images
  //**************************************************************
  // start upload product
  void uploadProduct(
      String name,
      String description,
      String cat,
      String price,
      )
  {
    var id = Uuid();
    String productid = id.v1();
    try {
      _firestore.collection('coupons').document(productid).setData({
        'name': name,
        "description": description,
        "category": cat,

        "price": price,

      });
    }catch (e) {
      Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
    }
  }
  // end upload product
  //**************************************************************
 // start update product
  void updateProduct(
      String productid,
      String name,
      String description,
      String cat,

      String price,

      ) {
    try {
      _firestore.collection('coupons').document(productid).setData({
        'name': name,
        "description": description,
        "category": cat,

        "price": price,

      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  // end update product
  //**************************************************************
  // start getAll products
  Future<List<DocumentSnapshot>> getallproducts(String CAT) async
  {
    List<DocumentSnapshot> documentSnapshot;

    if ((CAT != null && CAT != "All") )
    {
      if (CAT != "All" ) {
        QuerySnapshot querytSnapshot = await Firestore.instance
            .collection("coupons")
            .where("category", isEqualTo: CAT)
            .getDocuments();
        documentSnapshot = querytSnapshot.documents;
      } else if (CAT == "All") {
        QuerySnapshot querytSnapshot = await Firestore.instance
            .collection("coupons")
            .getDocuments();
        documentSnapshot = querytSnapshot.documents;
      }
    }else {
      QuerySnapshot querytSnapshot =
      await Firestore.instance.collection("coupons").getDocuments();
      documentSnapshot = querytSnapshot.documents;
    }
    return documentSnapshot;
  }
  // end getAll products
  //****************************************************************
  // start get suggestions
  Future<List<DocumentSnapshot>> getSuggestions(String pattern) async
  {
    List<DocumentSnapshot> documentSnapshot;
    QuerySnapshot querytSnapshot = await Firestore.instance.collection("coupons").where("name",isEqualTo: pattern).getDocuments();
    documentSnapshot = querytSnapshot.documents;
    return documentSnapshot;
  }
  // end get suggestions
  //****************************************************************
  // start delete products
  void deleteproducts(List<String> products) async
  {
    for (String id in products) {
      await Firestore.instance.collection("coupons").document(id).delete();
    }
  }
  // end delete products
  //****************************************************************
  // start get product count
  Future<int> productCount() async
  {
    int count = 0;
    await getallproducts("All").then((value) => count = value.length);
    return count;
  }
  // end get product count
}