import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintText: "From:",
                prefixIcon: Icon(
                  Icons.hail,
                  color: Colors.grey[800],
                ),
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(
                  color: Colors.grey[800],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
