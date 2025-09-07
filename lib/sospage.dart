import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDpfMS-R7obsy1C718q4zHGQDeUAOYwlGM",
      appId: "1:929442318986:web:dafc90883ecede14ff3b73",
      messagingSenderId: "929442318986",
      projectId: "resqnet-2ae67",
      storageBucket: "resqnet-2ae67.firebasestorage.app",
      databaseURL: "https://resqnet-2ae67-default-rtdb.asia-southeast1.firebasedatabase.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQNet',
      debugShowCheckedModeBanner: false,
      home: const SOSPage(),
    );
  }
}

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(20.2961, 85.8245); // Default center: Bhubaneswar, Odisha

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          // Top bar: Settings & Profile
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, color: Colors.black, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.account_circle, color: Colors.black, size: 32),
                  ),
                ],
              ),
            ),
          ),

          // SOS Button (Center)
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(60), // Large Button
                elevation: 12,
              ),
              onPressed: () {
                // TODO: Implement SOS alert logic
              },
              child: const Text(
                "SOS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Bottom Navigation (Location, Alerts, Community)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SOSList()),
                      );
                    },
                    icon: const Icon(Icons.location_on, size: 32, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active, size: 32, color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.groups, size: 32, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SOS List Page to View Firestore Data
class SOSList extends StatelessWidget {
  const SOSList({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference sosCollection =
        FirebaseFirestore.instance.collection('SOS');

    return Scaffold(
      appBar: AppBar(title: const Text("SOS Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: sosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data ❌"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sosDocs = snapshot.data!.docs;

          if (sosDocs.isEmpty) {
            return const Center(child: Text("No SOS requests yet ✅"));
          }

          return ListView(
            children: sosDocs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? "Unknown";
              final lat = data['lat'] ?? "N/A";
              final lng = data['lng'] ?? "N/A";

              return Card(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text("Lat: $lat, Lng: $lng"),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
