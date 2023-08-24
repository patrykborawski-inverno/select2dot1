import 'package:flutter/material.dart';
import 'package:fuzzysearch/fuzzysearch.dart';
import 'package:select2dot1/src/models/single_category_model.dart';
import 'package:select2dot1/src/models/single_item_category_model.dart';

/// SearchController is a class that will be used to search data.
// Its okay.
// ignore: prefer-match-file-name
class SearchControllerSelect2dot1 extends ChangeNotifier {
  /// Old length memory of search results.
  int oldLength = 0;

  /// Options for FuzzySearch default values are:
  /// [FuzzyOptions.findAllMatches] = true,
  /// [FuzzyOptions.tokenize] = true,
  /// [FuzzyOptions.threshold] = 0.5.
  final FuzzyOptions? fuzzyOptions;

  /// Data to search.
  /// It is required.
  final List<SingleCategoryModel> data;

  /// Search results.
  /// First it will be same as [data].
  final List<SingleCategoryModel> results;

  /// Getter for [results] find by [findSearchDataResults].
  List<SingleCategoryModel> get getResults => results;

  /// Creating an argument constructor of [SearchControllerSelect2dot1] class.
  /// [data] is data to search. [data] is required.
  SearchControllerSelect2dot1(this.data, {this.fuzzyOptions})
      : results = data.toList() // Fix pass by reference.
  {
    oldLength = countLength();
  }

  /// Find search data results function.
  /// This function will be used to find search data results.
  /// [value] is required string pattern to search.
  Future<void> findSearchDataResults(String value) async {
    // Will be improve in next version.
    oldLength = countLength();
    results.clear();

    for (var category in data) {
      List<SingleItemCategoryModel> tempSingleItemCategoryList = [];

      Fuzzy<SingleItemCategoryModel> fuse = Fuzzy.withIdentifiers(
        {
          for (var singleItem in category.singleItemCategoryList)
            singleItem.nameSingleItem: singleItem,
        },
        options: fuzzyOptions ??
            FuzzyOptions(
              findAllMatches: true,
              tokenize: true,
              threshold: 0.5,
            ),
      );
      List<Result<SingleItemCategoryModel>> tmpResults = await fuse.search(value);
      for (var element in tmpResults) {
        if (element.identifier != null) {
          // Null check done above.
          // ignore: avoid-non-null-assertion
          tempSingleItemCategoryList.add(element.identifier!);
        }
      }

      if (tempSingleItemCategoryList.isNotEmpty) {
        results.add(
          SingleCategoryModel(
            nameCategory: category.nameCategory,
            singleItemCategoryList: tempSingleItemCategoryList,
          ),
        );
      }
    }

    int newLength = countLength();
    if (oldLength != newLength) {
      notifyListeners();
    }
  }

  /// Count length of search results function.
  int countLength() {
    int length = 0;
    for (var category in results) {
      length += category.singleItemCategoryList.length;
    }

    return length;
  }
}
