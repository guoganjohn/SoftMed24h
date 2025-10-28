import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

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
        toolbarHeight: 0,
        elevation: 0,
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
                                  'MeuMed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                  softWrap: false,
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
                            child: SizedBox(
                              width: 40,
                              height: 40,
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
                ),
                ListTile(
                  leading: SizedBox(
                    width: 24, // Constrain the width of the leading icon
                    child: const Icon(Icons.home, color: Colors.white),
                  ),
                  title: _isSidebarExpanded
                      ? const Text(
                          'Início',
                          style: TextStyle(color: Colors.white),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
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
                  leading: SizedBox(
                    width: 24, // Constrain the width of the leading icon
                    child: const Icon(Icons.logout, color: Colors.white),
                  ),
                  title: _isSidebarExpanded
                      ? const Text(
                          'Sair',
                          style: TextStyle(color: Colors.white),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () async {
                    await SessionManager().clearToken();
                    context.go('/login');
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
                    'Você fez o login com sucesso!',
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
