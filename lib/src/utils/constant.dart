import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// API END-POINT
// const String apiUrl = 'http://3.16.51.94:60371'; // Node URL
const String apiUrl = 'http://3.16.51.94:3000'; // Python URL

// Fix-Headers
const Map<String, String> headers = {'content-type': 'application/json'};

// URLs
const String playStoreBaseURL =
    'https://play.google.com/store/apps/details?id=';
const String appStoreURL = 'https://itunes.apple.com/app/id1457589389';

// Contact Details
const String contactEmailId = 'gncapps@googlegroups.com';

// Error
const String defaultError =
    'Something wrong happend\nPlease contact to $contactEmailId';

// Date-Format
DateFormat couponDateFormat = DateFormat.yMEd().add_jms();
DateFormat dateFormat = DateFormat('dd MMM yyyy');

// Time-Format
TimeOfDayFormat slotDropDownFormate = TimeOfDayFormat.h_colon_mm_space_a;

// Coupon Selection Date
DateTime fromDate = DateTime(2019, 11, 7);
DateTime endDate = DateTime(2019, 11, 12);

// Coupon Slots
final List<TimeOfDay> slots = <TimeOfDay>[
  TimeOfDay(hour: 18, minute: 30),
  TimeOfDay(hour: 20, minute: 00),
  TimeOfDay(hour: 21, minute: 30),
];

// SharedPref keys
const String userDataKey = 'userData';
const String darkModeKey = 'isDarkMode';

// Custom Spashscreen ON/OFF
const bool isCustomSpashScreen = true;