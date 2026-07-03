import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class FeaturedPlaceCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const FeaturedPlaceCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    final image = data["coverImage"] ?? "";

    return GestureDetector(

      onTap: () {
        context.push(
          "/place",
          extra: data,
        );
      },

      child: ClipRRect(

        borderRadius: BorderRadius.circular(28),

        child: Stack(

          children: [

            AspectRatio(

              aspectRatio: 16 / 9,

              child: Image.network(

                image,

                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {

                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned.fill(

              child: Container(

                decoration: const BoxDecoration(

                  gradient: LinearGradient(

                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                    colors: [

                      Colors.transparent,

                      Colors.black54,

                    ],
                  ),
                ),
              ),
            ),

            Positioned(

              left: 20,
              right: 20,
              bottom: 20,

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Container(

                    padding:
                        const EdgeInsets.symmetric(

                      horizontal: 14,
                      vertical: 7,

                    ),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(50),

                    ),

                    child: Text(

                      data["category"],

                      style: TextStyle(

                        color: Theme.of(context)
                            .colorScheme
                            .secondary,

                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(

                    data["name"],

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(

                    children: [

                      const Icon(

                        Icons.location_on,

                        color: Colors.white70,

                        size: 18,

                      ),

                      const SizedBox(width: 5),

                      Expanded(

                        child: Text(

                          data["address"],

                          style: const TextStyle(

                            color: Colors.white70,

                          ),
                        ),
                      ),

                    ],
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}