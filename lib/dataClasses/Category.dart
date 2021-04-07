import 'package:flutter/material.dart';
import 'package:silva_jewellery/screens%20of%20owner/productslist.dart';

class Category extends StatelessWidget {

  static const Color bluePrimaryColor = Color(0xFF607aa7);

  final String imagePath;
  final String imageCaption;

  Category(this.imagePath, this.imageCaption);

  @override
  Widget build(BuildContext context) {
    var imageWidth = MediaQuery.of(context).size.width / 5;

    return Padding(
      padding: EdgeInsets.all(4.0),
      child:
      //  InkWell(
      //   onTap: () {},
      //   child:
         Container(
          width: imageWidth,
          child: ListTile(
            // (Icons.star, color: Colors.green [500]),
            title: Image.asset(
              imagePath,
              width: imageWidth,
              height: imageWidth,
              color: bluePrimaryColor,
            ),
            subtitle: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  imageCaption,
                )),
          ),
        ),
     // ),
    );
  }
}
