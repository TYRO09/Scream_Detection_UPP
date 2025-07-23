import 'package:flutter/material.dart';

class RideHistoryPage extends StatelessWidget {
  final bool isHindi;

  RideHistoryPage({this.isHindi = false});

  final List<Map<String, String>> dummyRides = List.generate(10, (index) {
    return {
      'name': 'RAJU',
      'phone': '+91 0000000000',
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2653),
        leading: const Icon(Icons.person),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 32), // Replace with actual logo if needed
            const SizedBox(width: 8),
            const Text('ASTRA', style: TextStyle(letterSpacing: 2)),
          ],
        ),
        centerTitle: true,
        actions: const [Icon(Icons.settings)],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            isHindi ? 'पिछली 10 सवारी' : 'Last 10 rides',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: dummyRides.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dummyRides[index]['name']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dummyRides[index]['phone']!,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
