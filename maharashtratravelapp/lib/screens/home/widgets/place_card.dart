import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const PlaceCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final image = data["coverImage"] ?? "";

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    final imageWidth = isDesktop ? 185.0 : 130.0;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
  context.push(
    "/place",
    extra: data,
  );
},
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: Hero(
  tag: data["coverImage"],
  child: Image.network(
    image,
    width: imageWidth,
    height: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) {
      return Container(
        width: imageWidth,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image,
          size: 45,
        ),
      );
    },
  ),
),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            data["name"] ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.favorite_border,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [

                        const Icon(
                          Icons.location_on_outlined,
                          size: 17,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            data["address"] ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        data["category"] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}