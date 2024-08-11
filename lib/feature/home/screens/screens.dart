import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/common/common.dart';
import '../../../core/constants/firebaseConstants/firebaseConstants.dart';
import '../notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String location = "Fetching location...";
  final NotificationService notificationService = NotificationService();
  String userName = "";
  String userProfileImage = "";
  String userphone = "";

  @override
  void initState() {
    super.initState();
    notificationService.initialize();
    getCurrentLocation();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection(FirebaseCollections
          .usersCollection).doc(userId).get();

      // Extract data from the document
      setState(() {
        userName = userDoc['name'];
        userphone = userDoc['phoneNumber'];
        userProfileImage = userDoc['profilePic'];
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Location permissions are permanently denied.";
      });
      return;
    }

    // When we reach here, permissions are granted and we can access the location.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the latitude and longitude to an address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    setState(() {
      location = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade300,
      appBar: AppBar(
        backgroundColor: Colors.red.shade300,
        leading: Padding(
          padding: EdgeInsets.only(left: width * .02),
          child: userProfileImage.isNotEmpty
              ? CircleAvatar(
            backgroundImage: NetworkImage(userProfileImage),
          )
              : CircleAvatar(),
        ),
        title: Text(userName.isNotEmpty ? userName : userName.isEmpty ? userphone : 'No Name'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height * .1),
              Center(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_pin,
                              color: Colors.white, size: width * .05),
                          Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: width * .04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      location == "Fetching location..."
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        location,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * .3),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    notificationService.showNotification(
                      title: 'Test Notification',
                      body: 'This is a test notification from button press.',
                    );                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown.shade900,
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Show Notification',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
