import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/pages/recipe_detail_screen.dart';
import 'package:recipe_app/provider/favorite_provider.dart';

class FoodItemDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag:  documentSnapshot['image'],
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          documentSnapshot['image'],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  documentSnapshot["name"],
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      "${documentSnapshot["cal"]}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const Text(
                      " · ",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: Colors.grey),
                    ),
                    const Icon(Iconsax.clock, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      "${documentSnapshot["time"]} Часа",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            //favorite button
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    provider.toogleFavorite(documentSnapshot);
                  },
                  child: Icon(
                    provider.isExist(documentSnapshot)
                        ? Iconsax.heart5
                        : Iconsax.heart,
                    color: provider.isExist(documentSnapshot)
                        ? Colors.red
                        : Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
