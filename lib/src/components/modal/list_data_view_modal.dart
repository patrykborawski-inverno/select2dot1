import 'package:flutter/material.dart';
import 'package:select2dot1/src/components/modal/category_item_modal.dart';
import 'package:select2dot1/src/components/modal/category_name_modal.dart';
import 'package:select2dot1/src/controllers/search_controller.dart';
import 'package:select2dot1/src/controllers/select_data_controller.dart';
import 'package:select2dot1/src/models/single_category_model.dart';
import 'package:select2dot1/src/models/single_item_category_model.dart';
import 'package:select2dot1/src/settings/global_settings.dart';
import 'package:select2dot1/src/settings/modal/category_item_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/category_name_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/list_data_view_modal_settings.dart';
import 'package:select2dot1/src/utils/event_args.dart';

class ListDataViewModal extends StatelessWidget {
  final ScrollController scrollController;
  final SearchController searchController;
  final SelectDataController selectDataController;
  final ListDataViewModalBuilder? listDataViewModalBuilder;
  final ListDataViewModalSettings listDataViewModalSettings;
  final CategoryItemModalBuilder? categoryItemModalBuilder;
  final CategoryItemModalSettings categoryItemModalSettings;
  final CategoryNameModalBuilder? categoryNameModalBuilder;
  final CategoryNameModalSettings categoryNameModalSettings;
  final GlobalSettings globalSettings;

  const ListDataViewModal({
    super.key,
    required this.scrollController,
    required this.searchController,
    required this.selectDataController,
    required this.listDataViewModalBuilder,
    required this.listDataViewModalSettings,
    required this.categoryItemModalBuilder,
    required this.categoryItemModalSettings,
    required this.categoryNameModalBuilder,
    required this.categoryNameModalSettings,
    required this.globalSettings,
  });

    Stream<List<Widget>> dataStreamFunc() async* {
    List<Widget> listDataViewChildren = [];
    for (int indexCategory = 0;
        indexCategory < searchController.getResults.length;
        indexCategory++) {
      listDataViewChildren.add(
        CategoryNameModal(
          singleCategory: searchController.getResults[indexCategory],
          selectDataController: selectDataController,
          categoryNameModalBuilder: categoryNameModalBuilder,
          categoryNameModalSettings: categoryNameModalSettings,
          globalSettings: globalSettings,
        ),
      );
      for (int indexItem = 0;
          indexItem <
              searchController.getResults[indexCategory]
                  .singleItemCategoryList.length;
          indexItem++) {
        listDataViewChildren.add(
          CategoryItemModal(
            singleItemCategory: searchController
                .getResults[indexCategory].singleItemCategoryList[indexItem],
            selectDataController: selectDataController,
            categoryItemModalBuilder: categoryItemModalBuilder,
            categoryItemModalSettings: categoryItemModalSettings,
            globalSettings: globalSettings,
          ),
        );
      }
    }

    yield listDataViewChildren;
  }

  @override
  Widget build(BuildContext context) {
    if (listDataViewModalBuilder != null) {
      // This can't be null anyways.
      // ignore: avoid-non-null-assertion
      return listDataViewModalBuilder!(
        context,
        ListDataViewModalDetails(
          scrollController: scrollController,
          searchController: searchController,
          selectDataController: selectDataController,
          categoryNameModal: _categoryNameModal,
          categoryItemModal: _categoryItemModal,
          globalSettings: globalSettings,
        ),
      );
    }

    return StreamBuilder<Object>(
      stream: dataStreamFunc(),
      builder: (context, snapshot) {
        return Container(
          margin: listDataViewModalSettings.margin,
          padding: listDataViewModalSettings.padding,
          child: CustomScrollView(
            shrinkWrap: true,
            controller: scrollController,
            slivers: <SliverList>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => (snapshot.data as List<Widget>)[index],
                  childCount: (snapshot.data as List<Widget>).length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryNameModal(SingleCategoryModel i) => CategoryNameModal(
        singleCategory: i,
        selectDataController: selectDataController,
        categoryNameModalBuilder: categoryNameModalBuilder,
        categoryNameModalSettings: categoryNameModalSettings,
        globalSettings: globalSettings,
      );

  Widget _categoryItemModal(SingleItemCategoryModel i) => CategoryItemModal(
        singleItemCategory: i,
        selectDataController: selectDataController,
        categoryItemModalBuilder: categoryItemModalBuilder,
        categoryItemModalSettings: categoryItemModalSettings,
        globalSettings: globalSettings,
      );
}
