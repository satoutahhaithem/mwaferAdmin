import 'package:firebase_storage/firebase_storage.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ImageDatabase
{
  Firestore _firestore = Firestore.instance;
  // start upload images
  Future<List<String>> uploadimages(File imgfile1, File imgfile2, File imgfile3, File imgfile4, File imgfile5, File imgfile6, File imgfile7, ) async
  {
    List<String> uploadedimages = [];
    var id1 = Uuid();
    var id2 = Uuid();
    var id3 = Uuid();
    var id4 = Uuid();
    var id5 = Uuid();
    var id6 = Uuid();
    var id7 = Uuid();

    final FirebaseStorage storage = FirebaseStorage.instance;
    final String imgname1 = "${"ConstImage" + id1.v1()}.jpg";
    final String imgname2 = "${"ConstImage" + id2.v1()}.jpg";
    final String imgname3 = "${"ConstImage" + id3.v1()}.jpg";
    final String imgname4 = "${"ConstImage" + id4.v1()}.jpg";
    final String imgname5 = "${"ConstImage" + id5.v1()}.jpg";
    final String imgname6 = "${"ConstImage" + id6.v1()}.jpg";
    final String imgname7 = "${"ConstImage" + id7.v1()}.jpg";

    String imgurl1;
    String imgurl2;
    String imgurl3;
    String imgurl4;
    String imgurl5;
    String imgurl6;
    String imgurl7;

    StorageUploadTask task1 = storage.ref().child(imgname1).putFile(imgfile1);
    StorageUploadTask task2 = storage.ref().child(imgname2).putFile(imgfile2);
    StorageUploadTask task3 = storage.ref().child(imgname3).putFile(imgfile3);
    StorageUploadTask task4 = storage.ref().child(imgname4).putFile(imgfile4);
    StorageUploadTask task5 = storage.ref().child(imgname5).putFile(imgfile5);
    StorageUploadTask task6 = storage.ref().child(imgname6).putFile(imgfile6);
    StorageUploadTask task7 = storage.ref().child(imgname7).putFile(imgfile7);

    StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snap1) {
      return snap1;
    });
    StorageTaskSnapshot snapshot2 = await task2.onComplete.then((snap2) {
      return snap2;
    });
    StorageTaskSnapshot snapshot3 = await task3.onComplete.then((snap3) {
      return snap3;
    });
    StorageTaskSnapshot snapshot4 = await task4.onComplete.then((snap4) {
      return snap4;
    });
    StorageTaskSnapshot snapshot5 = await task5.onComplete.then((snap5) {
      return snap5;
    });
    StorageTaskSnapshot snapshot6 = await task6.onComplete.then((snap6) {
      return snap6;
    });
    StorageTaskSnapshot snapshot7 = await task7.onComplete.then((snap7) {
      return snap7;
    });
    imgurl1 = await snapshot1.ref.getDownloadURL();
    imgurl2 = await snapshot2.ref.getDownloadURL();
    imgurl3 = await snapshot3.ref.getDownloadURL();
    imgurl4 = await snapshot4.ref.getDownloadURL();
    imgurl5 = await snapshot5.ref.getDownloadURL();
    imgurl6 = await snapshot6.ref.getDownloadURL();
    imgurl7 = await snapshot7.ref.getDownloadURL();

    uploadedimages = [imgurl1, imgurl2, imgurl3,imgurl4,imgurl5,imgurl6,imgurl7];
    return uploadedimages;
  }
  // end upload images
  //**************************************************************
  // start upload product
  void uploadProduct(

      List<String> imgsurl,
      )
  {
    var id = Uuid();
    String productid = id.v1();
    try {
      _firestore.collection('images').document("ecc969a0-a868-11eb-b5fe-7b2cdb35b96e").setData({

        "images url": imgsurl,
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

      List<String> imgsurl,
      ) {
    try {
      _firestore.collection('images').document(productid).setData({

        "images url": imgsurl,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  // end update product
  //**************************************************************
  // start getAll products
  Future<List<DocumentSnapshot>> getallproducts() async
  {
    List<DocumentSnapshot> documentSnapshot;


      QuerySnapshot querytSnapshot =
      await Firestore.instance.collection("images").getDocuments();
      documentSnapshot = querytSnapshot.documents;

    return documentSnapshot;
  }
  // end getAll products
  //****************************************************************
  // start get suggestions
  Future<List<DocumentSnapshot>> getSuggestions(String pattern) async
  {
    List<DocumentSnapshot> documentSnapshot;
    QuerySnapshot querytSnapshot = await Firestore.instance.collection("products").where("name",isEqualTo: pattern).getDocuments();
    documentSnapshot = querytSnapshot.documents;
    return documentSnapshot;
  }
  // end get suggestions
  //****************************************************************
  // start delete products
  void deleteproducts(List<String> products) async
  {
    for (String id in products) {
      await Firestore.instance.collection("products").document(id).delete();
    }
  }
  // end delete products
  //****************************************************************
  // start get product count

// end get product count
}