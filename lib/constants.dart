// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'profile_fonts.dart';

const todoLineHeight = 63.0;
const appBarHeight = 63.0;
const appBarExpandedHeight = 212.0;
const appBarMinFontSize = 27.8;
const appBarMaxFontSize = 40.0;
const doneStyle = const TextStyle(
  color: TodoColors.done,
  decoration: TextDecoration.lineThrough,
);
const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);

const kShrineBrown900 = const Color(0xFF442B2D);

const kShrineErrorRed = const Color(0xFFC5032B);

const kShrineSurfaceWhite = const Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;

class TodoColors {
  static const Color primaryDark = const Color(0xFF863352);
  static const Color primary = const Color(0xFFB43F54);
  static const Color primaryLight = const Color(0xFFCA4855);
  static const Color background = const Color(0xFF1C1E27);
  static const Color done = const Color(0xFFBABCBE);
  static const Color accent = const Color(0xFF42B2CC);
  static const Color disabled = const Color(0xFFBABCBE);
  static const Color line = const Color(0xFF414044);

  static final textStyle = new TextStyle(
      color: accent,
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle2 = new TextStyle(
      color: background,
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle3 = new TextStyle(
      color: primary,
      fontWeight: FontWeight.w900,
      fontSize: 16.0,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle4 = new TextStyle(
      color: accent,
      fontWeight: FontWeight.w900,
      fontSize: 13.0,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle5 = new TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 20.0,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle6 = new TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 25.0,
      color: Colors.black,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle7 = new TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20.0,
      color: Colors.black,
      fontFamily: ProfileFontNames.TimeBurner);

  static final textStyle8 = new TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 10.0,
      color: Colors.black,
      fontFamily: ProfileFontNames.TimeBurner);
  Color c = Colors.amber;
  static const baseColors = <ColorSwatch>[
    //Profile
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    //Projects
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    //Pending Requests
    ColorSwatch(0xFF779A9A, {
      'highlight': Color(0xFF3366FF),
      'splash': Color(0xFF3366FF),
      'error': Color(0xFF3366FF),
    }),
    //Explore Users
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    //Explore Devices
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    //Weeks Availability
    ColorSwatch(0xFFFFC7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
  ];

  static const icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/availability.png',
    'assets/icons/power.png',
    'assets/icons/digital_storage.png',
  ];

  static const baseColors2 = <ColorSwatch>[
    //Profile
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    //Projects
    ColorSwatch(0xFFFFBF00,  {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    //Pending Requests
    ColorSwatch(0xFFFFC7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    //Started Projects
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    //Upcoming Projects
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    //Explore Users
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    //Explore Devices
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    //Closed Projects
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
    //Weeks Availability
    ColorSwatch(0xFF779A9A, {
      'highlight': Color(0xFF3366FF),
      'splash': Color(0xFF3366FF),
      'error': Color(0xFF3366FF),
    }),
  ];

  static const List<String> countries = [
    '                                Country',
  'Afghanistan',
  'Albania',
  'Algeria',
  'Andorra',
  'Angola',
  'Anguilla',
  'Antigua & Barbuda',
  'Argentina',
  'Armenia',
  'Australia',
  'Austria',
  'Azerbaijan',
  'Bahamas',
  'Bahrain',
  'Bangladesh',
  'Barbados',
  'Belarus',
  'Belgium',
  'Belize',
  'Benin',
  'Bermuda',
  'Bhutan',
  'Bolivia',
  'Bosnia & Herzegovina',
  'Botswana',
  'Brazil',
  'Brunei Darussalam',
  'Bulgaria',
  'Burkina Faso',
  'Myanmar/Burma',
  'Burundi',
  'Cambodia',
  'Cameroon',
  'Canada',
  'Cape Verde',
  'Cayman Islands',
  'Central African Republic',
  'Chad',
  'Chile',
  'China',
  'Colombia',
  'Comoros',
  'Congo',
  'Costa Rica',
  'Croatia',
  'Cuba',
  'Cyprus',
  'Czech Republic',
  'Democratic Republic of the Congo',
  'Denmark',
  'Djibouti',
  'Dominica',
  'Dominican Republic',
  'Ecuador',
  'Egypt',
  'El Salvador',
  'Equatorial Guinea',
  'Eritrea',
  'Estonia',
  'Ethiopia',
  'Fiji',
  'Finland',
  'France',
  'French Guiana',
  'Gabon',
  'Gambia',
  'Georgia',
  'Germany',
  'Ghana',
  'Great Britain',
  'Greece',
  'Grenada',
  'Guadeloupe',
  'Guatemala',
  'Guinea',
  'Guinea-Bissau',
  'Guyana',
  'Haiti',
  'Honduras',
  'Hungary',
  'Iceland',
  'India',
  'Indonesia',
  'Iran',
  'Iraq',
  'Israel and the Occupied Territories',
  'Italy',
  'Ivory Coast (Cote d\'Ivoire)',
  'Jamaica',
  'Japan',
  'Jordan',
  'Kazakhstan',
  'Kenya',
  'Kosovo',
  'Kuwait',
  'Kyrgyz Republic (Kyrgyzstan)',
  'Laos',
  'Latvia',
  'Lebanon',
  'Lesotho',
  'Liberia',
  'Libya',
  'Liechtenstein',
  'Lithuania',
  'Luxembourg',
  'Republic of Macedonia',
  'Madagascar',
  'Malawi',
  'Malaysia',
  'Maldives',
  'Mali',
  'Malta',
  'Martinique',
  'Mauritania',
  'Mauritius',
  'Mayotte',
  'Mexico',
  'Moldova, Republic of',
  'Monaco',
  'Mongolia',
  'Montenegro',
  'Montserrat',
  'Morocco',
  'Mozambique',
  'Namibia',
  'Nepal',
  'Netherlands',
  'New Zealand',
  'Nicaragua',
  'Niger',
  'Nigeria',
  'Korea, Democratic Republic of (North Korea)',
  'Norway',
  'Oman',
  'Pacific Islands',
  'Pakistan',
  'Panama',
  'Papua New Guinea',
  'Paraguay',
  'Peru',
  'Philippines',
  'Poland',
  'Portugal',
  'Puerto Rico',
  'Qatar',
  'Reunion',
  'Romania',
  'Russian Federation',
  'Rwanda',
  'Saint Kitts and Nevis',
  'Saint Lucia',
  'Saint Vincent\'s & Grenadines',
  'Samoa',
  'Sao Tome and Principe',
  'Saudi Arabia',
  'Senegal',
  'Serbia',
  'Seychelles',
  'Sierra Leone',
  'Singapore',
  'Slovak Republic (Slovakia)',
  'Slovenia',
  'Solomon Islands',
  'Somalia',
  'South Africa',
  'Korea, Republic of (South Korea)',
  'South Sudan',
  'Spain',
  'Sri Lanka',
  'Sudan',
  'Suriname',
  'Swaziland',
  'Sweden',
  'Switzerland',
  'Syria',
  'Tajikistan',
  'Tanzania',
  'Thailand',
  'Timor Leste',
  'Togo',
  'Trinidad & Tobago',
  'Tunisia',
  'Turkey',
  'Turkmenistan',
  'Turks & Caicos Islands',
  'Uganda',
  'Ukraine',
  'United Arab Emirates',
  'United States of America (USA)',
  'Uruguay',
  'Uzbekistan',
  'Venezuela',
  'Vietnam',
  'Virgin Islands (UK)',
  'Virgin Islands (US)',
  'Yemen',
  'Zambia',
  'Zimbabwe',
  ];
}

