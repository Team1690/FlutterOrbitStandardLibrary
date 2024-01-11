import "dart:async";
import "dart:core";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/cupertino_suggestions_box_controller.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/cupertino_suggestions_box_decoration.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/typedef.dart";

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadFormField<T> extends FormField<String> {

  /// Creates a [TypeAheadFormField]
  TypeAheadFormField({
    super.key,
    super.enabled,
    super.autovalidateMode,
    super.onSaved,
    super.validator,
    final String? initialValue,
    this.getImmediateSuggestions = false,
    this.autovalidate = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    this.suggestionsBoxController,
    required this.onSuggestionSelected,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    required this.suggestionsCallback,
    this.suggestionsBoxVerticalOffset = 5.0,
    this.transitionBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.controller,
    this.direction = VerticalDirection.down,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64.0,
    this.minCharsForSuggestions = 0,
    this.hideKeyboardOnDrag = false,
    this.onSelected,
    this.focusNode,
    this.decoration,
    this.padding,
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode,
    this.suffix,
    this.suffixMode,
    this.clearButtonMode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.style,
    this.textAlign,
    this.autofocus,
    this.obscureText,
    this.autocorrect,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.enableSuggestions,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.autofillHints,

  })  : assert(
            initialValue == null || controller == null,),
        assert(minCharsForSuggestions >= 0),
        super(
            initialValue: controller != null
                ? controller.text
                : (initialValue ?? ""),
            builder: (final FormFieldState<String> field) => TypeAheadField<T>(
                onSelected: onSelected,
                animationDuration: animationDuration,
                autoFlipDirection: autoFlipDirection,
                autoFlipMinHeight: autoFlipMinHeight,
                controller: controller,
                debounceDuration: debounceDuration,
                direction: direction,
                errorBuilder: errorBuilder,
                hideKeyboardOnDrag: hideKeyboardOnDrag,
                hideOnEmpty: hideOnEmpty,
                hideOnError: hideOnError,
                hideOnLoading: hideOnLoading,
                itemBuilder: itemBuilder,
                itemSeparatorBuilder: itemSeparatorBuilder,
                key: key,
                loadingBuilder: loadingBuilder,
                suggestionsCallback: suggestionsCallback,
                transitionBuilder: transitionBuilder,
                ),
            );
  
    final bool getImmediateSuggestions;
    @Deprecated("Use autoValidateMode parameter which provides more specific "
        "behavior related to auto validation. "
        "This feature was deprecated after Flutter v1.19.0.")
    final bool autovalidate;
    final ErrorBuilder? errorBuilder;
    final WidgetBuilder? noItemsFoundBuilder;
    final WidgetBuilder? loadingBuilder;
    final Duration debounceDuration;
    final CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration;
    final CupertinoSuggestionsBoxController? suggestionsBoxController;
    final SuggestionSelectionCallback<T> onSuggestionSelected;
    final ItemBuilder<T> itemBuilder;
    final IndexedWidgetBuilder? itemSeparatorBuilder;
    final FutureOr<List<T>> Function(String) suggestionsCallback;
    final double suggestionsBoxVerticalOffset;
    final Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder;
    final Duration animationDuration;
    final double animationStart;
    final TextEditingController? controller;
    final VerticalDirection direction;
    final bool hideOnLoading;
    final bool hideOnEmpty;
    final bool hideOnError;
    final bool hideSuggestionsOnKeyboardHide;
    final bool keepSuggestionsOnLoading;
    final bool keepSuggestionsOnSuggestionSelected;
    final bool autoFlipDirection;
    final bool autoFlipListDirection;
    final double autoFlipMinHeight;
    final int minCharsForSuggestions;
    final bool hideKeyboardOnDrag;
    final void Function(T)? onSelected;
    final FocusNode? focusNode;
    final InputDecoration? decoration;
    final EdgeInsetsGeometry? padding;
    final String? placeholder;
    final TextStyle? placeholderStyle;
    final Widget? prefix;
    final OverlayVisibilityMode? prefixMode;
    final Widget? suffix;
    final OverlayVisibilityMode? suffixMode;
    final OverlayVisibilityMode? clearButtonMode;
    final TextInputType? keyboardType;
    final TextInputAction? textInputAction;
    final TextCapitalization? textCapitalization;
    final TextStyle? style;
    final TextAlign? textAlign;
    final bool? autofocus;
    final bool? obscureText;
    final bool? autocorrect;
    final int? maxLines;
    final int? minLines;
    final int? maxLength;
    final MaxLengthEnforcement? maxLengthEnforcement;
    final ValueChanged<String>? onChanged;
    final VoidCallback? onEditingComplete;
    final GestureTapCallback? onTap;
    final ValueChanged<String>? onSubmitted;
    final List<TextInputFormatter>? inputFormatters;
    final bool? enableSuggestions;
    final double? cursorWidth;
    final Radius? cursorRadius;
    final Color? cursorColor;
    final Brightness? keyboardAppearance;
    final EdgeInsets? scrollPadding;
    final bool? enableInteractiveSelection;
    final List<String>? autofillHints;
  /// The configuration of the [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
  /// that the TypeAhead widget displays
  

  @override
  CupertinoTypeAheadFormFieldState<T> createState() =>
      CupertinoTypeAheadFormFieldState<T>();
}

class CupertinoTypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  @override
  TypeAheadFormField<dynamic> get widget =>
      super.widget as TypeAheadFormField<dynamic>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller!
          .addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(final TypeAheadFormField<dynamic> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller !=
        oldWidget.controller) {
      oldWidget.controller
          ?.removeListener(_handleControllerChanged);
      widget.controller
          ?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null &&
          widget.controller == null) {
        _controller = TextEditingController.fromValue(
            oldWidget.controller!.value,);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller
        ?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue!;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }
}
