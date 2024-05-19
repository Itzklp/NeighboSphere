import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:neighbosphere/HomePages/MembersFunction/FeedbackPage.dart';
import 'package:neighbosphere/HomePages/MembersFunction/MaintainReq.dart';
import 'package:neighbosphere/HomePages/MembersFunction/ManageHouse.dart';
import 'package:neighbosphere/HomePages/MembersFunction/VisitorRecord.dart';
import 'package:neighbosphere/HomePages/SecurityFunctions/AddVisitor.dart';
import '../../SignupPages/SignIn.dart';

class UserHome extends StatefulWidget {
  final String? memberId;
  final String? societyId;

  const UserHome({Key? key, required this.memberId, required this.societyId})
      : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool _showAppBar = true;
  late ScrollController _scrollController;
  String _memberFirstName = "Home"; // Default value

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchMemberFirstName();
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

  Future<void> _fetchMemberFirstName() async {
    if (widget.memberId != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Members')
            .doc(widget.memberId)
            .get();
        if (doc.exists) {
          setState(() {
            _memberFirstName = doc['fname'] ?? 'Home';
          });
        } else {
          setState(() {
            _memberFirstName = 'Home'; // Default if document does not exist
          });
        }
      } catch (e) {
        print("Error fetching member data: $e");
        setState(() {
          _memberFirstName = 'Home'; // Default in case of error
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
              title: const Text('Home'),
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
                    "assets/black_house.png",
                    width: 110, // Adjust the width as needed
                    height: 110, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                  Text("Hi, $_memberFirstName"),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Manage House',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManageHouse(societyId: widget.societyId, memberId: widget.memberId),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.person_add,
              text: 'Add Visitor',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVisitor(
                      memberId: widget.memberId,
                      societyId: widget.societyId,
                    ),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.record_voice_over,
              text: 'Visitor Record',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VisitorRecord(societyId: widget.societyId, memberId: widget.memberId),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.request_page,
              text: 'Maintenance Request',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MaintainReq(memberId: widget.memberId, societyId: widget.societyId),
                  ),
                );
              },
            ),
            // _buildDrawerItem(
            //   icon: Icons.book_online,
            //   text: 'Book Facility',
            //   onTap: () {},
            // ),
            _buildDrawerItem(
              icon: Icons.feedback,
              text: 'Feedback',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackWidgit(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
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
                    'assets/h4.png',
                    'assets/h5.png',
                    'assets/h7.png',
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
                        'Welcome to NeighboSphere, where seamless society management meets enhanced community living. Our platform offers a suite of features designed to simplify your day-to-day tasks and foster a vibrant neighborhood experience.',
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
                        child: Image.asset('assets/i1.png'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Image.asset('assets/i3.png'),
                      ),
                      Expanded(
                        child: Image.asset('assets/i2.png'),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '"Community is not just where you live, it\'s where you belong."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Stay informed and connected with NeighboSphere\'s quick access features! Explore upcoming events, submit maintenance requests, and share feedbacks effortlessly.',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: Icon(icon, color: HexColor("#8a76ba")),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
