import "package:flutter/material.dart";
import "package:orbit_standard_library/src/map_nullable.dart";

class Selector<T> extends StatelessWidget {
  Selector({
    required this.options,
    required this.placeholder,
    required this.value,
    required this.makeItem,
    required this.onChange,
    required this.validate,
    this.borderRadius,
  });

  final List<T> options;
  final String placeholder;
  final BorderRadius? borderRadius;
  final void Function(T) onChange;
  final String Function(T) makeItem;
  final String? Function(T) validate;
  final T? value;

  @override
  Widget build(final BuildContext context) {
    DropdownMenuItem<V> itemizeRaw<V>(final V choice, final String title) =>
        DropdownMenuItem<V>(
          value: choice,
          child: Text(
            title,
            // style: TextStyle(color: Colors.white),
          ),
        );

    DropdownMenuItem<V> itemize<V extends T>(final V choice) =>
        itemizeRaw(choice, makeItem(choice));

    final List<DropdownMenuItem<T>> choices = options.map(itemize).toList();
    final DropdownMenuItem<T?> placeholderItem = itemizeRaw(null, placeholder);

    return DropdownButtonFormField<T?>(
      validator: (final T? selection) =>
          selection.fold(always("Cannot select placeholder"), validate),
      isExpanded: true,
      value: value,
      elevation: 24,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius:
              this.borderRadius ?? const BorderRadius.all(Radius.circular(4)),
        ),
      ),
      style: TextStyle(
        fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
        color: Colors.white,
        fontSize: 20,
      ),
      onChanged: (final T? selection) => selection.mapNullable(onChange),
      items: <DropdownMenuItem<T?>>[placeholderItem, ...choices],
    );
  }
}
