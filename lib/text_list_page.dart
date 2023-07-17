import 'package:flutter/material.dart';
import 'package:limited_name/text_area.dart';

class TextListPage extends StatelessWidget {
  final String title;

  const TextListPage({super.key, required this.title});
    
  final _itemList = const [
    242343,
    11111111111111111,
    111111111111111111,
    1111111111111111111,
    5,
    7777777777777777777,
    8888888888888888888,
    57454,
    9223372036854775807,
    242343,
    11111111111111111,
    111111111111111111,
    1111111111111111111,
    5,
    7777777777777777777,
    8888888888888888888,
    57454,
    9223372036854775807,
    242343,
    11111111111111111,
    111111111111111111,
    1111111111111111111,
    5,
    7777777777777777777,
    8888888888888888888,
    57454,
    9223372036854775807,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: Center(
        child: ListView.separated(
          itemCount: _itemList.length,
          padding: const EdgeInsets.symmetric(horizontal: 170.0),
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) => TextArea(
            _itemList[index],
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      )
    );
  }
}
