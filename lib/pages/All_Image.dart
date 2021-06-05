
import 'package:admin_shop_app/data_base/Image_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Edit_image.dart';
class AllImage extends StatefulWidget
{
  @override
  _AllImageState createState() => _AllImageState();
}

class _AllImageState extends State<AllImage>
{
 
  List<String> selectedproducts = [];
  String brandId;
  String CATId;
  bool loading = false;
  bool allselected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text("images"),
        backgroundColor: Colors.white,
       
           ),
      body: Center(
        child: Container(
          child: Center(
            child: Column(
              children: [

                loading ? CircularProgressIndicator() : FutureBuilder<List<DocumentSnapshot>>(
                  future: ImageDatabase().getallproducts(),
                  builder: (context,snapshot){
                    if(snapshot.hasData)
                    {
                      if(snapshot.data.length == 0)
                      {
                        return Center(child: Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Text("The list is empty"),
                        ),);
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder:((context,index){
                            return GestureDetector(

                              onTap: ()
                              {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditImages(snapshot.data[index])));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ListTile(
                                    title: Row(

                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [

                                       Text("تعديل صور التطبيق",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          itemCount: snapshot.data.length,
                        ),
                      );
                    }else if (snapshot.hasError) {
                      return Center(child: Text("Error    " + snapshot.error.toString()),);
                    }
                    return Center(child: Center(child:CircularProgressIndicator()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //*******************************************************************
  // start select all
  _selectall(bool selectall)
  {
    if(selectall)
    {
     ImageDatabase().getallproducts().then((value) {
        for(int i=0; i < value.length ; i++){
          setState(() {
            selectedproducts.add(value[i].documentID);
            allselected = true;
          });
        }
      });
    }else{
      setState(() {
        selectedproducts.clear();
        allselected = false;
      });
    }
  }
  // end select all
 
  // start get elements

  //*************************************************************
  // start make menu
  List<PopupMenuEntry> menu({DocumentSnapshot documentSnapshot=null, AsyncSnapshot<List<DocumentSnapshot>> snapshot=null,int index=null})
  {
    List<PopupMenuEntry> list =
    [
      PopupMenuItem(
        value: index == null ? documentSnapshot["name"] : snapshot.data[index]["name"],
        child: Row(
          children: [
            FlatButton.icon(
              icon: Icon(Icons.edit),
              label: Text("Edit"),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    EditImages(index == null ? documentSnapshot:snapshot.data[index]))
                );
              },
            ),
          ],
        ),
      ),
      PopupMenuItem(
        value: index==null?documentSnapshot["name"]:snapshot.data[index]["name"],
        child: Row(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.delete),
              label: Text("Delete"),
              onPressed: ()
              {
                selectedproducts.add( index == null ? documentSnapshot.documentID : snapshot.data[index].documentID);
                _confirmdelete();
              },
            )
          ],
        ),
      )
    ];
    return list;
  }
  // end make menu
  //*************************************************************
  // start build title search
  Widget Titlesearch()
  {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
            hintText: "Search "
        ),
        autofocus: false,
      ),
      suggestionsCallback: (pattern) async
      {
        return await ImageDatabase().getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion)
      {
        return ListTile(
          leading: Icon(Icons.shopping_cart),
          title: Text(suggestion['name']),
          subtitle: Text('\$${suggestion['price']}'),
        );
      },
      onSuggestionSelected: (suggestion) {
        showMenu(
            position: RelativeRect.fromLTRB( 200, 20, 200,200),
            context: context,
            items: menu(documentSnapshot: suggestion)
        );
      },
    );
  }
  // end build title search
  //*****************************************************************
  // start confirm delete
  Future<void> _confirmdelete() async
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warnning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you want to delete selectesd products'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          onPressed: () {
                            _deleteproduct(selectedproducts);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text(
                            'Not now',
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  void _deleteproduct(List<String> products)
  {
    if (products.isNotEmpty)
    {
      setState(() {
        ImageDatabase().deleteproducts(products);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllImage()));
      });
    } else {
      Fluttertoast.showToast(msg: "please select product to delete");
    }
  }
  // end confirm delete
  //*******************************************************************
  // start change check
  void changcheck(bool val, String PRODUCT_ID, AsyncSnapshot<List<DocumentSnapshot>> snapshot)
  {
    if (val)
    {
      setState(() {
        selectedproducts.add(PRODUCT_ID);
      });
    } else {
      setState(() {
        selectedproducts.remove(PRODUCT_ID);
      });
    }

    if (snapshot.data.length != selectedproducts.length)
    {
      setState(() {
        allselected = false;
      });
    } else {
      allselected = true;
    }
  }
// end change check
}