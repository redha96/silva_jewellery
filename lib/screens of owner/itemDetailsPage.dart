// import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_stroage;
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:silva_jewellery/dataClasses/Item.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ItemDetailsPage extends StatelessWidget {
  // This widget is the root of your application.

  final Item itemToAdd;
  ItemDetailsPage.withItem(this.itemToAdd);

// Id(), SellPrice() , CostOfGram(),getWeight(), CostOfPackaging(), CostOfAds(), StockCount(), ImageUrl()
  // AddItemPage();

  @override
  Widget build(BuildContext context) {
    return AddItemForm(itemToAdd);
  }
}

class AddItemForm extends StatefulWidget {
  final Item currentItem;
  AddItemForm(this.currentItem);
  @override
  State<StatefulWidget> createState() => _AddItemFormState(currentItem);
}

class PackagePrice {
  int bag;
  int box;
}

class _AddItemFormState extends State<AddItemForm> {
  final Item currentItem;
  _AddItemFormState(this.currentItem);
  String result = '';
  static const Color bluePrimaryColor = Color(0xFF607aa7);
  static const Color silverBackgroundColor = Color(0xFFc9dce6);

  //final _currencies = ['Dollars', 'Iraqi Dinar'];
  //String _currency = 'Iraqi Dinar';

  firebase_firestore.CollectionReference _packPriceRef =
      firebase_firestore.FirebaseFirestore.instance.collection('PackagePrice');

  final double _formDistance = 5.0;
  File _image;
  String _imageUrl;
  final imagePicker = ImagePicker();
  PackagePrice packagePrice;

  final _categories = [
    "قلادة",
    "حلق",
    "محبس",
    "سوار",
    "شباحية",
    "تراجي",
    "تخم",
    "زنجيل",
    "مدالية",
    "كافلنك",
    "سبحة",
    "حجل",
    "سيت",
    "هاف سيت",
    "بروش"
  ];
  String _currentCategory = "قلادة";

  void _onDropDownChanged(String value) {
    setState(() {
      this._currentCategory = value;
    });
  }

  Future getImageFromGallery() async {
    var image = await imagePicker.getImage(
        source: ImageSource.gallery); //pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

// i should make it two funcs one fro crop image from firebase and another one to crop image from device
  Future _cropImageFromMobileStorage() async {
    File croppedImage = await ImageCropper.cropImage(sourcePath: _image.path);
    setState(() {
      _image = croppedImage ?? _image;
    });
  }

  Future _cropImageFromNetork() async {
    var imageFile = await DefaultCacheManager()
        .getSingleFile(currentItem.getImageUrl())
        .then((value) => () async {
              print("the string value of value is : " + value.toString());
              File croppedImage =
                  await ImageCropper.cropImage(sourcePath: value.path);
              setState(() => _image = croppedImage);
            });
  }

  void clearImage() {
    setState(() => _image = null);
  }

  void _reset() {
    setState(() {
      idTextController.text = "";
      costOfGramOfSilverTextController.text = "";
      adsCostTextController.text = "";
      sellPriceTextController.text = "";
      weightTextController.text = "";
      _image = null;
      _currentCategory = "قلادة";
    });
  }

  void _upload() async {
    String idOfItem = idTextController.text;
    int costOfGramOfItem = int.parse(costOfGramOfSilverTextController
        .text); //costOfGramOfSilverTextController.text;
    int adsCostOFItem = int.parse(adsCostTextController.text);
    int sellPriceOfItem = int.parse(sellPriceTextController.text);
    int weigthOfItem = int.parse(weightTextController.text);
    int sortId = int.parse(idOfItem.split("-").last);
    int packgeCost = int.parse(packagePriceTextController.text);
    int stockCount = int.parse(countOfItemTextController.text);
    try {
      //firebase_stroage imageFirebaseRef =
      var imageRef = await firebase_stroage.FirebaseStorage.instance
          .ref("products/$_currentCategory / $idOfItem");
      firebase_stroage.UploadTask uploadTask = imageRef.putFile(_image);
      //.putFile(_image);
      uploadTask.then((res) async {
        _imageUrl = await res.ref.getDownloadURL();
        //_imageUrl = res.ref.getDownloadURL();
      }).then((value) {
        var imageUrlOfItem = _imageUrl;

        Item currentItem = Item(
            idOfItem,
            sellPriceOfItem,
            costOfGramOfItem,
            weigthOfItem,
            adsCostOFItem,
            imageUrlOfItem,
            packgeCost,
            stockCount,
            sortId);

        firebase_firestore.DocumentReference productsRef = firebase_firestore
            .FirebaseFirestore.instance
            .collection("silva")
            .doc("products");

        productsRef
            .collection(_currentCategory)
            .doc(currentItem.getId())
            .set(currentItem.toMap()
                //   {
                //   'ads cost': currentItem.costOfAds,
                //   'image url': currentItem.imageUrl,
                //   'package cost': currentItem.costOfPackaging,
                //   'sell price': currentItem.sellPrice,
                //   'weight': currentItem.weightOfItem
                // }
                );
      });
    } on firebase_core.FirebaseException catch (e) {
      print("there is an error in uploading image and it is $e");
    }
  }

  void setItemData(Item item) {
    if (item.getId().toString() != "null") {
      idTextController.text = item.getId();
    }
    if (item.getCostOfGram().toString() != "null") {
      costOfGramOfSilverTextController.text = item.getCostOfGram().toString();
    }

    if (item.getStockCount().toString() != "null") {
      countOfItemTextController.text = item.getStockCount().toString();
    }
    if (item.getCostOfPackaging().toString() != "null") {
      packagePriceTextController.text = item.getCostOfPackaging().toString();
    }
    if (item.getCostOfAds().toString() != "null") {
      adsCostTextController.text = currentItem.getCostOfAds().toString();
    }
    if (item.getSellPrice().toString() != "null") {
      sellPriceTextController.text = currentItem.getSellPrice().toString();
    }
    if (item.getWeight().toString() != "null") {
      weightTextController.text = currentItem.getWeight().toString();
    }
  }

  TextEditingController idTextController = TextEditingController();
  // ..text = currentItem.getId().toString();
  TextEditingController costOfGramOfSilverTextController =
      TextEditingController();
  TextEditingController countOfItemTextController = TextEditingController();
  TextEditingController packagePriceTextController = TextEditingController();
  TextEditingController adsCostTextController = TextEditingController();
  TextEditingController sellPriceTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // String id =
    //   widget.currentItem.getId().toString();
    Item currentItem = widget.currentItem;
    setItemData(currentItem);

    TextStyle textSyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem.getId()),
        backgroundColor: bluePrimaryColor,
      ),
      body: Container(
        //color: silverBackgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Container(
              //   width: _formDistance * 5,
              // ),
              Padding(
                padding: EdgeInsets.only(
                  top: _formDistance,
                  bottom: _formDistance,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: sellPriceTextController,
                          decoration: InputDecoration(
                            labelText: 'سعر البيع',
                            hintText: "30000",
                            labelStyle: textSyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Container(
                      width: _formDistance * 5,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: idTextController,
                          decoration: InputDecoration(
                            labelText: 'رقم القطعة',
                            hintText: "A-22",
                            labelStyle: textSyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        //keyboardType: TextInputType.number,
                        // onChanged: (String string) {
                        //   setState(() {
                        //     name = string;
                        //   });
                        // },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: _formDistance,
                  bottom: _formDistance,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: weightTextController,
                          decoration: InputDecoration(
                            labelText: 'وزن القطعة (غ)',
                            hintText: "12",
                            labelStyle: textSyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Container(
                      width: _formDistance * 5,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: costOfGramOfSilverTextController,
                          decoration: InputDecoration(
                              labelText: 'سعر الغرام',
                              hintText: "3000",
                              labelStyle: textSyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: _formDistance,
                  bottom: _formDistance,
                ),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: adsCostTextController,
                        decoration: InputDecoration(
                            labelText: 'تكلفة الاعلان',
                            hintText: "e.g. 2500",
                            labelStyle: textSyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        keyboardType: TextInputType.number,
                        // onChanged: (String string) {
                        //   setState(() {
                        //     name = string;
                        //   });
                        // },
                      ),
                    ),
                  ),
                  Container(
                    width: _formDistance * 5,
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: packagePriceTextController,
                        decoration: InputDecoration(
                            labelText: 'تكلفة التعليب',
                            hintText: "e.g. 1500",
                            labelStyle: textSyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        keyboardType: TextInputType.number,
                        // onChanged: (String string) {
                        //   setState(() {
                        //     name = string;
                        //   });
                        // },
                      ),
                    ),
                  ),
                ]),
              ),

              // Padding(
              //   padding: EdgeInsets.only(
              //     top: _formDistance,
              //     bottom: _formDistance,
              //   ),
              //   child:Row(children: <Widget>[
              //     Expanded(child:  DropdownButton<String>(
              //     items: _categories.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //     value: _currentCategory,
              //     onChanged: (String value) {
              //       _onDropDownChanged(value);
              //     },),),

              //     Container(
              //         width: _formDistance * 3,
              //       ),
              //       Expanded(
              //         child: Directionality(
              //           textDirection: TextDirection.rtl,
              //           child: TextField(
              //             controller: countOfItemTextController,
              //             decoration: InputDecoration(
              //                 labelText: 'عدد القطع',
              //                 hintText: "400",
              //                 labelStyle: textSyle,
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(5.0),
              //                 )),
              //             keyboardType: TextInputType.number,
              //           ),
              //         ),

              //       ),
              Padding(
                padding: EdgeInsets.only(
                  top: _formDistance,
                  bottom: _formDistance,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton<String>(
                          items: _categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textDirection: TextDirection.rtl,
                              ),
                            );
                          }).toList(),
                          value: _currentCategory,
                          onChanged: (String value) {
                            _onDropDownChanged(value);
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: _formDistance * 5,
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextField(
                          controller: countOfItemTextController,
                          decoration: InputDecoration(
                              labelText: 'عدد القطع',
                              hintText: "400",
                              labelStyle: textSyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: _formDistance,
                  bottom: _formDistance,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.width * 3.5 / 5.0,
                  width: MediaQuery.of(context).size.width * 3.0 / 5.0,
                  child:
                      /*currentItem.getImageUrl() != "null"
                      ?*/
                      // Column(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child:
                      Container(
                    child: Image.network(currentItem.getImageUrl()),
                    width: MediaQuery.of(context).size.width * 3.0 / 5.0,
                    height: MediaQuery.of(context).size.width * 3.0 / 5.0,
                  ),
                ),
                //     Row(
                //       children: [
                //         Expanded(
                //           child: TextButton(
                //             onPressed: _cropImageFromNetork,
                //             child: Icon(Icons.crop),
                //           ),
                //         ),
                //         Expanded(
                //           child: TextButton(
                //             onPressed: clearImage,
                //             child: Icon(Icons.delete),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // )
                /*: _image != null
                          ? ListView(
                              children: <Widget>[
                                Image.file(_image),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: _cropImageFromMobileStorage,
                                        child: Icon(Icons.crop),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: clearImage,
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : TextButton(
                              onPressed: getImageFromGallery,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                              ),
                            ),*/
                //),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: bluePrimaryColor,
                      textColor: Theme.of(context).primaryColorLight,
                      onPressed: _upload,
                      child: Text(
                        "Submit",
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    width: _formDistance * 3,
                  ),
                  Container(
                    width: _formDistance * 3,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      textColor: bluePrimaryColor,
                      onPressed: _reset,
                      child: Text(
                        "Reset",
                        textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
