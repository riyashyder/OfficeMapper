//
// import 'dart:convert';
//
// import 'package:firebase_core/firebase_core.dart';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// import 'package:http/http.dart' as http;
//
//
//
// class OfficeLocation extends StatefulWidget {
//   final double officeLatitude;
//   final double officeLongitude;
//
//   const OfficeLocation({
//     Key? key,
//     required this.officeLatitude,
//     required this.officeLongitude,
//   }) : super(key: key);
//
//   @override
//   State<OfficeLocation> createState() => _OfficeLocationState();
// }
//
// class _OfficeLocationState extends State<OfficeLocation> {
//   // TextEditingController for date field
//   late TextEditingController _dateController;
//
//   // TextEditingController for time in field
//   late TextEditingController _timeInController;
//
//   // TextEditingController for time out field
//   late TextEditingController _timeOutController;
//   bool _isPresentEnabled = false;
//   double _currentLatitude = 0.0;
//   double _currentLongitude = 0.0;
//   int? _selectedPunchType;
//   late String _punchStatus; // Variable to track punch status
//   late TextEditingController _attendeeController;
//   late DateTime _selectedDate;
//   late TimeOfDay _selectedTimeIn;
//   late TimeOfDay _selectedTimeOut;
//   late TextEditingController _remarksController;
//   List<String> _attendees = []; // List of attendees
//   String _selectedAttendee = ''; // Selected attendee
//
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     //_fetchAttendees();
//     _getLocation();
//     _attendeeController = TextEditingController();
//     _remarksController = TextEditingController();
//     _dateController = TextEditingController(text: _selectedDate.toString());
//     _timeInController = TextEditingController(text: _selectedTimeIn.format(context).toString());
//     _timeOutController = TextEditingController(text: _selectedTimeOut.format(context).toString());
//     //_punchStatus = 'Punched out'; // Initialize punch status
//   }
//
//
//   _submitToFirebase() async {
//     try {
//       // Access Firebase Firestore instance
//       CollectionReference attendanceCollection =
//       FirebaseFirestore.instance.collection('client');
//
//       // Add document with input values
//       await attendanceCollection.add({
//         'attendee': _selectedAttendee.toString(),
//         'date': _selectedDate.toString(),
//         'timeIn': _selectedTimeIn.format(context).toString(),
//         'timeOut': _selectedTimeOut.format(context).toString(),
//         'remarks': _remarksController.text,
//         'punchType': _selectedPunchType == 0.toString() ? 'Punch In' : 'Punch Out',
//       });
//
//       // Clear input fields after submission
//       _attendeeController.clear();
//       _remarksController.clear();
//       setState(() {
//         _selectedPunchType = null;
//       });
//
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Attendance marked successfully')),
//       );
//     } catch (e) {
//       // Handle errors
//       print('Error submitting to Firebase: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to mark attendance. Please try again.')),
//       );
//     }
//   }
//
//
//
//
//
//
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_attendees.isNotEmpty) {
//       _selectedAttendee = _attendees[0]; // Set the default selected attendee
//     }
//   }
//
//
//   @override
//   void dispose() {
//     _attendeeController.dispose();
//     _remarksController.dispose();
//     _dateController.dispose();
//     _timeInController.dispose();
//     _timeOutController.dispose();
//     super.dispose();
//   }
//
//   void _getLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//       setState(() {
//         _currentLatitude = position.latitude;
//         _currentLongitude = position.longitude;
//         if (_checkInOfficeLocation(
//             _currentLatitude, _currentLongitude, widget.officeLatitude, widget.officeLongitude)) {
//           _isPresentEnabled = true;
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   bool _checkInOfficeLocation(
//       double currentLatitude, double currentLongitude, double officeLatitude, double officeLongitude) {
//     const double tolerance = 0.0001;
//     return (currentLatitude - officeLatitude).abs() < tolerance &&
//         (currentLongitude - officeLongitude).abs() < tolerance;
//   }
//
//   // Future<void> _fetchAttendees() async {
//   //   try {
//   //     final response = await http.get(Uri.parse('http://192.168.1.23/postgretest/getdata.php'));
//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> data = jsonDecode(response.body);
//   //       final Set<String> attendeesSet = data.map((item) => item['attendee'].toString()).toSet();
//   //       setState(() {
//   //         _attendees = attendeesSet.toList();
//   //         print('attendees');
//   //         print(_attendees);
//   //       });
//   //     } else {
//   //       throw Exception('Failed to fetch attendees');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching attendees: $e');
//   //   }
//   // }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Example'),
//       ),
//       body: _getBody(_selectedIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.location_on),
//             label: 'Punch',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//
//   Widget _getBody(int index) {
//     switch (index) {
//       case 0:
//         return _buildHome();
//       case 1:
//         return _buildPunch();
//       default:
//         return Container();
//     }
//   }
//
//   Widget _buildHome() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           // Textformfield for entering attendee
//           TextFormField(
//             controller: _attendeeController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(),
//               ),
//               labelText: 'Attendee',
//               suffixIcon: Icon(Icons.person),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 _selectedAttendee = value;
//               });
//             },
//           ),
//           SizedBox(height: 20),
//           // TextFormField for selecting date
//           TextFormField(
//             readOnly: true,
//             controller: _dateController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(),
//               ),
//               labelText: 'Select Date',
//               suffixIcon: Icon(Icons.calendar_today), // Optional: add an icon
//             ),
//           ),
//           SizedBox(height: 20),
//           // TextField for entering remarks
//           TextField(
//             controller: _remarksController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(),
//               ),
//               labelText: 'Remarks',
//               suffixIcon: Icon(Icons.add_chart_outlined),
//             ),
//           ),
//           SizedBox(height: 20),
//           // Elevated button for Punch In
//           ElevatedButton(
//             onPressed: _isPresentEnabled ? () {
//               // Handle punch in logic here
//             } : null,
//             child: Text('Punch In'),
//           ),
//           SizedBox(height: 20),
//           // Elevated button for Punch Out
//           ElevatedButton(
//             onPressed: _isPresentEnabled ? () {
//               // Handle punch out logic here
//             } : null,
//             child: Text('Punch Out'),
//           ),
//           SizedBox(height: 20),
//           // Elevated button for marking attendance
//           ElevatedButton(
//             onPressed: _isPresentEnabled ? _submitToFirebase : null,
//             child: Text('Marked'),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//
//
//
//   Widget _buildPunch() {
//     return Column();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }













import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';



class OfficeLocation extends StatefulWidget {
  final double officeLatitude;
  final double officeLongitude;
  final String username;

  const OfficeLocation({
    Key? key,
    required this.officeLatitude,
    required this.officeLongitude,
    required this.username,
  }) : super(key: key);

  @override
  State<OfficeLocation> createState() => _OfficeLocationState();
}

class _OfficeLocationState extends State<OfficeLocation> {

  // static const double predefinedLatitude = 13.009250;
  // static const double predefinedLongitude = 80.213315;
  static const double predefinedLatitude = 13.027918;
  static const double predefinedLongitude = 80.108170;
  static const double radiusInMeters = 2; // Define your radius here (in meters)
  bool isWithinRadius = false;

  late Timer _timer;
  late DateTime _currentTime;
  TextEditingController _attendeeController = TextEditingController();
  late String _selectedAttendee;
  bool _isPresentEnabled = false;
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  late String _punchStatus; // Variable to track punch status
  //late TextEditingController _attendeeController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTimeIn;
  late TimeOfDay _selectedTimeOut;
  late TextEditingController _remarksController;
  List<String> _attendees = []; // List of attendees
  //String _selectedAttendee = 'riyas'; // Selected attendee

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttendees();
    _currentTime = DateTime.now();
    _getLocation();
    _loadUsernameFromSharedPreferences();
    _attendeeController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTimeIn = TimeOfDay.now();
    _selectedTimeOut = TimeOfDay.now();
    _remarksController = TextEditingController();
    _punchStatus = 'Punched out';
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });// Initialize punch status

  }




  void _loadUsernameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _selectedAttendee = username ?? ''; // Default value if username is null
      _attendeeController.text = _selectedAttendee; // Set the default value in the text field
    });
  }

  Future<void> _refreshData() async {
    // Implement your refresh logic here
    // For example, you can refetch data from the server
    // For now, we'll just wait for 1 second to simulate refreshing
    await Future.delayed(Duration(seconds: 1));
    // Once data is refreshed, call setState to rebuild the UI
    setState(() {});
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_attendees.isNotEmpty) {
      _selectedAttendee = _attendees[0]; // Set the default selected attendee
    }
  }


  @override
  void dispose() {
    _attendeeController.dispose();
    _remarksController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        if (_checkInOfficeLocation(
            _currentLatitude, _currentLongitude, widget.officeLatitude, widget.officeLongitude)) {
          _isPresentEnabled = true;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  bool _checkInOfficeLocation(
      double currentLatitude, double currentLongitude, double officeLatitude, double officeLongitude) {
    const double tolerance = 0.0001;
    return (currentLatitude - officeLatitude).abs() < tolerance &&
        (currentLongitude - officeLongitude).abs() < tolerance;
  }

  Future<void> _fetchAttendees() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.23/postgretest/getdata.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Set<String> attendeesSet = data.map((item) => item['attendee'].toString()).toSet();
        setState(() {
          _attendees = attendeesSet.toList();
          print('attendees');
          print(_attendees);
        });
      } else {
        throw Exception('Failed to fetch attendees');
      }
    } catch (e) {
      print('Error fetching attendees: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
      if (details.delta.dy > 0) {
        _refreshData(); // Refresh when pulled down
      }
    },
    child:Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),

            onPressed: () {
              // Clear username from shared preferences
              SharedPreferences.getInstance().then((prefs) => prefs.remove('username'));

              // Navigate to the sign-in page when logout button is clicked
              Get.off(SignUpScreen());
            },
          ),
        ],
        title: FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Welcome'); // Display default welcome message while retrieving username
            }
            if (snapshot.hasData) {
              String username = snapshot.data!;
              return Text('Welcome $username'); // Display the retrieved username
            } else if (snapshot.hasError) {
              return Text('Welcome'); // Display default welcome message in case of error
            } else {
              return Text('Welcome'); // Display default welcome message if no username found
            }
          },
        ),
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Punch',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    ));
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? ''; // Retrieve username from shared preferences
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return _buildHome();
      case 1:
        return _buildPunch();
      default:
        return Container();
    }
  }


  // Widget _buildHome() {
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       // Implement your refresh logic here
  //       // For now, we'll just wait for 1 second to simulate refreshing
  //       await Future.delayed(Duration(seconds: 1));
  //       // Once data is refreshed, call setState to rebuild the UI
  //       setState(() {
  //         _selectedTimeIn = DateTime.now() as TimeOfDay;
  //       });
  //     },
  //     child: SingleChildScrollView(
  //       padding: EdgeInsets.all(20.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           // Dropdown for selecting attendee
  //           TextFormField(
  //             controller: _attendeeController,
  //             onChanged: (value) {
  //               setState(() {
  //                 _selectedAttendee = value;
  //               });
  //             },
  //             decoration: InputDecoration(labelText: 'Attendee'),
  //           ),
  //           SizedBox(height: 20),
  //           Text('Date: ${_selectedDate.toString()}'),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final DateTime? pickedDate = await showDatePicker(
  //                 context: context,
  //                 initialDate: _selectedDate,
  //                 firstDate: DateTime(2000),
  //                 lastDate: DateTime(2100),
  //               );
  //               if (pickedDate != null && pickedDate != _selectedDate)
  //                 setState(() {
  //                   _selectedDate = pickedDate;
  //                 });
  //             },
  //             child: Text('Select Date'),
  //           ),
  //           SizedBox(height: 20),
  //           Text('Time In: ${_selectedTimeIn.format(context)}'),
  //           ElevatedButton(
  //             onPressed: () async {
  //               // Your code for Punch In button
  //             },
  //             child: Text('Punch In'),
  //           ),
  //
  //           SizedBox(height: 20),
  //           Text('Time Out: ${_selectedTimeOut.format(context)}'),
  //           ElevatedButton(
  //             onPressed: () async {
  //               // Your code for Punch Out button
  //             },
  //             child: Text('Punch Out'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  Widget _buildHome() {
    return RefreshIndicator(onRefresh: () async {
      setState(() {
        _selectedDate = DateTime.now();
      });
    },
    child : SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Dropdown for selecting attendee
          TextFormField(
            controller: _attendeeController,
            onChanged: (value) {
              setState(() {
                _selectedAttendee = value;
              });
            },
            decoration: InputDecoration(labelText: 'Attendee'),
          ),
          SizedBox(height: 20),
          Text('Date: ${_selectedDate.toString()}'),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null && pickedDate != _selectedDate)
                setState(() {
                  _selectedDate = pickedDate;
                });
            },
            child: Text('Select Date'),
          ),
          SizedBox(height: 20),
          DigitalClock(
            datetime: DateTime.now(),
            digitalClockColor: Colors.deepOrangeAccent,
            //timeFormatter: TimeFormatter.twelveHour,

          ),
          ElevatedButton(
            onPressed: () async {
              // Get the current location
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );

              // Calculate the distance between the current location and the predefined location
              double distanceInMeters = await Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                predefinedLatitude,
                predefinedLongitude,
              );

              // Check if the distance is within the radius
              setState(() {
                isWithinRadius = distanceInMeters <= radiusInMeters;
              });

              if (isWithinRadius) {

                DateTime now = DateTime.now();
                String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                try {
                  // Make a request to the login API to authenticate the user and obtain user_id and emp_id
                  final loginResponse = await http.get(Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=${GlobalVariables.username}&password=${GlobalVariables.password}'));

                  if (loginResponse.statusCode == 200) {
                    final Map loginData = json.decode(loginResponse.body);
                    final Map result = loginData['response']['result'];
                    final String userId = result['user_id'];
                    final String empId = result['emp_id'];

                    // Make an HTTP POST request to insert the current time into the database
                    var response = await http.post(
                      Uri.parse('https://mis.webilesk.com/mobile_api/mark_attn.php?user_id=$userId&emp_id=$empId&in_time=$formattedDateTime'),
                      body: {
                        'time': formattedDateTime,
                      },
                    );
                    print(response.body);

                    if (response.statusCode == 200) {
                      // Show a Snackbar if the time is inserted successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Time inserted successfully'),
                        ),
                      );
                    } else {
                      print('Failed to insert time: ${response.body}');
                    }
                  } else {
                    print('Failed to authenticate user: ${loginResponse.body}');
                  }
                } catch (e) {
                  print('Error: $e');
                }
              } else {
                // If the user is not within the radius, show a message or take appropriate action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are not within the designated area to punch in.'),
                  ),
                );
              }
            },
            child: Text('Punch In'),
          ),






          // ElevatedButton(
          //   onPressed: () async {
          //     // Get the current location
          //     Position position = await Geolocator.getCurrentPosition(
          //       desiredAccuracy: LocationAccuracy.high,
          //     );
          //
          //     // Calculate the distance between the current location and the predefined location
          //     double distanceInMeters = await Geolocator.distanceBetween(
          //       position.latitude,
          //       position.longitude,
          //       predefinedLatitude,
          //       predefinedLongitude,
          //     );
          //
          //     // Check if the distance is within the radius
          //     if (distanceInMeters <= radiusInMeters) {
          //       // Within the radius, proceed with your logic
          //       // Get the current date and time
          //       DateTime now = DateTime.now();
          //       String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          //
          //       try {
          //         // Make a request to the login API to authenticate the user and obtain user_id and emp_id
          //         final loginResponse = await http.get(Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=${GlobalVariables.username}&password=${GlobalVariables.password}'));
          //
          //         if (loginResponse.statusCode == 200) {
          //           final Map loginData = json.decode(loginResponse.body);
          //           final Map result = loginData['response']['result'];
          //           final String userId = result['user_id'];
          //           final String empId = result['emp_id'];
          //
          //           // Make an HTTP POST request to insert the current time into the database
          //           var response = await http.post(
          //             Uri.parse('https://mis.webilesk.com/mobile_api/mark_attn.php?user_id=$userId&emp_id=$empId&in_time=$formattedDateTime'),
          //             body: {
          //               'time': formattedDateTime,
          //             },
          //           );
          //           print(response.body);
          //
          //           if (response.statusCode == 200) {
          //             // Show a Snackbar if the time is inserted successfully
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(
          //                 content: Text('Time inserted successfully'),
          //               ),
          //             );
          //           } else {
          //             print('Failed to insert time: ${response.body}');
          //           }
          //         } else {
          //           print('Failed to authenticate user: ${loginResponse.body}');
          //         }
          //       } catch (e) {
          //         print('Error: $e');
          //       }
          //     } else {
          //       // Outside the radius, display a message or take appropriate action
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('You are not within the designated area to punch in.'),
          //         ),
          //       );
          //     }
          //   },
          //   child: Text('Punch In'),
          // ),





          // ElevatedButton(
          //   onPressed: () async {
          //     // Get the current date and time
          //     DateTime now = DateTime.now();
          //     String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          //
          //     try {
          //       // Make a request to the login API to authenticate the user and obtain user_id and emp_id
          //       final loginResponse = await http.get(Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=${GlobalVariables.username}&password=${GlobalVariables.password}'));
          //
          //       if (loginResponse.statusCode == 200) {
          //         final Map loginData = json.decode(loginResponse.body);
          //         final Map result = loginData['response']['result'];
          //         final String userId = result['user_id'];
          //         final String empId = result['emp_id'];
          //
          //         // Make an HTTP POST request to insert the current time into the database
          //         var response = await http.post(
          //           Uri.parse('https://mis.webilesk.com/mobile_api/mark_attn.php?user_id=$userId&emp_id=$empId&in_time=$formattedDateTime'),
          //           body: {
          //             'time': formattedDateTime,
          //           },
          //         );
          //         print(response.body);
          //
          //         if (response.statusCode == 200) {
          //           // Show a Snackbar if the time is inserted successfully
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             SnackBar(
          //               content: Text('Time inserted successfully'),
          //             ),
          //           );
          //         } else {
          //           print('Failed to insert time: ${response.body}');
          //         }
          //       } else {
          //         print('Failed to authenticate user: ${loginResponse.body}');
          //       }
          //     } catch (e) {
          //       print('Error: $e');
          //     }
          //   },
          //   child: Text('Punch In'),
          // ),


          SizedBox(height: 20),
          DigitalClock(
            datetime: DateTime.now(),
            digitalClockColor: Colors.deepOrangeAccent,
            //timeFormatter: TimeFormatter.twelveHour,

          ),
          ElevatedButton(
            onPressed: () async {
              // Get the current date and time
              DateTime now = DateTime.now();
              String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

              try {
                // Make a request to the login API to authenticate the user and obtain user_id and emp_id
                final loginResponse = await http.get(Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=${GlobalVariables.username}&password=${GlobalVariables.password}'));

                if (loginResponse.statusCode == 200) {
                  final Map<String, dynamic> loginData = json.decode(loginResponse.body);
                  final Map<String, dynamic> result = loginData['response']['result'];
                  final String userId = result['user_id'];
                  final String empId = result['emp_id'];

                  // Make an HTTP POST request to insert the current time into the database
                  var response = await http.post(
                    Uri.parse('https://mis.webilesk.com/mobile_api/mark_attn.php?user_id=$userId&emp_id=$empId&out_time=$formattedDateTime'),
                    body: {
                      'time': formattedDateTime,
                    },
                  );
                  print(response.body);

                  if (response.statusCode == 200) {
                    // Show a Snackbar if the time is inserted successfully
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Time inserted successfully'),
                      ),
                    );
                  } else {
                    print('Failed to insert time: ${response.body}');
                  }
                } else {
                  print('Failed to authenticate user: ${loginResponse.body}');
                }
              } catch (e) {
                print('Error: $e');
              }
            },
            child: Text('Punch Out'),
          ),

        ],
      ),
    ));
  }


  Widget _buildPunch() {
    return Column();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
















