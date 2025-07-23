import 'package:flutter/material.dart';

class SafeModePage extends StatelessWidget {
  final String userName;

  const SafeModePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: Row(
          children: [
            // Replace this CircleAvatar with your logo if available
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 14,
              child: Icon(Icons.shield, color: Colors.white, size: 20),
            ),
            SizedBox(width: 10),
            Text('ASTRA'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings click
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'GOOD MORNING ${userName.toUpperCase()}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement call police function
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(32),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  'CALL\nPOLICE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Implement "I'm safe" logic
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "IM SAFE",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            ElevatedButton(
              child: Text('Safe Mode'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafeModePage(userName: 'XXX'),
                    ),
                    );
                },
            )
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SafeModePage(userName: 'Arushi'), // Replace with actual name
                  ),
                );
              },
              child: Text(isHindi ? "सुरक्षित मोड" : "Safe Mode"),
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Implement QR/Scan logic
                  },
                  icon: Icon(Icons.qr_code, size: 32),
                  color: Colors.black,
                  iconSize: 48,
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  constraints: BoxConstraints(),
                ),
                IconButton(
                  onPressed: () {
                    // Implement second scan logic
                  },
                  icon: Icon(Icons.qr_code_scanner, size: 32),
                  color: Colors.black,
                  iconSize: 48,
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Text(
                "Safe Mode Activated",
                style: TextStyle(fontSize: 20, color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
