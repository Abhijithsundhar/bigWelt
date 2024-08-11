 import 'package:flutter/widgets.dart';

double width = 0.0;
 double height = 0.0;

 var profile = AssetImage('assets/images/profile.png');

 String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length <= 3) return phoneNumber;
  return '${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3)}';
 }
