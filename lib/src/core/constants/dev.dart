import 'package:flutter/foundation.dart';

const bool isDev = true;
const bool isAutoFillUpTextField = isDev && kDebugMode;

String firstName = isAutoFillUpTextField == true ? 'Salman' : '';
String lastName = isAutoFillUpTextField == true ? 'Ahmed' : '';
String email = isAutoFillUpTextField == true ? 'mbhsro@gmail.com' : '';
String username = isAutoFillUpTextField == true ? 'username' : '';
String password = isAutoFillUpTextField == true ? '87654321' : '';
String phone = isAutoFillUpTextField == true ? '01682834622' : '';
String dob = isAutoFillUpTextField == true ? '2004-11-03' : '';
String otp = isAutoFillUpTextField == true ? '111222' : '';

final products = <String>[
  'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
  'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
  'https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg',
  'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
  'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
  'https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg',
  'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
  'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
  'https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_.jpg',
  'https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_.jpg',
  'https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg',
  'https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg',
];
