import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final Function() onTap;
  final String locationText;

  static const textBoxBorderColor = Color(0xFFE8E8E8);
  static const textBoxBackgroundColor = Color(0xFFF6F6F6);
  static const textBoxTextColor = Color(0xFFBDBDBD);
  static const double borderRadius = 100.0;

  const SearchButton({
    super.key,
    required this.onTap,
    required this.locationText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: locationText,
        /*prefixIcon: Icon(*/
        /*iconData,*/
        /*color: Colors.grey[800],*/
        /*),*/
        fillColor: textBoxBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: textBoxTextColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: textBoxTextColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: textBoxTextColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        filled: true,
        hintStyle: const TextStyle(
          color: textBoxTextColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
