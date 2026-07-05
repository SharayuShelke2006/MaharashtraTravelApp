import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? selectedLocation;
  GoogleMapController? mapController; // 👈 Isko nullable banaya taaki safely handle ho sake

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(19.0760, 72.8777), // Mumbai default
    zoom: 12, // 👈 Zoom thoda badha diya taaki city acche se dikhe
  );

  @override
  void dispose() {
    mapController?.dispose(); // 👈 Controller ko dispose karna achhi practice hai
    super.dispose();
  }

  void _onTap(LatLng position) {
    setState(() {
      selectedLocation = position;
    });
  }

  void _confirmLocation() {
    if (selectedLocation != null) {
      Navigator.pop(context, selectedLocation);
    } else {
      // User ko batane ke liye agar unhone location pick nahi ki
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kripya map par tap karke location select karein!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              "DONE",
              style: TextStyle(
                color: Colors.blue, // 👈 Agar AppBar background white hai toh text visible rahega
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      // 👈 SizedBox.expand lagane se Web aur Mobile dono par Map poori screen par sahi se fit ho jata hai
      body: SizedBox.expand(
        child: GoogleMap(
          initialCameraPosition: initialPosition,
          onMapCreated: (controller) {
            mapController = controller;
          },
          onTap: _onTap,
          myLocationEnabled: true, // 👈 User apni current location bhi dekh sake map par
          myLocationButtonEnabled: true,
          markers: selectedLocation == null
              ? {}
              : {
                  Marker(
                    markerId: const MarkerId("picked"),
                    position: selectedLocation!,
                  )
                },
        ),
      ),
    );
  }
}