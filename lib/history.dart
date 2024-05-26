import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<List<Map<String, dynamic>>> loadSavedCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('coin_history') ?? [];
    return savedList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 53, 52),
        title: const Text(
          "Shashin",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 76, 88, 87),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadSavedCoins(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final savedCoins = snapshot.data!;

          return ListView.builder(
            itemCount: savedCoins.length,
            itemBuilder: (context, index) {
              final coin = savedCoins[index];
              final coinInfo = coin['coin_info'];
              final photo1Path = coin['photo1'];
              final photo2Path = coin['photo2'];

              return ListTile(
                leading: Image.file(
                  File(photo1Path),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'Number: ${coinInfo['Number'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Period: ${coinInfo['Period'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Image.file(
                  File(photo2Path),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HistoryScreen(),
  ));
}
