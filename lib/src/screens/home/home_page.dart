import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarExpanded = true; // State to manage sidebar expansion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to MeuMed!'),
        automaticallyImplyLeading: false, // No back button on home page
      ),
      body: Row(
        children: [
          // Persistent Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Animation curve
            width: _isSidebarExpanded ? 250 : 60, // Dynamic width
            color: Colors.blue[800],
            child: Column(
              children: <Widget>[
                // DrawerHeader with toggle button
                Container(
                  height: 120, // Standard DrawerHeader height
                  color: Colors.blue,
                  child: _isSidebarExpanded
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: const Text(
                                  'MeuMed Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ), // Shift right
                                onPressed: () {
                                  setState(() {
                                    _isSidebarExpanded = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                            ), // Shift right
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSidebarExpanded = true;
                                });
                              },
                            ),
                          ),
                        ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: _isSidebarExpanded
                      ? const Text(
                          'Home',
                          style: TextStyle(color: Colors.white),
                        )
                      : null,
                  onTap: () {
                    // Already on home, so do nothing or refresh
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ), // Pushes the logout button to the bottom
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: _isSidebarExpanded
                      ? const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        )
                      : null,
                  onTap: () {
                    // Implement logout logic here
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
          // Main Content
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have successfully logged in!',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
