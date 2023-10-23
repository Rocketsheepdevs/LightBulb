import 'package:flutter/material.dart';
import 'ChatPage.dart';
import 'SearchPage.dart';
import 'MePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int imageIndex = 0;
  int userIndex = 0;
  int currentIndex = 1;
  List<List<String>> images = [
    ['images/ahri/1.png', 'images/ahri/2.png'],
    ['images/asuna/1.png', 'images/asuna/2.png', 'images/asuna/3.png'],
    ['images/jett/1.png', 'images/jett/2.png'],
  ];
  List<String> userName = ['Ahri', 'Asuna', 'Jett'];
  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Lightbulb'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Text("Menu"),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Colors.red,
          child: Center(
            child: Text(
              "Settings",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          double delta = details.primaryVelocity!;
          if (delta < -500) {
            setState(() {
              userIndex = (userIndex + 1) % images.length;
              imageIndex = 0;
            });
          } else if (delta > 500) {
            setState(() {
              userIndex = (userIndex - 1 + images.length) % images.length;
              imageIndex = 0;
            });
          }
        },
        child: ListView(
          shrinkWrap: false,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      kBottomNavigationBarHeight,
                  child: Image.asset(
                    images[userIndex][imageIndex],
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_left,
                                size: 50.0,
                              ),
                              onPressed: _onBackPressed,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_right,
                              size: 50.0,
                            ),
                            onPressed: _onNextPressed,
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(37, 150, 190, 0.9),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        userName[userIndex],
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Find Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Me',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onBackPressed() {
    setState(() {
      imageIndex = (imageIndex - 1 + images[userIndex].length) %
          images[userIndex].length;
    });
  }

  void _onNextPressed() {
    setState(() {
      imageIndex = (imageIndex + 1) % images[userIndex].length;
    });
  }
}
