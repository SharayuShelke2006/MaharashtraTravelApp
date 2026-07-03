import 'package:flutter/material.dart';

class PlaceInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const PlaceInfo({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            data["name"],
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              const Icon(
                Icons.location_on,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  data["address"],
                ),
              ),

            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: .12),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: Text(
              data["category"],
            ),
          ),

        ],
      ),
    );
  }
}