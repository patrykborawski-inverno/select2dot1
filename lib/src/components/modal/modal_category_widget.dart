import 'package:flutter/material.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:select2dot1/src/controllers/select_data_controller.dart';
import 'package:select2dot1/src/models/selectable_interface.dart';
import 'package:select2dot1/src/settings/global_settings.dart';
import 'package:select2dot1/src/settings/modal/modal_category_settings.dart';
import 'package:select2dot1/src/utils/event_args.dart';

class ModalCategoryWidget<T> extends StatefulWidget {
  final int deepth;
  final SelectableInterface<T> singleCategory;
  final SelectDataController<T> selectDataController;
  final CategoryNameModalBuilder<T>? modalCategoryBuilder;
  final ModalCategorySettings modalCategorySettings;
  final GlobalSettings globalSettings;

  const ModalCategoryWidget({
    super.key,
    this.deepth = 0,
    required this.singleCategory,
    required this.selectDataController,
    required this.modalCategoryBuilder,
    required this.modalCategorySettings,
    required this.globalSettings,
  });

  @override
  State<ModalCategoryWidget<T>> createState() => _CategoryItemModalState<T>();
}

class _CategoryItemModalState<T> extends State<ModalCategoryWidget<T>> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    widget.selectDataController.addListener(_selectDataListener);

    isSelected = _isSelected();
  }

  @override
  void dispose() {
    widget.selectDataController.removeListener(_selectDataListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.modalCategoryBuilder != null) {
      // This can't be null anyways.
      // ignore: avoid-non-null-assertion
      return widget.modalCategoryBuilder!(
        context,
        CategoryNameModalDetails(
          singleCategory: widget.singleCategory,
          selectDataController: widget.selectDataController,
          onTapCategory: _onTapCategory,
          globalSettings: widget.globalSettings,
        ),
      );
    }
    Widget text = Text(
      // This can't be null because of the if statement above.
      // ignore: avoid-non-null-assertion
      widget.singleCategory.finalLabel,
      overflow: widget.modalCategorySettings.textOverflow,
      style: _getTextStyle(),
    );

    if (widget.modalCategorySettings.showTooltip) {
      text = Tooltip(
        waitDuration: const Duration(seconds: 1),
        message: widget.singleCategory.finalLabel,
        child: text,
      );
    }

    return Container(
      margin: widget.modalCategorySettings.margin,
      child: InkWell(
        onTap: _onTapCategory,
        borderRadius: widget.modalCategorySettings.inkWellBorderRadius,
        splashColor: widget.selectDataController.isMultiSelect
            ? widget.modalCategorySettings.splashColor
            : Colors.transparent,
        highlightColor: widget.selectDataController.isMultiSelect
            ? widget.modalCategorySettings.highlightColor
            : Colors.transparent,
        child: Container(
          decoration: widget.modalCategorySettings.decoration,
          alignment: widget.modalCategorySettings.alignmentGeometry,
          constraints: widget.modalCategorySettings.constraints,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: widget.selectDataController.isCategorySelectable,
                child: Padding(
                  padding: widget.modalCategorySettings.iconPadding,
                  child: AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration:
                        widget.modalCategorySettings.iconAnimationDuration,
                    curve: widget.modalCategorySettings.iconAnimationCurve,
                    child: Icon(
                      widget.modalCategorySettings.iconData,
                      size: widget.modalCategorySettings.iconSize,
                      color: _getIconColor(),
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < widget.deepth; i++)
                widget.modalCategorySettings.indent,
              Flexible(
                child: Padding(
                  padding: widget.modalCategorySettings.textPadding,
                  child: text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle() {
    TextStyle textStyle = isSelected
        ? widget.modalCategorySettings.selectedTextStyle
        : widget.modalCategorySettings.defaultTextStyle;

    if (textStyle.color == null) {
      return textStyle.copyWith(
        color: isSelected
            ? widget.globalSettings.mainColor
            : widget.globalSettings.textColor,
      );
    }

    if (textStyle.fontFamily == null) {
      return textStyle.copyWith(
        fontFamily: widget.globalSettings.fontFamily,
      );
    }

    return textStyle;
  }

  Color _getIconColor() {
    return isSelected
        ? widget.modalCategorySettings.iconSelectedColor ??
            widget.globalSettings.mainColor
        : widget.modalCategorySettings.iconDefaultColor ??
            widget.globalSettings.textColor;
  }

  void _onTapCategory() {
    if (widget.singleCategory is! SelectableCategory<T>) {
      return;
    }
    if (widget.selectDataController.isCategorySelectable) {
      if (!widget.selectDataController.isMultiSelect) {
        widget.selectDataController.selectedList.clear();
      }
      if (widget.selectDataController.selectedList
          .contains(widget.singleCategory)) {
        widget.selectDataController.removeSelectedChip(
          widget.singleCategory,
        );
      } else {
        widget.selectDataController.addSelectChip(widget.singleCategory);
      }
    }
    if (widget.selectDataController.isCategoryAddAllChildren) {
      if (!widget.selectDataController.isMultiSelect) {
        return;
      }
      List<SelectableInterface<T>> itemList =
          (widget.singleCategory as SelectableCategory<T>).childrens;
      //TODO: recurrence add all children.
      if (itemList.every(
        (element) => widget.selectDataController.selectedList.contains(element),
      )) {
        widget.selectDataController.removeGroupSelectChip(itemList);
      } else {
        widget.selectDataController.addGroupSelectChip(itemList);
      }
    }
  }

  bool _isSelected() {
    if (widget.selectDataController.selectedList
        .contains(widget.singleCategory)) {
      return true;
    }

    return false;
  }

  void _selectDataListener() {
    if (isSelected == _isSelected()) return;

    if (mounted) {
      setState(() {
        isSelected = _isSelected();
      });
    }
  }
}
