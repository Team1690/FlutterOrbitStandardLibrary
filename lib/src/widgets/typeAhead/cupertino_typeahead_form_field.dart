import "dart:async";
import "dart:core";

import "package:flutter/cupertino.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/cupertino_suggestions_box_controller.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/cupertino_suggestions_box_decoration.dart";
import "package:orbit_standard_library/src/widgets/typeAhead/cupertino_text_field_configuration.dart";
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
    final String? initialValue,
    final bool getImmediateSuggestions = false,
    @Deprecated("Use autoValidateMode parameter which provides more specific "
        "behavior related to auto validation. "
        "This feature was deprecated after Flutter v1.19.0.")
    final bool autovalidate = false,
    super.enabled,
    super.autovalidateMode,
    super.onSaved,
    super.validator,
    final ErrorBuilder? errorBuilder,
    final WidgetBuilder? noItemsFoundBuilder,
    final WidgetBuilder? loadingBuilder,
    final Duration debounceDuration = const Duration(milliseconds: 300),
    final CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration =
        const CupertinoSuggestionsBoxDecoration(),
    final CupertinoSuggestionsBoxController? suggestionsBoxController,
    required final SuggestionSelectionCallback<T> onSuggestionSelected,
    required final ItemBuilder<T> itemBuilder,
    final IndexedWidgetBuilder? itemSeparatorBuilder,
    required final FutureOr<List<T>> Function(String) suggestionsCallback,
    final double suggestionsBoxVerticalOffset = 5.0,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    final Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
    final Duration animationDuration = const Duration(milliseconds: 500),
    final double animationStart = 0.25,
    final TextEditingController? controller,
    final VerticalDirection direction = VerticalDirection.down,
    final bool hideOnLoading = false,
    final bool hideOnEmpty = false,
    final bool hideOnError = false,
    final bool hideSuggestionsOnKeyboardHide = true,
    final bool keepSuggestionsOnLoading = true,
    final bool keepSuggestionsOnSuggestionSelected = false,
    final bool autoFlipDirection = false,
    final bool autoFlipListDirection = true,
    final double autoFlipMinHeight = 64.0,
    final int minCharsForSuggestions = 0,
    final bool hideKeyboardOnDrag = false,
    final void Function(T)? onSelected,
  })  : assert(
            initialValue == null || textFieldConfiguration.controller == null,),
        assert(minCharsForSuggestions >= 0),
        super(
            initialValue: textFieldConfiguration.controller != null
                ? textFieldConfiguration.controller!.text
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
  /// The configuration of the [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
  /// that the TypeAhead widget displays
  final TextFieldConfiguration textFieldConfiguration;

  @override
  CupertinoTypeAheadFormFieldState<T> createState() =>
      CupertinoTypeAheadFormFieldState<T>();
}

class CupertinoTypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _controller;

  @override
  TypeAheadFormField<dynamic> get widget =>
      super.widget as TypeAheadFormField<dynamic>;

  @override
  void initState() {
    super.initState();
    if (widget.textFieldConfiguration.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.textFieldConfiguration.controller!
          .addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(final TypeAheadFormField<dynamic> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textFieldConfiguration.controller !=
        oldWidget.textFieldConfiguration.controller) {
      oldWidget.textFieldConfiguration.controller
          ?.removeListener(_handleControllerChanged);
      widget.textFieldConfiguration.controller
          ?.addListener(_handleControllerChanged);

      if (oldWidget.textFieldConfiguration.controller != null &&
          widget.textFieldConfiguration.controller == null) {
        _controller = TextEditingController.fromValue(
            oldWidget.textFieldConfiguration.controller!.value,);
      }
      if (widget.textFieldConfiguration.controller != null) {
        setValue(widget.textFieldConfiguration.controller!.text);
        if (oldWidget.textFieldConfiguration.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.textFieldConfiguration.controller
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
