import 'package:flutter/material.dart';

class QrScanPage extends StatefulWidget {
  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  bool isTorchOn = false;
  String scanMode = 'scan'; // or 'photo'

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
              color: Color(0xFF002366),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Grey Camera Preview Box
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 60,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Torch Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.flashlight_on,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isTorchOn = !isTorchOn;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    // Call Police Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red[700]!,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Add your "call police" logic
                        },
                        child: Text(
                          'CALL POLICE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Bottom Toggle Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildModeButton('scan', Icons.qr_code_scanner),
                        _buildModeButton('photo', Icons.camera_alt),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String mode, IconData icon) {
    bool isSelected = scanMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            scanMode = mode;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[400] : Colors.grey[300],
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
