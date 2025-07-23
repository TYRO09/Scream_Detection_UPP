import 'package:flutter/material.dart';

class DriverDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            // Top Blue Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Color(0xFF002366), // Dark blue
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () {},
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 32,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'ASTRA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  // Main Grey Body
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        // Profile Circle with Check
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[400],
                              child: Icon(Icons.person, size: 60, color: Colors.white),
                            ),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Pill Buttons
                        _buildPillButton('Name'),
                        _buildPillButton('Vehicle Number'),
                        _buildPillButton('Phone'),
                        _buildPillButton('Last Checked'),
                        _buildPillButton('Route'),
                      ],
                    ),
                  ),

                  // Close Button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
