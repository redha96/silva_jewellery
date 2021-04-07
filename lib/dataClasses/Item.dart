import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  String _id;
  int _sellPrice;
  int _costOfGram;
  int _weightOfItem;
  int _costOfAds;
  String _imageUrl;
  int _costOfPackaging;
  int _stockCount;
  int _sortId;

  Item(this._id, this._sellPrice, this._costOfGram, this._weightOfItem,
      this._costOfAds, this._imageUrl, this._costOfPackaging, this._stockCount, this._sortId);

  Map<String, dynamic> toMap() {
    return {
      'ads cost': this._costOfAds,
      'cost of gram': this._costOfGram,
      'image url': this._imageUrl,
      'package cost': this._costOfPackaging,
      'sell price': this._sellPrice,
      'weight': this._weightOfItem,
      'stock': this._stockCount,
      'sortId': this._sortId,
    };
  }

// creating a Trip object from a firebase snapshot
  Item.fromQuerySnapshot(DocumentSnapshot snapshot)
      : _id = snapshot.id,
        _costOfGram = snapshot['ads cost'],
        _imageUrl = snapshot['image url'],
        _costOfPackaging = snapshot['package cost'],
        _sellPrice = snapshot['sell price'],
        _weightOfItem = snapshot['weight'],
        _stockCount = snapshot['stock'];
  // _id = snapshot.documentID,

  Item.fromObject(dynamic o) {
    this._id = o["id"];
    this._sellPrice = o["sell price"];
    this._costOfGram = o["cost of gram"];
    this._weightOfItem = o["weight of item"];
    this._costOfAds = o["ads cost"];
    this._imageUrl = o["image url"];
    this._costOfPackaging = o["packaging cost"];
    this._stockCount = o['stock count'];
  }

  String getId() {
    return this._id;
  }

  int getSellPrice() {
    return this._sellPrice;
  }

  int getCostOfGram() {
    return this._costOfGram;
  }

  int getWeight() {
    return this._weightOfItem;
  }

  int getCostOfAds() {
    return this._costOfAds;
  }

  String getImageUrl() {
    return this._imageUrl;
  }

  int getCostOfPackaging() {
    return this._costOfPackaging;
  }

  int getStockCount() {
    return this._stockCount;
  }
}
