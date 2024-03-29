import "package:flutter/cupertino.dart";
import "package:flutter_typeahead/flutter_typeahead.dart";

class CupertinoSuggestionsBox {

  CupertinoSuggestionsBox(
    this.context,
    this.direction,
    this.autoFlipDirection,
    this.autoFlipListDirection,
    this.autoFlipMinHeight,
  ) : desiredDirection = direction;
  static const int waitMetricsTimeoutMillis = 1000;

  final BuildContext context;
  final AxisDirection desiredDirection;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;
  final double autoFlipMinHeight;

  OverlayEntry? overlayEntry;
  AxisDirection direction;

  bool isOpened = false;
  bool widgetMounted = true;
  double maxHeight = 300.0;
  double textBoxWidth = 100.0;
  double textBoxHeight = 100.0;
  late double directionUpOffset;

  void open() {
    if (isOpened) return;
    assert(overlayEntry != null);
    resize();
    Overlay.of(context).insert(overlayEntry!);
    isOpened = true;
  }

  void close() {
    if (!isOpened) return;
    assert(overlayEntry != null);
    overlayEntry!.remove();
    isOpened = false;
  }

  void toggle() {
    if (isOpened) {
      close();
    } else {
      open();
    }
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    context.visitAncestorElements((final Element element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _waitChangeMetrics() async {
    if (widgetMounted) {
      // initial viewInsets which are before the keyboard is toggled
      final EdgeInsets initial = MediaQuery.of(context).viewInsets;
      // initial MediaQuery for orientation change
      final MediaQuery? initialRootMediaQuery = _findRootMediaQuery();

      int timer = 0;
      // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
      while (widgetMounted && timer < waitMetricsTimeoutMillis) {
        await Future<void>.delayed(const Duration(milliseconds: 170));
        timer += 170;

        if (widgetMounted &&
            (MediaQuery.of(context).viewInsets != initial ||
                _findRootMediaQuery() != initialRootMediaQuery)) {
          return true;
        }
      }
    }

    return false;
  }

  void resize() {
    // check to see if widget is still mounted
    // user may have closed the widget with the keyboard still open
    if (widgetMounted) {
      _adjustMaxHeightAndOrientation();
      overlayEntry!.markNeedsBuild();
    }
  }

  // See if there's enough room in the desired direction for the overlay to display
  // correctly. If not, try the opposite direction if things look more roomy there
  void _adjustMaxHeightAndOrientation() {
    final CupertinoTypeAheadField<dynamic> widget = context.widget as CupertinoTypeAheadField<dynamic>;

    final RenderBox box = context.findRenderObject() as RenderBox;
    textBoxWidth = box.size.width;
    textBoxHeight = box.size.height;

    // top of text box
    final double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    final double windowHeight = MediaQuery.of(context).size.height;

    // we need to find the root MediaQuery for the unsafe area height
    // we cannot use BuildContext.ancestorWidgetOfExactType because
    // widgets like SafeArea creates a new MediaQuery with the padding removed
    final MediaQuery rootMediaQuery = _findRootMediaQuery()!;

    // height of keyboard
    final double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    final double maxHDesired = _calculateMaxHeight(desiredDirection, box, widget,
        windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY,);

    // if there's enough room in the desired direction, update the direction and the max height
    if (maxHDesired >= autoFlipMinHeight || !autoFlipDirection) {
      direction = desiredDirection;
      maxHeight = maxHDesired;
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      final AxisDirection flipped = flipAxisDirection(desiredDirection);
      final double maxHFlipped = _calculateMaxHeight(flipped, box, widget,
          windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY,);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHFlipped > maxHDesired) {
        direction = flipped;
        maxHeight = maxHFlipped;
      }
    }

    if (maxHeight < 0) maxHeight = 0;
  }

  double _calculateMaxHeight(
      final AxisDirection direction,
      final RenderBox box,
      final CupertinoTypeAheadField<dynamic> widget,
      final double windowHeight,
      final MediaQuery rootMediaQuery,
      final double keyboardHeight,
      final double textBoxAbsY,) => direction == AxisDirection.down
        ? _calculateMaxHeightDown(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY,)
        : _calculateMaxHeightUp(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY,);

  double _calculateMaxHeightDown(
      final RenderBox box,
      final CupertinoTypeAheadField<dynamic> widget,
      final double windowHeight,
      final MediaQuery rootMediaQuery,
      final double keyboardHeight,
      final double textBoxAbsY,) {
    // unsafe area, ie: iPhone X 'home button'
    // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
    final double unsafeAreaHeight =
        keyboardHeight == 0 ? rootMediaQuery.data.padding.bottom : 0;

    return windowHeight -
        keyboardHeight -
        unsafeAreaHeight -
        textBoxHeight -
        textBoxAbsY;
  }

  double _calculateMaxHeightUp(
      final RenderBox box,
      final CupertinoTypeAheadField<dynamic> widget,
      final double windowHeight,
      final MediaQuery rootMediaQuery,
      final double keyboardHeight,
      final double textBoxAbsY,) {
    // recalculate keyboard absolute y value
    final double keyboardAbsY = windowHeight - keyboardHeight;

    directionUpOffset = textBoxAbsY > keyboardAbsY
        ? keyboardAbsY - textBoxAbsY
        : 0;

    // unsafe area, ie: iPhone X notch
    final double unsafeAreaHeight = rootMediaQuery.data.padding.top;

    return textBoxAbsY > keyboardAbsY
        ? keyboardAbsY -
            unsafeAreaHeight
        : textBoxAbsY -
            unsafeAreaHeight;
  }

  Future<void> onChangeMetrics() async {
    if (await _waitChangeMetrics()) {
      resize();
    }
  }
}
