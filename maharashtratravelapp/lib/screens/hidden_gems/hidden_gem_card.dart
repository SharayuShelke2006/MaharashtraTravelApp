import 'package:flutter/material.dart';

import '../../../widgets/distance_text.dart';
import 'hidden_gem_detail_screen.dart';

class HiddenGemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isClosest;

  const HiddenGemCard({
    super.key,
    required this.data,
    this.isClosest = false,
  });

  @override
  Widget build(BuildContext context) {
    final image = data["coverImage"] ?? "";

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HiddenGemDetailScreen(
        data: data,
      ),
    ),
  );
},
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mobile = constraints.maxWidth < 520;

            if (mobile) {
              return _mobileCard(context, image);
            }

            return _desktopCard(context, image);
          },
        ),
      ),
    );
  }

  Widget _desktopCard(BuildContext context, String image) {
    return SizedBox(
      height: 165,
      child: Row(
        children: [
          _image(image, 135),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: _content(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileCard(BuildContext context, String image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image(image, double.infinity),

        Padding(
          padding: const EdgeInsets.all(18),
          child: _content(context),
        ),
      ],
    );
  }

  Widget _image(String image, double width) {
    return ClipRRect(
      borderRadius: width == double.infinity
          ? const BorderRadius.vertical(
              top: Radius.circular(22),
            )
          : const BorderRadius.horizontal(
              left: Radius.circular(22),
            ),
      child: Image.network(
        image,
        width: width,
        height: 170,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: width,
            height: 170,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image,
              size: 45,
            ),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.bold,
                    ),
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: Colors.grey,
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                data["address"],
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        DistanceText(
          latitude: (data["latitude"] as num)
              .toDouble(),
          longitude:
              (data["longitude"] as num)
                  .toDouble(),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green
                    .withValues(alpha: .12),
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: Text(
                data["category"],
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            if (isClosest)
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange
                      .withValues(alpha: .12),
                  borderRadius:
                      BorderRadius.circular(30),
                ),
                child: const Text(
                  "Nearest",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}