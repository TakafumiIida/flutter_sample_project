import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/item_model.dart';
import '../model/list_page_model.dart';

final listPageViewModelProvider = StateNotifierProvider<ListPageViewModel, ListPageModel>((ref) => ListPageViewModel());

class ListPageViewModel extends StateNotifier<ListPageModel>{
  ListPageViewModel(): super(const ListPageModel());

  void updateList(ItemModel value) {
    final listToUpdate = List.of(state.list);

    bool isExists = false;
    for (int i = 0; i < listToUpdate.length; i++) {
      if (listToUpdate[i].name == value.name) {
        isExists = true;
      }
    }

    if (!isExists) {
      listToUpdate.add(value);
      state = state.updateList(listToUpdate);
    }
  }
}