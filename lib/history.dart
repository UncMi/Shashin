import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Map<String, dynamic>>> loadSavedCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('coin_history') ?? [];
    return savedList.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  Future<void> deleteCoin(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList('coin_history') ?? [];

    // Get the item to delete
    final itemToDelete = jsonDecode(savedList[index]) as Map<String, dynamic>;

    // Remove the item at the given index
    savedList.removeAt(index);

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('coin_history', savedList);

    // Delete the associated image files
    final photo1Path = itemToDelete['photo1'];
    final photo2Path = itemToDelete['photo2'];
    if (await File(photo1Path).exists()) {
      await File(photo1Path).delete();
    }
    if (await File(photo2Path).exists()) {
      await File(photo2Path).delete();
    }

    // Refresh the state to reflect the changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 53, 52),
        title: const Text(
          "Shashin",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 76, 88, 87),
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
                  '${coinInfo['Denomination'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${coinInfo['Year'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(
                      File(photo2Path),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteCoin(index);
                      },
                    ),
                  ],
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
