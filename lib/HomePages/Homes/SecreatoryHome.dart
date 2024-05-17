import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neighbosphere/HomePages/MembersFunction/ManageHouse.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/FacilityManagement.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/HouseData.dart';
import 'package:neighbosphere/HomePages/SecretaryFunctions/MemberList.dart';
import '../../SignupPages/SignIn.dart';
import '../SecretaryFunctions/ManageMaintainance.dart';

class SecretaryHome extends StatefulWidget {
  final String? memberId;
  final String? societyId;

  const SecretaryHome({Key? key, required this.societyId, required this.memberId})
      : super(key: key);

  @override
  _SecretaryHomeState createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  bool _showAppBar = true;
  late ScrollController _scrollController;
  String _secretaryFirstName = "Home"; // Default value

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchSecretaryFirstName();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showAppBar) {
        setState(() {
          _showAppBar = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showAppBar) {
        setState(() {
          _showAppBar = true;
        });
      }
    }
  }

  Future<void> _fetchSecretaryFirstName() async {
    if (widget.memberId != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Members')
            .doc(widget.memberId)
            .get();
        if (doc.exists) {
          setState(() {
            _secretaryFirstName = doc['fname'] ?? 'Home';
          });
        } else {
          setState(() {
            _secretaryFirstName = 'Home'; // Default if document does not exist
          });
        }
      } catch (e) {
        print("Error fetching secretary data: $e");
        setState(() {
          _secretaryFirstName = 'Home'; // Default in case of error
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend content behind app bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40), // Set the height of the app bar
        child: AnimatedOpacity(
          opacity: _showAppBar ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.shade800.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Transparent app bar
              elevation: 0, // No shadow
              title: const Text('Secretary Home'),
              centerTitle: true,
              flexibleSpace: SizedBox(height: 80), // Add space in the app bar
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: HexColor("#8a76ba"),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/p2.png",
                    width: 200, // Adjust the width as needed
                    height: 110, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                  Text("Hi, $_secretaryFirstName"),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.house,
              text: 'House List',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HouseData(societyId: widget.societyId),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.group,
              text: 'Manage Members',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberList(
                      societyId: widget.societyId,
                      memberId: widget.memberId,
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.request_page,
              text: 'Member Request',
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.ad_units_outlined,
              text: 'Manage Maintenance',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MaintenanceRequestListPage(
                      societyId: widget.societyId,
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.manage_accounts,
              text: 'Facility Management',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityManagement(
                      memberId: widget.memberId,
                      societyId: widget.societyId,
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Sign Out',
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                } catch (e) {
                  print("Error signing out: $e");
                  // Handle sign-out errors here
                }
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 108), // Space between app bar and carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 220.0, // Adjusted height to accommodate the text
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: [
                    'assets/sec2.png',
                    'assets/sec1.png',
                    'assets/sec3.png',
                  ].map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  imagePath,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Welcome to NeighboSphere Secretary Portal. Just from swiping right, This platform helps to manage the society efficiently with features like member management, maintenance handling, and facility management.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset('assets/i4.png'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset('assets/i5.png'),
                      ),
                      Expanded(
                        child: Image.asset('assets/i6.png'),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '"No one is more cherished in this world than someone who lightens the burden of another."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
