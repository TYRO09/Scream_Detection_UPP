import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shake_detector/shake_detector.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  Stream<Map<dynamic, dynamic>>? result;
  List<Contact> emergencySMSNumbers = [];
  Contact? emergencyCallNumber;  // Single contact for emergency call
  int screamCount = 0;
  int smsSentCount = 0;
  int phoneCallCount = 0;
  int shakedetection = 0;
  bool isShakeDetectionStarted = false;
  final String model = 'assets/final_model.tflite';
  final String label = 'assets/final_labels.txt';
  final int sampleRate = 44100;
  final int bufferSize = 11016;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    TfliteAudio.loadModel(
      inputType: 'rawAudio',
      model: model,
      label: label,
    );
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.sms,
      Permission.contacts,
      Permission.location,
      Permission.phone
    ];

    for (var permission in permissions) {
      final status = await permission.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${permission.toString().split('.').last} permission is required!')),
        );
      }
    }
  }

  Future<String> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    Position position = await Geolocator.getCurrentPosition();
    return 'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
  }

  void _sendEmergencySMS() async {
    if (emergencySMSNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No emergency SMS contacts set!')),
      );
      return;
    }

    try {
      String locationUrl = await _getCurrentLocation();
      String message = 'EMERGENCY: Potential distress detected!\nLocation: $locationUrl';

      String result = await sendSMS(
        message: message,
        recipients: emergencySMSNumbers
            .map((contact) => contact.phones?.first.value)
            .where((phone) => phone != null) // Only include non-null phone numbers
            .cast<String>() // Cast List<String?> to List<String>
            .toList(),
        sendDirect: true,
      );

      setState(() {
        smsSentCount++;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emergency SMS sent!')),
      );
    } catch (error) {
      print('Failed to send SMS: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SMS. Please try again later.')),
      );
    }
  }

  void _makeEmergencyCalls() async {
    if (emergencyCallNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No emergency call contact set!')),
      );
      return;
    }

    try {
      await FlutterPhoneDirectCaller.callNumber(emergencyCallNumber!.phones!.first.value ?? '');
      setState(() {
        phoneCallCount++;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emergency call initiated!')),
      );
    } catch (error) {
      print('Failed to make emergency call: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to make emergency call.')),
      );
    }
  }
  void shakeRecognition() {
    // Start shake detection when audio recognition starts
    ShakeDetectWrap(
      onShake: () {
        setState(() {
          shakedetection++;
          if (shakedetection >= 4) {
            _sendEmergencySMS();
            _makeEmergencyCalls();
            shakedetection = 0; // Reset after 4 shakes
          }
        });
      },
      child: Container(), // You need to provide a child widget, even if it's just an empty container
    );
  }

  void startAudioRecognition() {
    result = TfliteAudio.startAudioRecognition(
      sampleRate: sampleRate,
      bufferSize: bufferSize,
      numOfInferences: 100000,
    );

    // Start shake detection when audio recognition starts
    if (!isShakeDetectionStarted) {
      shakeRecognition();
      isShakeDetectionStarted = true;
    }

    result?.listen((event) {
      String recognitionResult = event["recognitionResult"].toString();
      print("Recognition Result: $recognitionResult");

      if (recognitionResult.toLowerCase().contains('scream')) {
        screamCount++;
        if (screamCount >= 4) {
          _sendEmergencySMS();
          _makeEmergencyCalls();
          screamCount = 0;
        }
      } else {
        screamCount = 0;
      }
    }).onDone(() => isRecording.value = false);
  }

  void stopAudioRecognition() {
    TfliteAudio.stopAudioRecognition();
    isRecording.value = false;
    isShakeDetectionStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Emergency Detection'),
        actions: [
          IconButton(
            icon: Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactSelectionPage(
                    selectedContacts: emergencySMSNumbers,
                    title: 'Select Emergency SMS Contacts',
                    onContactsSelected: (selectedContacts) {
                      setState(() {
                        emergencySMSNumbers = selectedContacts;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.contact_phone),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactSelectionPage(
                    selectedContacts: emergencyCallNumber != null ? [emergencyCallNumber!] : [],
                    title: 'Select Emergency Call Contact',
                    onContactsSelected: (selectedContacts) {
                      setState(() {
                        emergencyCallNumber = selectedContacts.isNotEmpty ? selectedContacts.first : null;
                      });
                    },
                    isSingleSelection: true, // Enabling single selection for emergency calls
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Emergency Scream Detection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Shake Count: $shakedetection',  // Show shake detection count
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency SMS Sent: $smsSentCount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: smsSentCount > 0 ? Colors.red : Colors.black,
              ),
            ),
            Text(
              'Emergency Calls Made: $phoneCallCount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: phoneCallCount > 0 ? Colors.red : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Emergency SMS Numbers:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (emergencySMSNumbers.isNotEmpty)
              ...emergencySMSNumbers
                  .map((contact) => Text(contact.displayName ?? 'Unnamed Contact'))
                  .toList(),
            SizedBox(height: 20),
            Text(
              'Emergency Call Number:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (emergencyCallNumber != null)
              Text(emergencyCallNumber!.displayName ?? 'Unnamed Contact'),
            SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: isRecording,
              builder: (context, recording, child) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      recording ? Colors.red : Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    if (recording) {
                      // Stop recording
                      stopAudioRecognition();
                    } else {
                      // Start recording
                      startAudioRecognition();
                      isRecording.value = true;
                    }
                  },
                  child: Text(recording ? 'Stop Recording' : 'Start Audio Detection'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class ContactSelectionPage extends StatefulWidget {
  final List<Contact> selectedContacts;
  final ValueChanged<List<Contact>> onContactsSelected;
  final String title;
  final bool isSingleSelection;

  const ContactSelectionPage({
    Key? key,
    required this.selectedContacts,
    required this.onContactsSelected,
    required this.title,
    this.isSingleSelection = false,
  }) : super(key: key);

  @override
  _ContactSelectionPageState createState() => _ContactSelectionPageState();
}

class _ContactSelectionPageState extends State<ContactSelectionPage> {
  List<Contact> _contacts = [];
  List<Contact> _selectedContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _selectedContacts = widget.selectedContacts;
  }

  Future<void> _fetchContacts() async {
    final contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts.toList();
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _contacts = _contacts
          .where((contact) =>
      (contact.displayName ?? '').toLowerCase().contains(query.toLowerCase()) ||
          (contact.phones?.any((phone) =>
          phone.value?.toLowerCase().contains(query.toLowerCase()) ?? false) ??
              false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            child: Text('Save', style: TextStyle(color: Colors.black87)),
            onPressed: () {
              widget.onContactsSelected(_selectedContacts);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterContacts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                final phone = contact.phones?.isNotEmpty == true
                    ? contact.phones!.first.value ?? ''
                    : '';
                final name = contact.displayName ?? 'Unnamed Contact';

                return CheckboxListTile(
                  title: Text(name),
                  subtitle: Text(phone),
                  value: _selectedContacts.contains(contact),
                  onChanged: widget.isSingleSelection
                      ? (value) {
                    setState(() {
                      _selectedContacts.clear();
                      if (value == true) {
                        _selectedContacts.add(contact);
                      }
                    });
                  }
                      : (value) {
                    setState(() {
                      if (value == true) {
                        _selectedContacts.add(contact);
                      } else {
                        _selectedContacts.remove(contact);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


