import 'package:flutter/material.dart';

extension CustomStyle on TextTheme {
  TextStyle get myTitle => const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      );

  TextStyle get myRiskBodyMain =>
      const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500, fontSize: 14);
  TextStyle get myRiskBodyMain2 =>
      const TextStyle(fontWeight: FontWeight.w400, fontSize: 12);
  TextStyle get myRiskBodySub =>
      const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 11);
  TextStyle get myFormBodyMain =>
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 14);
  TextStyle get myFormBodySub =>
      const TextStyle(fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 11);
}
