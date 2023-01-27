import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  Function() onTap;
  SearchButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: "Find the cheapest rides!",
        prefixIcon: Icon(
          Icons.search,
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
