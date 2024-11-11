import "package:flutter/material.dart";

class ValidatedAutocomplete<T extends Object> extends StatelessWidget {
  const ValidatedAutocomplete({
    super.key,
    required this.optionsBuilder,
    required this.displayStringForOption,
    this.validator,
    this.decoration = const InputDecoration(),
    this.onSelected,
    required this.isUsername,
    this.textEditingController,
    this.reset,
    this.setReset,
  });

  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteOptionToString<T> displayStringForOption;
  final FormFieldValidator<T>? validator;
  final InputDecoration decoration;
  final ValueChanged<T>? onSelected;
  final bool isUsername;
  final TextEditingController? textEditingController;
  final bool? reset;
  final void Function()? setReset;

  @override
  Widget build(final BuildContext context) => FormField<T>(
        validator: validator,
        builder: (final FormFieldState<T> field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isUsername
                ? TextField(
                    controller: textEditingController,
                    onTap: () {
                      textEditingController?.clear();
                      field.didChange(null);
                    },
                    decoration: decoration.copyWith(
                      errorText: field.errorText,
                    ),
                    onChanged: (final String text) {
                      field.didChange(text as T);
                      if (onSelected != null) {
                        onSelected?.call(text as T);
                      }
                    },
                  )
                : Autocomplete<T>(
                    optionsBuilder: optionsBuilder,
                    displayStringForOption: displayStringForOption,
                    onSelected: (final T selection) {
                      field.didChange(selection);
                      if (onSelected != null) {
                        onSelected?.call(selection);
                      }
                    },
                    fieldViewBuilder: (
                      final BuildContext context,
                      final TextEditingController textEditingController,
                      final FocusNode focusNode,
                      final VoidCallback onFieldSubmitted,
                    ) {
                      if (reset == true) {
                        WidgetsBinding.instance.addPostFrameCallback((final _) {
                          textEditingController.clear();
                          field.didChange(
                            null,
                          );
                          setReset!();
                        });
                      }
                      return TextField(
                        onTap: () {
                          textEditingController.clear();
                          field.didChange(null);
                        },
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: decoration.copyWith(
                          errorText: field.errorText,
                        ),
                        onChanged: (final String text) {
                          field.didChange(
                            null,
                          ); // Reset the field value on text change
                        },
                      );
                    },
                  ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).unselectedWidgetColor,
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        ),
      );
}
