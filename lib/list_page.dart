import 'package:flutter/material.dart';

class ListPage extends StatelessWidget{
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(50, (i) => "Item $i");

    //直書きタップ用メソッド
    // void onTap(){
    //   debugPrint("1");
    // }

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: ListView.builder(
           itemCount: items.length,
           // 処理を分ける
           itemBuilder: (_, i) => ListPageListTile(i),
           // 直書き
           // itemBuilder: (context, index) => ListTile(
           //   leading: const Icon(Icons.map),
           //   title: Text("Map $index"),
           //   selectedColor: Colors.blue,
           //   onTap: onTap,
           // )
         )
      )
    );
  }
}

class ListPageListTile extends StatelessWidget{
  final int i;

  const ListPageListTile(this.i);

  void onTap(){
    debugPrint("onTap $i");
  }

  void onLongPress(){
    debugPrint("onLongPress $i $key");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.map),
      title: Text("Map $i"),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}