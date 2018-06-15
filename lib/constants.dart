// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

  static const baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A8, {
      'highlight': Color(0xFF8899A8),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
    ColorSwatch(0xFF779A9A, {
      'highlight': Color(0xFF3366FF),
      'splash': Color(0xFF3366FF),
      'error': Color(0xFF3366FF),
    }),
  ];
}

