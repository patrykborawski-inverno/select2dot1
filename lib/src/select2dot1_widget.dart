// NOTE: Select2dot1 is a export file for the library.
// ignore_for_file: prefer-match-file-name

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:select2dot1/src/controllers/modal_controller.dart';
import 'package:select2dot1/src/controllers/overlay_controller.dart';
import 'package:select2dot1/src/controllers/search_controller.dart';
import 'package:select2dot1/src/controllers/select_data_controller.dart';
import 'package:select2dot1/src/dropdown_overlay.dart';
import 'package:select2dot1/src/models/select_model.dart';
import 'package:select2dot1/src/pillbox.dart';
import 'package:select2dot1/src/settings/global_settings.dart';
import 'package:select2dot1/src/settings/modal/done_button_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/dropdown_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/list_data_view_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/loading_data_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/modal_category_settings.dart';
import 'package:select2dot1/src/settings/modal/modal_item_settings.dart';
import 'package:select2dot1/src/settings/modal/search_bar_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/search_empty_info_modal_settings.dart';
import 'package:select2dot1/src/settings/modal/title_modal_settings.dart';
import 'package:select2dot1/src/settings/overlay/dropdown_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/list_data_view_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/loading_data_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/overlay_category_settings.dart';
import 'package:select2dot1/src/settings/overlay/overlay_item_settings.dart';
import 'package:select2dot1/src/settings/overlay/search_bar_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/search_empty_info_overlay_settings.dart';
import 'package:select2dot1/src/settings/pillbox_content_multi_settings.dart';
import 'package:select2dot1/src/settings/pillbox_icon_settings.dart';
import 'package:select2dot1/src/settings/pillbox_settings.dart';
import 'package:select2dot1/src/settings/pillbox_title_settings.dart';
import 'package:select2dot1/src/settings/select_chip_settings.dart';
import 'package:select2dot1/src/settings/select_empty_info_settings.dart';
import 'package:select2dot1/src/settings/select_overload_info_settings.dart';
import 'package:select2dot1/src/settings/select_single_settings.dart';
import 'package:select2dot1/src/utils/animated_state.dart';
import 'package:select2dot1/src/utils/event_args.dart';

/// This is the main widget of the library and package.
/// Use this widget to create a select2dot1 widget.
///
///
/// On the first step you need to create a list of data that you want to display in.
/// ```dart
/// static const List<CategoryModel> exampleData = [
///     CategoryModel(
///       nameCategory: 'Team Leader',
///       itemList: [
///         ItemModel(
///           itemName: 'David Eubanks',
///           extraInfoSingleItem: 'Full time',
///           avatarSingleItem: CircleAvatar(
///             backgroundColor: Colors.transparent,
///             foregroundColor: Colors.transparent,
///             backgroundImage: AssetImage('assets/images/avatar1.jpg'),
///           ),
///         ),
///         ItemModel(
///           itemName: 'Stuart Resch',
///           extraInfoSingleItem: 'Part time',
///           avatarSingleItem: CircleAvatar(
///             backgroundColor: Colors.blue,
///             child: Text('SR', style: TextStyle(color: Colors.white)),
///           ),
///         ),
///       ],
///     ),
/// ```
///
/// Use Select2dot1 widget and pass your data to it. You can also pass scrollController if you want to use it.
/// ```dart
/// Select2dot1(
///     selectDataController: SelectDataController(data: exampleData),
///     scrollController: scrollController,
///     ),
/// ```
class Select2dot1<T> extends StatefulWidget {
  /// This is a controller which contains all the data that you want to display in the widget.
  /// You can also use this controller to get the value of the widget outside the widget.
  /// Also you can controller selected items.
  /// It is required.
  final SelectDataController<T> selectDataController;

  /// Used this to get the value of the widget outside the widget.
  /// It is call every time when the value of the widget is changed.
  final ValueChanged<List<SelectModel<T>>>? onChanged;

  /// Pass it if you want adjustable dropdown anchor.
  final ScrollController? scrollController;

  // Its okay.
  // ignore: prefer-correct-identifier-length
  final ScrollController? dropdownContentOverlayScrollController;

  // Its okay.
  // ignore: prefer-correct-identifier-length
  final DraggableScrollableController? dropdownContentModalScrollController;

  /// This is a boolean value that indicates whether the widget is searchable or not.
  /// Default value is [true].
  final bool isSearchable;

  /// This is a builder that is used to build the title pillbox of the widget.
  final PillboxTitleBuilder? pillboxTitleBuilder;

  /// This is a builder that is used to build the pillbox of the widget.
  final PillboxBuilder<T>? pillboxBuilder;

  /// This is a builder that is used to build the content of the pillbox in multi select mode.
  final PillboxContentMultiBuilder<T>? pillboxContentMultiBuilder;

  /// This is a builder that is used to build the content of the pillbox in single select mode.
  final PillboxContentSingleBuilder<T>? pillboxContentSingleBuilder;

  /// This is a builder that is used to build the icon of the pillbox.
  final PillboxIconBuilder? pillboxIconBuilder;

  /// This is a builder that is used to build the select chip of the widget.
  final SelectChipBuilder<T>? selectChipBuilder;

  /// This is a builder that is used to build the single select of the widget.
  final SelectSingleBuilder<T>? selectSingleBuilder;

  /// This is a builder that is used to build the empty info in pillbox.
  final SelectEmptyInfoBuilder? selectEmptyInfoBuilder;

  /// This is a builder that is used to build the overload info in pillbox.
  final SelectOverloadInfoBuilder? selectOverloadInfoBuilder;

  /// This is a builder that is used to build the dropdown content (overlay) of the widget.
  final DropdownContentOverlayBuilder<T>? dropdownContentOverlayBuilder;

  /// This is a builder that is used to build the search bar of the widget in overlay mode.
  final SearchBarOverlayBuilder<T>? searchBarOverlayBuilder;

  /// This is a builder that is used to build the loading data of dropdown content in overlay mode.
  final LoadingDataOverlayBuilder? loadingDataOverlayBuilder;

  /// This is a builder that is used to build the search empty info of dropdown content in overlay mode.
  final SearchEmptyInfoOverlayBuilder? searchEmptyInfoOverlayBuilder;

  /// This is a builder that is used to build the list data view of dropdown content in overlay mode.
  final ListDataViewOverlayBuilder<T>? listDataViewOverlayBuilder;

  /// This is a builder that is used to build the category name of list data view in overlay mode.
  final CategoryNameOverlayBuilder<T>? overlayCategoryBuilder;

  /// This is a builder that is used to build the category item of list data view in overlay mode.
  final CategoryItemOverlayBuilder<T>? overlayItemBuilder;

  /// This is a builder that is used to build the dropdown content (modal) of the widget.
  final DropdownContentModalBuilder<T>? dropdownContentModalBuilder;

  /// This is a builder that is used to build the title of dropdown content in modal mode.
  final TitleModalBuilder? titleModalBuilder;

  /// This is a builder that is used to build the done button of dropdown content in modal mode.
  final DoneButtonModalBuilder? doneButtonModalBuilder;

  /// This is a builder that is used to build the search bar of the widget in modal mode.
  final SearchBarModalBuilder<T>? searchBarModalBuilder;

  /// This is a builder that is used to build the loading data of dropdown content in modal mode.
  final LoadingDataModalBuilder? loadingDataModalBuilder;

  /// This is a builder that is used to build the search empty info of dropdown content in modal mode.
  final SearchEmptyInfoModalBuilder? searchEmptyInfoModalBuilder;

  /// This is a builder that is used to build the list data view of dropdown content in modal mode.
  final ListDataViewModalBuilder<T>? listDataViewModalBuilder;

  /// This is a builder that is used to build the category name of list data view in modal mode.
  final CategoryNameModalBuilder<T>? modalCategoryBuilder;

  /// This is a builder that is used to build the category item of list data view in modal mode.
  final CategoryItemModalBuilder<T>? modalItemBuilder;

  /// TODO:Comleate description. (If null default controller will be used).
  final SearchControllerSelect2dot1<T> searchController;

  /// This is a class which contains all the settings of the title of the widget.
  final PillboxTitleSettings pillboxTitleSettings;

  /// This is a class which contains all the settings of the pillbox of the widget.
  final PillboxSettings pillboxSettings;

  /// This is a class which contains all the settings of the content of the pillbox in multi select mode.
  final PillboxContentMultiSettings pillboxContentMultiSettings;

  /// This is a class which contains all the settings of the icon of the pillbox.
  final PillboxIconSettings pillboxIconSettings;

  /// This is a class which contains all the settings of the select chip of the widget.
  final SelectChipSettings selectChipSettings;

  /// This is a class which contains all the settings of the single select of the widget.
  final SelectSingleSettings selectSingleSettings;

  /// This is a class which contains all the settings of the empty info of the widget.
  final SelectEmptyInfoSettings selectEmptyInfoSettings;

  /// This is a class which contains all the settings of the overload info of the widget.
  final SelectOverloadInfoSettings selectOverloadInfoSettings;

  /// This is a class which contains all the settings of the dropdown content (overlay) of the widget.
  final DropdownOverlaySettings dropdownOverlaySettings;

  /// This is a class which contains all the settings of the search bar of the widget in overlay mode.
  final SearchBarOverlaySettings searchBarOverlaySettings;

  /// This is a class which contains all the settings of the loading data of dropdown content in overlay mode.
  final LoadingDataOverlaySettings loadingDataOverlaySettings;

  /// This is a class which contains all the settings of the search empty info of dropdown content in overlay mode.
  final SearchEmptyInfoOverlaySettings searchEmptyInfoOverlaySettings;

  /// This is a class which contains all the settings of the list data view of dropdown content in overlay mode.
  final ListDataViewOverlaySettings listDataViewOverlaySettings;

  /// This is a class which contains all the settings of the category name of list data view in overlay mode.
  final OverlayCategorySettings overlayCategorySettings;

  /// This is a class which contains all the settings of the category item of list data view in overlay mode.
  final OverlayItemSettings overlayItemSettings;

  /// This is a class which contains all the settings of the dropdown content (modal) of the widget.
  final DropdownModalSettings dropdownModalSettings;

  /// This is a class which contains all the settings of the title of dropdown content in modal mode.
  final TitleModalSettings titleModalSettings;

  /// This is a class which contains all the settings of the done button of dropdown content in modal mode.
  final DoneButtonModalSettings doneButtonModalSettings;

  /// This is a class which contains all the settings of the search bar of the widget in modal mode.
  final SearchBarModalSettings searchBarModalSettings;

  /// This is a class which contains all the settings of the loading data of dropdown content in modal mode.
  final LoadingDataModalSettings loadingDataModalSettings;

  /// This is a class which contains all the settings of the search empty info of dropdown content in modal mode.
  final SearchEmptyInfoModalSettings searchEmptyInfoModalSettings;

  /// This is a class which contains all the settings of the list data view of dropdown content in modal mode.
  final ListDataViewModalSettings listDataViewModalSettings;

  /// This is a class which contains all the settings of the category name of list data view in modal mode.
  final ModalCategorySettings modalCategorySettings;

  /// This is a class which contains all the settings of the category item of list data view in modal mode.
  final ModalItemSettings modalItemSettings;

  /// This is a class which contains all the global settings of the widget.
  final GlobalSettings globalSettings;

  /// This is a class which contains all the global settings of the widget.
  final Duration searchDealey;

  /// Controller of the data of the widget [selectDataController].
  /// To callback the data of the widget, you can use [selectDataController] to get the data
  /// or use [onChanged] to get the data.
  /// Pass [scrollController] to the widget to control anchor position of dropdown menu
  /// Set [isSearchable] to false to disable search bar
  /// Use builder to customize package by yourself.
  /// If you want you can also use the settings to customize the widget.
  Select2dot1({
    super.key,
    required this.selectDataController,
    this.onChanged,
    this.scrollController,
    this.dropdownContentOverlayScrollController,
    this.dropdownContentModalScrollController,
    this.isSearchable = true,
    this.pillboxTitleBuilder,
    this.pillboxBuilder,
    this.pillboxContentMultiBuilder,
    this.pillboxContentSingleBuilder,
    this.pillboxIconBuilder,
    this.selectChipBuilder,
    this.selectSingleBuilder,
    this.selectEmptyInfoBuilder,
    this.selectOverloadInfoBuilder,
    this.dropdownContentOverlayBuilder,
    this.searchBarOverlayBuilder,
    this.loadingDataOverlayBuilder,
    this.searchEmptyInfoOverlayBuilder,
    this.listDataViewOverlayBuilder,
    this.overlayCategoryBuilder,
    this.overlayItemBuilder,
    this.dropdownContentModalBuilder,
    this.titleModalBuilder,
    this.doneButtonModalBuilder,
    this.searchBarModalBuilder,
    this.loadingDataModalBuilder,
    this.searchEmptyInfoModalBuilder,
    this.listDataViewModalBuilder,
    this.modalCategoryBuilder,
    this.modalItemBuilder,
    SearchControllerSelect2dot1<T>? searchController,
    this.pillboxTitleSettings = const PillboxTitleSettings(),
    this.pillboxSettings = const PillboxSettings(),
    this.pillboxContentMultiSettings = const PillboxContentMultiSettings(),
    this.pillboxIconSettings = const PillboxIconSettings(),
    this.selectChipSettings = const SelectChipSettings(),
    this.selectSingleSettings = const SelectSingleSettings(),
    this.selectEmptyInfoSettings = const SelectEmptyInfoSettings(),
    this.selectOverloadInfoSettings = const SelectOverloadInfoSettings(),
    this.dropdownOverlaySettings = const DropdownOverlaySettings(),
    this.searchBarOverlaySettings = const SearchBarOverlaySettings(),
    this.loadingDataOverlaySettings = const LoadingDataOverlaySettings(),
    this.searchEmptyInfoOverlaySettings =
        const SearchEmptyInfoOverlaySettings(),
    this.listDataViewOverlaySettings = const ListDataViewOverlaySettings(),
    this.overlayCategorySettings = const OverlayCategorySettings(),
    this.overlayItemSettings = const OverlayItemSettings(),
    this.dropdownModalSettings = const DropdownModalSettings(),
    this.titleModalSettings = const TitleModalSettings(),
    this.doneButtonModalSettings = const DoneButtonModalSettings(),
    this.searchBarModalSettings = const SearchBarModalSettings(),
    this.loadingDataModalSettings = const LoadingDataModalSettings(),
    this.searchEmptyInfoModalSettings = const SearchEmptyInfoModalSettings(),
    this.listDataViewModalSettings = const ListDataViewModalSettings(),
    this.modalCategorySettings = const ModalCategorySettings(),
    this.modalItemSettings = const ModalItemSettings(),
    this.globalSettings = const GlobalSettings(),
    this.searchDealey = const Duration(milliseconds: 500),
    // It's done like this bc other method dosen't work.
  }) : searchController = searchController ??
            SearchControllerSelect2dot1<T>(selectDataController.data);

  @override
  State<Select2dot1<T>> createState() => _Select2dot1State<T>();
}

class _Select2dot1State<T> extends AnimatedState<T>
    with OverlayController<T>, ModalController<T> {
  // Its ok.
  //ignore: avoid-late-keyword
  late final SelectDataController<T> selectDataController;
  final bool kIsMobile = defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  // Its ok.
  // ignore: avoid-late-keyword
  late final LayerLink layerLink;

  // Its ok.
  // ignore: avoid-late-keyword
  late final double? appBarMaxHeightTemp;

  @override
  void initState() {
    super.initState();
    appBarMaxHeightTemp = Scaffold.maybeOf(context)?.appBarMaxHeight;

    selectDataController = widget.selectDataController;
    if (widget.onChanged != null) {
      selectDataController.addListener(_dataOutFromPackage);
    }

    if (!kIsMobile) {
      layerLink = LayerLink();
    }
  }

  @override
  void dispose() {
    if (widget.onChanged != null) {
      selectDataController.removeListener(_dataOutFromPackage);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Select2dot1<T> oldWidget) {
    if (!identical(
      oldWidget.selectDataController,
      widget.selectDataController,
    )) {
      log(
        'Warning: Do not create SelectDataController in build! For more information, see the SelectDataController section in pub.dev',
        name: 'Select2dot1Package',
      );
      selectDataController.copyWith(widget.selectDataController);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsMobile) {
      return Pillbox.modal(
        selectDataController: selectDataController,
        onTap: () => showModal(context),
        isVisibleOverlay: getIsVisibleOvarlay,
        pillboxTitleBuilder: widget.pillboxTitleBuilder,
        pillboxTitleSettings: widget.pillboxTitleSettings,
        pillboxBuilder: widget.pillboxBuilder,
        pillboxSettings: widget.pillboxSettings,
        pillboxContentSingleBuilder: widget.pillboxContentSingleBuilder,
        pillboxContentMultiBuilder: widget.pillboxContentMultiBuilder,
        pillboxContentMultiSettings: widget.pillboxContentMultiSettings,
        pillboxIconBuilder: widget.pillboxIconBuilder,
        pillboxIconSettings: widget.pillboxIconSettings,
        selectChipBuilder: widget.selectChipBuilder,
        selectChipSettings: widget.selectChipSettings,
        selectSingleBuilder: widget.selectSingleBuilder,
        selectSingleSettings: widget.selectSingleSettings,
        selectEmptyInfoBuilder: widget.selectEmptyInfoBuilder,
        selectEmptyInfoSettings: widget.selectEmptyInfoSettings,
        selectOverloadInfoBuilder: widget.selectOverloadInfoBuilder,
        selectOverloadInfoSettings: widget.selectOverloadInfoSettings,
        globalSettings: widget.globalSettings,
      );
    }

    return NotificationListener<SizeChangedLayoutNotification>(
      // A little less pedantic style - its okey.
      // ignore: prefer-extracting-callbacks
      onNotification: (notification) {
        SchedulerBinding.instance.addPostFrameCallback(refreshOverlayState);

        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: OverlayPortal(
          controller: overlayController,
          overlayChildBuilder: (context) => DropdownOverlay(
            selectDataController: selectDataController,
            searchController: widget.searchController,
            searchDealey: widget.searchDealey,
            overlayHide: hideOverlay,
            animationController: getAnimationController,
            layerLink: layerLink,
            appBarMaxHeight: appBarMaxHeightTemp,
            scrollController: widget.scrollController,
            pillboxLayout: widget.pillboxContentMultiSettings.pillboxLayout,
            dropdownContentOverlayScrollController:
                widget.dropdownContentOverlayScrollController,
            dropdownContentOverlayBuilder: widget.dropdownContentOverlayBuilder,
            dropdownOverlaySettings: widget.dropdownOverlaySettings,
            isSearchable: widget.isSearchable,
            searchBarOverlayBuilder: widget.searchBarOverlayBuilder,
            searchBarOverlaySettings: widget.searchBarOverlaySettings,
            loadingDataOverlayBuilder: widget.loadingDataOverlayBuilder,
            loadingDataOverlaySettings: widget.loadingDataOverlaySettings,
            searchEmptyInfoOverlayBuilder: widget.searchEmptyInfoOverlayBuilder,
            searchEmptyInfoOverlaySettings:
                widget.searchEmptyInfoOverlaySettings,
            listDataViewOverlayBuilder: widget.listDataViewOverlayBuilder,
            listDataViewOverlaySettings: widget.listDataViewOverlaySettings,
            overlayCategoryBuilder: widget.overlayCategoryBuilder,
            overlayCategorySettings: widget.overlayCategorySettings,
            overlayItemBuilder: widget.overlayItemBuilder,
            overlayItemSettings: widget.overlayItemSettings,
            globalSettings: widget.globalSettings,
          ),
          child: Pillbox.overlay(
            selectDataController: selectDataController,
            onTap: toogleOverlay,
            isVisibleOverlay: getIsVisibleOvarlay,
            pillboxLayerLink: layerLink,
            pillboxTitleBuilder: widget.pillboxTitleBuilder,
            pillboxTitleSettings: widget.pillboxTitleSettings,
            pillboxBuilder: widget.pillboxBuilder,
            pillboxSettings: widget.pillboxSettings,
            pillboxContentSingleBuilder: widget.pillboxContentSingleBuilder,
            pillboxContentMultiBuilder: widget.pillboxContentMultiBuilder,
            pillboxContentMultiSettings: widget.pillboxContentMultiSettings,
            pillboxIconBuilder: widget.pillboxIconBuilder,
            pillboxIconSettings: widget.pillboxIconSettings,
            selectChipBuilder: widget.selectChipBuilder,
            selectChipSettings: widget.selectChipSettings,
            selectSingleBuilder: widget.selectSingleBuilder,
            selectSingleSettings: widget.selectSingleSettings,
            selectEmptyInfoBuilder: widget.selectEmptyInfoBuilder,
            selectEmptyInfoSettings: widget.selectEmptyInfoSettings,
            selectOverloadInfoBuilder: widget.selectOverloadInfoBuilder,
            selectOverloadInfoSettings: widget.selectOverloadInfoSettings,
            globalSettings: widget.globalSettings,
          ),
        ),
      ),
    );
  }

  void _dataOutFromPackage() {
    if (widget.onChanged != null) {
      // This can't be null anyways.
      // ignore:avoid-non-null-assertion
      widget.onChanged!(
        selectDataController.selectedList,
      );
    }
  }
}
