import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_model.dart';
part 'list_page_model.freezed.dart';

@freezed
class ListPageModel with _$ListPageModel{
  const ListPageModel._();
  const factory ListPageModel({
    @Default([]) List<ItemModel> list
}) = _ListPageModel;

  ListPageModel updateList(List<ItemModel> value) => copyWith(list: value);
}