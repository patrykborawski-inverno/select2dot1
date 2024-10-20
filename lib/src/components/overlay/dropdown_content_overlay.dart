import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:select2dot1/src/components/overlay/list_data_view_overlay.dart';
import 'package:select2dot1/src/components/overlay/search_bar_overlay.dart';
import 'package:select2dot1/src/controllers/search_controller.dart';
import 'package:select2dot1/src/controllers/select_data_controller.dart';
import 'package:select2dot1/src/settings/global_settings.dart';
import 'package:select2dot1/src/settings/overlay/overlay_item_settings.dart';
import 'package:select2dot1/src/settings/overlay/overlay_category_settings.dart';
import 'package:select2dot1/src/settings/overlay/dropdown_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/list_data_view_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/loading_data_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/search_bar_overlay_settings.dart';
import 'package:select2dot1/src/settings/overlay/search_empty_info_overlay_settings.dart';
import 'package:select2dot1/src/utils/event_args.dart';

class DropdownContentOverlay<T> extends StatefulWidget {
  final SelectDataController<T> selectDataController;
  final SearchControllerSelect2dot1<T> searchController;
  final void Function() overlayHide;
  final LayerLink layerLink;
  final ScrollController? scrollController;
  final Duration searchDealey;
  final double? appBarMaxHeight;
  // Its okay.
  // ignore: prefer-correct-identifier-length
  final ScrollController? dropdownContentOverlayScrollController;
  final DropdownContentOverlayBuilder<T>? dropdownContentOverlayBuilder;
  final DropdownOverlaySettings dropdownOverlaySettings;
  final bool isSearchable;
  final SearchBarOverlayBuilder<T>? searchBarOverlayBuilder;
  final SearchBarOverlaySettings searchBarOverlaySettings;
  final LoadingDataOverlayBuilder? loadingDataOverlayBuilder;
  final LoadingDataOverlaySettings loadingDataOverlaySettings;
  final SearchEmptyInfoOverlayBuilder? searchEmptyInfoOverlayBuilder;
  final SearchEmptyInfoOverlaySettings searchEmptyInfoOverlaySettings;
  final ListDataViewOverlayBuilder<T>? listDataViewOverlayBuilder;
  final ListDataViewOverlaySettings listDataViewOverlaySettings;
  final CategoryNameOverlayBuilder<T>? overlayCategoryBuilder;
  final OverlayCategorySettings overlayCategorySettings;
  final CategoryItemOverlayBuilder<T>? overlayItemBuilder;
  final OverlayItemSettings overlayItemSettings;
  final GlobalSettings globalSettings;

  const DropdownContentOverlay({
    super.key,
    required this.selectDataController,
    required this.searchController,
    required this.overlayHide,
    required this.layerLink,
    required this.scrollController,
    required this.searchDealey,
    required this.appBarMaxHeight,
    required this.dropdownContentOverlayScrollController,
    required this.dropdownContentOverlayBuilder,
    required this.dropdownOverlaySettings,
    required this.isSearchable,
    required this.searchBarOverlayBuilder,
    required this.searchBarOverlaySettings,
    required this.loadingDataOverlayBuilder,
    required this.loadingDataOverlaySettings,
    required this.searchEmptyInfoOverlayBuilder,
    required this.searchEmptyInfoOverlaySettings,
    required this.listDataViewOverlayBuilder,
    required this.listDataViewOverlaySettings,
    required this.overlayCategoryBuilder,
    required this.overlayCategorySettings,
    required this.overlayItemBuilder,
    required this.overlayItemSettings,
    required this.globalSettings,
  });

  @override
  State<DropdownContentOverlay<T>> createState() =>
      _DropdownContentOverlayState<T>();
}

class _DropdownContentOverlayState<T> extends State<DropdownContentOverlay<T>> {
  static const dropdownOverlayPadding = 10;
  final keySearchBarOverlay = GlobalKey();
  Size sizeSearchBarOverlay = const Size(0, 0);

  @override
  void initState() {
    super.initState();
    if (widget.dropdownContentOverlayBuilder == null) {
      _calculateSearchBarOverlaySize();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dropdownContentOverlayBuilder != null) {
      // This can't be null anyways.
      // ignore: avoid-non-null-assertion
      return widget.dropdownContentOverlayBuilder!(
        context,
        DropdownContentOverlayDetails(
          selectDataController: widget.selectDataController,
          overlayHide: widget.overlayHide,
          layerLink: widget.layerLink,
          scrollController: widget.scrollController,
          appBarMaxHeight: widget.appBarMaxHeight,
          searchController: widget.searchController,
          searchBarOverlay: _searchBarOverlay,
          listDataViewOverlay: _listDataViewOverlay,
          globalSettings: widget.globalSettings,
        ),
      );
    }

    return Container(
      decoration: _getDecoration(),
      margin: widget.dropdownOverlaySettings.margin,
      padding: widget.dropdownOverlaySettings.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationListener<SizeChangedLayoutNotification>(
            // A little less pedantic style - its okey.
            // ignore: prefer-extracting-callbacks
            onNotification: (notification) {
              _calculateSearchBarOverlaySize();

              return true;
            },
            child: SizeChangedLayoutNotifier(
              child: SearchBarOverlay(
                searchDealey: widget.searchDealey,
                key: keySearchBarOverlay,
                searchController: widget.searchController,
                isSearchable: widget.isSearchable,
                searchBarOverlayBuilder: widget.searchBarOverlayBuilder,
                searchBarOverlaySettings: widget.searchBarOverlaySettings,
                globalSettings: widget.globalSettings,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: widget.dropdownOverlaySettings.minHeight,
              maxHeight: _calculateMaxHeight(),
            ),
            child: ListDataViewOverlay(
              searchController: widget.searchController,
              selectDataController: widget.selectDataController,
              overlayHide: widget.overlayHide,
              dropdownContentOverlayScrollController:
                  widget.dropdownContentOverlayScrollController,
              loadingDataOverlayBuilder: widget.loadingDataOverlayBuilder,
              loadingDataOverlaySettings: widget.loadingDataOverlaySettings,
              searchEmptyInfoOverlayBuilder:
                  widget.searchEmptyInfoOverlayBuilder,
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
          ),
        ],
      ),
    );
  }

  BoxDecoration _getDecoration() {
    BoxDecoration decoration = widget.dropdownOverlaySettings.decoration;

    if (decoration.color == null) {
      decoration = decoration.copyWith(
        color: widget.globalSettings.backgroundColor,
      );
    }

    if (decoration.border == null) {
      decoration = decoration.copyWith(
        border: Border.fromBorderSide(
          BorderSide(color: widget.globalSettings.inActiveColor),
        ),
      );
    }

    if (decoration.boxShadow == null) {
      decoration = decoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: widget.globalSettings.inActiveColor,
            // Its constant.
            // ignore: no-magic-number
            blurRadius: 2.0,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }

    return decoration;
  }

  void _calculateSearchBarOverlaySize() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      assert(keySearchBarOverlay.currentContext != null);
      final RenderObject? renderObject =
          keySearchBarOverlay.currentContext?.findRenderObject();
      assert(renderObject == null || renderObject is RenderBox);

      if (renderObject != null) {
        if (mounted) {
          setState(() {
            sizeSearchBarOverlay = (renderObject as RenderBox).size;
          });
        }
      }
    });
  }

  double _calculateMaxHeight() {
    double viewDimension = widget
            .scrollController?.position.viewportDimension ??
        (MediaQuery.of(context).size.height - (widget.appBarMaxHeight ?? 0));

    double results = viewDimension / 2 -
        (widget.layerLink.leaderSize?.height ?? 0) / 2 -
        sizeSearchBarOverlay.height -
        dropdownOverlayPadding;

    if (widget.dropdownOverlaySettings.maxHeight > results) {
      return results >= widget.dropdownOverlaySettings.minHeight
          ? results
          : widget.dropdownOverlaySettings.minHeight;
    } else {
      return widget.dropdownOverlaySettings.maxHeight;
    }
  }

  Widget _searchBarOverlay() => SearchBarOverlay(
        searchDealey: widget.searchDealey,
        searchController: widget.searchController,
        isSearchable: widget.isSearchable,
        searchBarOverlayBuilder: widget.searchBarOverlayBuilder,
        searchBarOverlaySettings: widget.searchBarOverlaySettings,
        globalSettings: widget.globalSettings,
      );

  Widget _listDataViewOverlay() => ListDataViewOverlay(
        searchController: widget.searchController,
        selectDataController: widget.selectDataController,
        overlayHide: widget.overlayHide,
        dropdownContentOverlayScrollController:
            widget.dropdownContentOverlayScrollController,
        loadingDataOverlayBuilder: widget.loadingDataOverlayBuilder,
        loadingDataOverlaySettings: widget.loadingDataOverlaySettings,
        searchEmptyInfoOverlayBuilder: widget.searchEmptyInfoOverlayBuilder,
        searchEmptyInfoOverlaySettings: widget.searchEmptyInfoOverlaySettings,
        listDataViewOverlayBuilder: widget.listDataViewOverlayBuilder,
        listDataViewOverlaySettings: widget.listDataViewOverlaySettings,
        overlayCategoryBuilder: widget.overlayCategoryBuilder,
        overlayCategorySettings: widget.overlayCategorySettings,
        overlayItemBuilder: widget.overlayItemBuilder,
        overlayItemSettings: widget.overlayItemSettings,
        globalSettings: widget.globalSettings,
      );
}
