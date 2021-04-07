//import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_stroage;
import 'package:path/path.dart';
import 'package:silva_jewellery/dataClasses/Item.dart';
import 'package:silva_jewellery/dataClasses/ItemToView.dart';
import 'package:silva_jewellery/screens%20of%20owner/addItemPage.dart';
import 'package:silva_jewellery/dataClasses/Category.dart';
import 'package:silva_jewellery/screens of owner/itemDetailsPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductsListState();
}

class ProductsListState extends State {
  static const Color bluePrimaryColor = Color(0xFF607aa7);

  String category = "قلادة";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Silva Jewellery',
        ),
        backgroundColor: bluePrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddItemPage();
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: bluePrimaryColor,
      ),
      body: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            categoriesHorizantalList(),

            Expanded(child: productsListItems()),

            //productsListItems(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     navigateToDetailPage(
      //         ItemToAdd("", null, null, null, null, "", null, null));
      //   },
      //   tooltip: "Add new Item",
      //   child: new Icon(Icons.add),
      // ),
    );
  }

  Widget categoriesHorizantalList() {
    return SizedBox(
      height: 125.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            child: Category(
                "images/categories/heart-shaped-jewelry-pendant.png", "قلادة"),
            onTap: (() {
              setState(() {
                category = "قلادة";
              });
            }),
          ),

          InkWell(
            child: Category("images/categories/wedding-rings.png", "حلق"),
            onTap: (() {
              setState(() {
                category = "حلق";
              });
            }),
          ),

          InkWell(
            child: Category("images/categories/ring.png", "محبس"),
            onTap: (() {
              setState(() {
                category = "محبس";
              });
            }),
          ),

          //Category("", "سوار"),
          // Category("", "شباحية"),

          InkWell(
            child: Category("images/categories/earring.png", "تراجي"),
            onTap: (() {
              setState(() {
                category = "تراجي";
              });
            }),
          ),

          InkWell(
            child: Category("images/categories/box.png", "تخم"),
            onTap: (() {
              setState(() {
                category = "تخم";
              });
            }),
          ),
          // Category("", "زنجيل"),
          // Category("", "مدالية"),
          // Category("", "كافلنك"),
          InkWell(
            child: Category("images/categories/pearl-necklace .png", "سبحة"),
            onTap: (() {
              setState(() {
                category = "سبحة";
              });
            }),
          ),

          InkWell(
            child: Category("images/categories/ankle.png", "حجل"),
            onTap: (() {
              setState(() {
                category = "حجل";
              });
            }),
          ),

          InkWell(
            child: Category("images/categories/box.png", "سيت"),
            onTap: (() {
              setState(() {
                category = "سيت";
              });
            }),
          ),
          InkWell(
            child: Category("images/categories/half_set.png", "هاف سيت"),
            onTap: (() {
              setState(() {
                category = "هاف سيت";
              });
            }),
          ),
          // Category("", "بروش"),
        ],
      ),
    );
  }

  // Widget productsListItems() {
  //   itemsList = getItems("محبس");
  //   if (itemsList != null) if (itemsList.length != 0) {
  //     return Container(
  //       child: ListView.builder(
  //           scrollDirection: Axis.vertical,
  //           shrinkWrap: true,
  //           itemCount: itemsList.length,
  //           itemBuilder: (BuildContext context, int postion) {
  //             return Card(
  //               color: Colors.white,
  //               elevation: 2.0,
  //               child: ListTile(
  //                 leading: Image.network(this.itemsList[postion].getImageUrl()),
  //                 title:
  //                     // Row(
  //                     //   children: [
  //                     Text(this.itemsList[postion].getId().toString()),
  //                 //   Text(this.itemsList[postion].getSellPrice().toString())
  //                 // ],
  //                 //),
  //                 subtitle:
  //                     Text(this.itemsList[postion].getStockCount().toString()),
  //               ),
  //             );
  //           }),
  //     );
  //   } else {
  //     return Container(
  //         alignment: Alignment.center,
  //         child: Text("there is no data in this category"));
  //   }
  // }

  Widget productsListItems() {
    return FutureBuilder(
      future: getItems(category),
      builder: (_, snapshot) {
        print("the value of snapshot is :" + snapshot.data.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading"));
        } else {
          // else{
          //   Center(child: Text("there is no data from else"));
          // }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            if (documents.length == 0) {
              return Center(child: Text("there is no data"));
            }
            // return ListView.builder(
            //     itemCount: 1,
            //     itemBuilder: (_, index) {
            //       return Card(
            //         color: Colors.white,
            //         elevation: 2.0,
            //         child: ListTile(
            //           leading:
            //               Image.network(snapshot.data[index].data["image url"]),
            //           title:
            //               // Row(
            //               //   children: [
            //               Text(snapshot.data[index].id),
            //           //   Text(this.itemsList[postion].getSellPrice().toString())
            //           // ],
            //           //),
            //           subtitle:
            //               Text(snapshot.data[index].data["stock"]), //stockcount
            //         ),
            //       );
            //     });

            return ListView(
              children: documents
                  .map(
                    (doc) => InkWell(
                        //                 ItemToAdd(this._id, this._sellPrice, this._costOfGram, this._weightOfItem,
                        // this._costOfAds, this._imageUrl, this._costOfPackaging, this._stockCount);

                        onTap: () {
                          final currentItem = Item(
                              doc.id,
                              doc["sell price"],
                              doc["cost of gram"],
                              doc["weight"],
                              doc["ads cost"],
                              doc["image url"],
                              doc["package cost"],
                              doc["stock"],
                              doc["sortId"]);
                          navigateToItemDetailsPage(currentItem
                              //ItemToAdd.fromQuerySnapshot(doc)

                              );
                        },
                        child: Card(
                          child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actions: <Widget>[
                        IconSlideAction(
                          caption: "ادخال",
                          color: Color(0xFFc9dce6),
                          icon: Icons.plus_one,
                          onTap: () async {
                            int stock = doc["stock"] + 1;
                            await doc.reference.update({"stock": stock}).then(
                                (value) => setState(() {}));
                          },
                        ),
                        IconSlideAction(
                          caption: "اخراج",
                          color: Color(0xFF111b4e),
                          icon: Icons.exposure_minus_1,
                          onTap: () async {
                            int stock = doc["stock"] - 1;
                            await doc.reference.update({"stock": stock}).then(
                                (value) => setState(() {
                                  
                                }));
                          },
                        )
                      ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.add_shopping_cart,
                          color: Color(0xff6d7c9a),
                        )
                      ],
                      child: ListTile(
                            leading: Image.network(doc["image url"]),
                            title: Row(
                              children: [
                                Expanded(child: Text(doc.id)),
                                Expanded(
                                    child: Text(
                                        doc["sell price"].toString() + " IQD"))
                              ],
                            ),
                            subtitle:
                                Text("Stock : " + doc['stock'].toString()),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Its Error!');
          }
        }
      },
    );
  }

  void navigateToAddItemPage() async {
    bool result = await Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => AddItemPage()),
    );
    if (result == true) {
      setState(() {});
    } else
      debugPrint("the value of result is" + result.toString());
  }

  void navigateToItemDetailsPage(Item itemToAdd) async {
    final Item currentItem = itemToAdd;
    bool result = await Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => ItemDetailsPage.withItem(currentItem)),
    );
    if (result == true) {
      //getData();
      /*

      her i should call a function that will get all the elements again to get the new added item too



      */
    } else
      debugPrint("the value of result is" + result.toString());
  }

  Future getItems(String category) {
    List<Item> items = <Item>[];
    //QuerySnapshot qShot = await
    var firestoreList = FirebaseFirestore.instance
        .collection('silva')
        .doc('products')
        .collection(category)
        .orderBy('sortId', descending: false)
        .get();

    return firestoreList;

//         .then((qShot) => {
//               items = qShot.docs
//                   .map((doc) => ItemToAdd(
//                       doc.id,
//                       doc.data()["sell price"],
//                       doc.data()["cost of gram"],
//                       doc.data()["weight"],
//                       doc.data()["ads cost"],
//                       doc.data()["image url"],
//                       doc.data()["package cost"],
//                       doc.data()["stock"]))
//                   .toList()

//             });

// return items;
    print(items);

    //     (doc) => UserTask(
    //         doc.data['id'],
    //         doc.data['Description'],
    //         etc...)
    // ).toList();

    // return qShot.docs
    //     .map((doc) => ItemToAdd(
    //         doc.data()["id"],
    //         doc.data()["sell price"],
    //         doc.data()["cost of gram"],
    //         doc.data()["weight"],
    //         doc.data()["ads cost"],
    //         doc.data()["image url"],
    //         doc.data()["package cost"],
    //         doc.data()["stock"]))
    //     .toList();
    // .then((QuerySnapshot querySnapshot) => {
    //       querySnapshot.docs.forEach((doc) {
    //         ItemToAdd item = ItemToAdd.fromObject(doc);
    //         items.add(item);
    //         print("Item " + doc.id.toString() + " added secssfully");
    //       })
    //     });
    //return items;
  }
}
