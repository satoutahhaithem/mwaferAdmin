import 'package:admin_shop_app/data_base/category_database.dart';
import 'package:admin_shop_app/data_base/coupon_database.dart';

import 'package:admin_shop_app/pages/add_cat_EID.dart';
import 'package:admin_shop_app/pages/add_coupon.dart';
import 'package:admin_shop_app/pages/all_cats_page_EID.dart';
import 'package:admin_shop_app/pages/all_coupons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'All_Products.dart';
import 'Send_Noti.dart';
import 'add_image.dart';
import 'add_products_page_EID.dart';

class Admin extends StatefulWidget
{
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin>
{
  MaterialColor active = Colors.orange;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  ProductDatabase _productDatabase = ProductDatabase();
  CategoryService _categoryService = CategoryService();
  @override
  void initState()
  {
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red[900],
        title : Text("Admin Coupons"),
        centerTitle: true,

      ),
      body: ListView(
        children:
        [
          ListTile(
            leading: Icon(Icons.add),
            title: Text("اضف كوبون"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCoupon()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.change_history),
            title: Text("كل الكوبونات"),
            onTap: ()
            {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllCoupon()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text("اضف متجر"),
            onTap: () async {
              await _dialogCall(context, "cat");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category),
            title: Text("جميع المتاجر"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllCATs()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text("اضف عرض"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text("كل العروض"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllPruductsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("ارسل اشعار"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MessagingWidget()));
            },
          ),
          Divider(),
        /*  ListTile(
            leading: Icon(Icons.image),
            title: Text("صور التطبيق"),
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddImages()));
            },
          ),
          Divider(),
*/

        ],
      ),
    );
  }
  //*************************************************

  // end build load screen
  //*********************************************************
  // start dialog call
  Future<void> _dialogCall(BuildContext context, String type)
  {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (type == "cat")
        {
          return CatDialog();
        }

        else
        {
          return SizedBox();
        }
      },
    );
  }
  // end dialog call
}
