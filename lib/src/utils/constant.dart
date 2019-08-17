import 'package:intl/intl.dart';

// API END-POINT
const String apiUrl = 'http://3.16.51.94:60371';

// Fix-Headers
const Map<String, String> headers = {'content-type': 'application/json'};

// URLs
const String playStoreBaseURL = 'https://play.google.com/store/apps/details?id=';
const String appStoreURL = 'https://itunes.apple.com/app/id1457589389';

// Contact Details
const String contactEmailId = 'gncapps@googlegroups.com';

// Error
const String defaultError = 'Something wrong happend\nPlease contact to $contactEmailId';

// Date-Format
DateFormat couponDateFormat = new DateFormat.yMEd().add_jms();

// SharedPref keys
const String userDataKey = 'userData';
const String darkModeKey = 'isDarkMode';