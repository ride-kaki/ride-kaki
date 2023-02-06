import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final Function() onTap;
  final String locationText;
  final IconData iconData;

  const SearchButton({
    super.key,
    required this.onTap,
    required this.locationText,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: locationText,
        prefixIcon: Icon(
          iconData,
          color: Colors.grey[800],
        ),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey[800],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 7,
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }
}
