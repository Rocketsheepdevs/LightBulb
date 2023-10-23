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
  int currentIndex = 1;
  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    // Handle navigation to the next page based on the selected index.
    // For simplicity, I'm using a switch statement here.
    switch (index) {
      case 0:
        // Navigate to the Chat page
        // You can replace 'ChatPage' with the actual class/page you want to navigate to.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
        break;
      case 1:
        // Navigate to the Search page
        // Replace 'SearchPage' with the actual class/page you want to navigate to.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 2:
        // Navigate to the Me page
        // Replace 'MePage' with the actual class/page you want to navigate to.
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
      body: Text('screen'),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
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
}
