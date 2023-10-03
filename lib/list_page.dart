import 'package:flutter/material.dart';

class ListPage extends StatelessWidget{
  const ListPage({super.key});
  //final listItems = List<ListTile>.generate(100, (i) => { ListTile(leading: Icon(Icons.map), title: Text("Map $i")) })


  @override
  Widget build(BuildContext context) {
    //List<ListTile> listItems = List.empty();
    //var listItems = new List();
    final items = List<String>.generate(100, (i) => "Item $i");
    //   for(var i=0;i<10;i++){
    //     listItems.add(ListTile(leading: Icon(Icons.map), title: Text("Map $i")));
    //   }
    //listItems.add(new ListTile(leading: Icon(Icons.map), title: Text("Map")));

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("List Page"),
      // ),
      body: Container(
        width: double.infinity,
         // child: ListView(
         //   children: <ListTile>[
         //     ListTile(
         //       leading: Icon(Icons.map),
         //       title: Text("map"),
         //     ),
         //   ],
         // ),

         //ListView.builderのやり方
         child: ListView.builder(
           itemCount: items.length,
           itemBuilder: (context, index){
             return ListTile(
               leading: const Icon(Icons.map),
               title: Text("Map $index")
             );
           },
        //)
         )
      )
    );
  }

}