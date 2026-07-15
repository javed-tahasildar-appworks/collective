import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget textField(
    {ValueChanged<String>? onChanged,
    Widget? prefix,
    Widget? suffix,
    List<TextInputFormatter> inputFormatters = const [],
    String? hint,
    TextStyle? hintStyle,
    int maxLines = 5,
    int minLines = 1,
    TextStyle? style,
    TextInputType inputType =
        const TextInputType.numberWithOptions(decimal: true),
    OutlineInputBorder? border,
    OutlineInputBorder? enabledBorder,
    OutlineInputBorder? focusedBorder,
    EdgeInsetsGeometry? padding}) {
  return TextFormField(
    onChanged: onChanged, // Pass the callback here
    textCapitalization: TextCapitalization.words,
    keyboardType: inputType,
    maxLines: maxLines,
    inputFormatters: inputFormatters.isEmpty
        ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
        : inputFormatters,
    style: style ??
        TextStyle(
          fontSize: 16.sp,
          height: 1.5, // ← This sets the line height
        ),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: padding,
      hintStyle: hintStyle,
      border: border ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
      enabledBorder: enabledBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
      focusedBorder: focusedBorder ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
    ),
  );
}

Widget showShimmer(double width, double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    period: const Duration(milliseconds: 1500), // Animation speed
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Match your image style
      ),
      width: width,
      height: height,
    ),
  );
}
