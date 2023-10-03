import 'package:flutter/material.dart';

class ListPage extends StatelessWidget{
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(100, (i) => "Item $i");

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: ListView.builder(
           itemCount: items.length,
           itemBuilder: (context, index) => ListTile(
             leading: const Icon(Icons.map),
             title: Text("Map $index")
           )
         )
      )
    );
  }
}
