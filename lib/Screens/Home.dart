import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:machinetest/widgets/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:machinetest/widgets/container.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final String apiKey = 'kp86L8-MnM4SXB0kKGH43O6Vv-bdIy7TaMqO2vqA7oE';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<String>> fetchImages() async {
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/photos'),
      headers: {
        'Authorization': 'Client-ID $apiKey',
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map<String>((photo) => photo['urls']['regular'] as String)
          .toList();
    } else {
      throw Exception('Failed to load images');
    }
  }





Future<void> downloadImage(String imageUrl, BuildContext context) async {
  // Request storage permission
  var status = await Permission.storage.request();

  if (status.isDenied) {
    // If permission is denied, show a top notification
    TopNotification.show(context, 'Permission denied');
    return; // Return early if permission is denied
  }

  try {
    // Get the directory to save the image (use external storage directory)
    Directory? appDocDirectory = await getExternalStorageDirectory();
    if (appDocDirectory == null) {
      TopNotification.show(context, 'Error: Could not get storage directory');
      return;
    }

    // Create a file path where the image will be stored
    String filePath = '${appDocDirectory.path}/downloaded_image.jpg';

    // Download image using Dio
    Dio dio = Dio();
    await dio.download(imageUrl, filePath);

    // Inform the user that the image has been saved using a top notification
    TopNotification.show(context, 'Image downloaded to $filePath');
  } catch (e) {
    print("Error downloading ......: $e");
    TopNotification.show(context, 'Error downloading...');
  }
}
  Widget card(String imageUrl, String name, IconData icon, double height,
      String price) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              price,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/profile5.jpg'),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // Follow button logic
            },
            child: const Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          tabs: List.generate(3, (index) {
            return Tab(
              child: ElevatedButton(
                onPressed: () {
                  _tabController.animateTo(index);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tabController.index == index
                      ? Colors.white
                      : Colors.black,
                  foregroundColor: _tabController.index == index
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  index == 0
                      ? "Activity"
                      : index == 1
                          ? "Comunity"
                          : "Shop",style: TextStyle(fontSize: 11),
                ),
              ),
            );
          }),
        ),
      ),
      body: TabBarView(
  controller: _tabController,
  children: [
    // Tab 1: Activity
    RoundedContainer(
      child: tabContent("Activity Tab Content"),
    ),

    // Tab 2: Community
    RoundedContainer(
      child: tabContent("Community Tab Content"),
    ),

    // Tab 3: Shop
    FutureBuilder<List<String>>(
      future: fetchImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<String> imageUrls = snapshot.data!;
          return Container(
            color: Colors.black,
            child: Stack(
              children: [
                // Background container with rounded corners
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          "All Products",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Product grid
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.5,
                          ),
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                downloadImage(imageUrls[index], context);
                              },
                              child: card(
                                imageUrls.reversed.toList()[index],
                                'Mens White Plumeria ${index + 1}',
                                Icons.more_horiz,
                                250,
                                '\$${(index + 1) * 10}',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom navigation bar styled as floating
                Positioned(
                  top: 530,
                  left: 30,
                  right: 30,
                  bottom: 30,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.home, size: 30, color: Colors.red),
                        Icon(Icons.search, size: 30, color: Colors.grey),
                        Icon(Icons.notifications, size: 30, color: Colors.grey),
                        Icon(Icons.person_2, size: 30, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No products available'));
        }
      },
    ),
  ],
),

   

    );
  }

  Widget tabContent(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
