import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/utils/constant.dart';
import 'package:recipe_app/widget/food_item_display.dart';

import '../widget/my_icon_button.dart';

class ViewAllItem extends StatefulWidget {
  const ViewAllItem({super.key});

  @override
  State<ViewAllItem> createState() => _ViewAllItemState();
}

class _ViewAllItemState extends State<ViewAllItem> {
  final CollectionReference completeApp =
      FirebaseFirestore.instance.collection("Complete-Flutter-App");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          const SizedBox(width: 15),
          MyIconButton(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Text(
            "Quick & Easy",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          MyIconButton(
            icon: Iconsax.notification,
            pressed: () {},
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: completeApp.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      shrinkWrap: true, // Позволяет GridView строить только столько элементов, сколько нужно
                      physics: const NeverScrollableScrollPhysics(), // Отключаем скролл в GridView, так как он находится внутри SingleChildScrollView
                      itemCount: streamSnapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return SizedBox(
                          
                          child: Column(
                            children: [
                              FoodItemDisplay(
                                  documentSnapshot: documentSnapshot),
                              Row(
                                children: [
                                  const Icon(Iconsax.star1,
                                      color: Colors.amber),
                                  const SizedBox(width: 5),
                                  Text(
                                    documentSnapshot['rating'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text("/5"),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${documentSnapshot['reviews']} Reviews",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
