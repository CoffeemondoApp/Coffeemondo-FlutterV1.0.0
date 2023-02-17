import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(appComplete());
}

class appComplete extends StatelessWidget {
  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(Duration(milliseconds: 750));
    List<String> _suggestions = [
      'Afeganistan',
      'Albania',
      'Algeria',
      'Australia',
      'Brazil',
      'German',
      'Madagascar',
      'Mozambique',
      'Portugal',
      'Zambia'
    ];
    List<String>? _filteredSuggestions = _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
    return _filteredSuggestions;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SafeArea(
            child: Scaffold(
                appBar: AppBar(title: Text('Example')),
                body: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: EasyAutocomplete(
                        debounceDuration: Duration(milliseconds: 1),
                        asyncSuggestions: (searchValue) async =>
                            _fetchSuggestions(searchValue),
                        onChanged: (value) => print(value))))));
  }
}
