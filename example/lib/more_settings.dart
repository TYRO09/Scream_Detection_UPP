import 'package:flutter/material.dart';

class MoreSettingsPage extends StatefulWidget {
  @override
  _MoreSettingsPageState createState() => _MoreSettingsPageState();
}

class _MoreSettingsPageState extends State<MoreSettingsPage> {
  bool sosEnabled = false;
  bool shakeToShareEnabled = false;
  bool screamDetectionEnabled = false;
  TextEditingController frequencyController = TextEditingController(text: "5");
  bool isHindi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  isHindi
                      ? 'assets/hindi.png'
                      : 'assets/eng.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Grey overlay for readability (optional)
          Container(
            color: Colors.grey.withOpacity(0.2),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  _buildSettingTile(
                    label: isHindi ? 'एसओएस बटन' : 'SOS button',
                    value: sosEnabled,
                    onChanged: (val) {
                      setState(() {
                        sosEnabled = val;
                      });
                    },
                  ),

                  _buildSettingTile(
                    label: isHindi ? 'साझा करने के लिए हिलाएं' : 'Shake to share',
                    value: shakeToShareEnabled,
                    onChanged: (val) {
                      setState(() {
                        shakeToShareEnabled = val;
                      });
                    },
                  ),

                  _buildSettingTile(
                    label: isHindi ? 'चीख पहचान' : 'Scream detection',
                    value: screamDetectionEnabled,
                    onChanged: (val) {
                      setState(() {
                        screamDetectionEnabled = val;
                      });
                    },
                  ),

                  _buildFrequencyTile(),

                  const Spacer(),

                  _buildLanguageButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyTile() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300]?.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isHindi ? 'भेजने की आवृत्ति' : 'Sending freq.',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              controller: frequencyController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isHindi ? Colors.grey[500]?.withOpacity(0.8) : Colors.grey[300]?.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              isHindi = true;
            });
          },
          child: Text(
            'हिंदी',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: !isHindi ? Colors.grey[500]?.withOpacity(0.8) : Colors.grey[300]?.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            setState(() {
              isHindi = false;
            });
          },
          child: Text(
            'English',
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
