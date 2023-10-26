import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample_project/model/item_model.dart';

import '../view_model/list_page_view_model.dart';

class ListPage extends ConsumerWidget{
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //state取得用
    final state = ref.watch(listPageViewModelProvider);
    //state更新用
    final viewModel = ref.watch(listPageViewModelProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: ListView.builder(
           itemCount: state.list.length,
           itemBuilder: (context, index) => ListPageListTile(state.list[index].name),
         )
      ),
      floatingActionButton: ElevatedButton(
          onPressed: (){
            final addItem = ItemModel();
            addItem.name = "${state.list.length + 1} add";
            //更新
            viewModel.updateList(addItem);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class ListPageListTile extends StatelessWidget{
  final String i;

  const ListPageListTile(this.i, {super.key});

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