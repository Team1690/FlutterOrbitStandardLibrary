import "package:flutter/material.dart";

class Switcher extends StatelessWidget {
  Switcher({
    required this.labels,
    required this.colors,
    required this.onChange,
    this.height = 70,
    required this.selected,
    required this.borderRadiusGeometry,
  });

  final List<String> labels;
  final List<Color> colors;
  final Function(int) onChange;
  final double height;
  final int selected;
  final BorderRadiusGeometry? borderRadiusGeometry;

  RoundedRectangleBorder getBorder(final int index) => RoundedRectangleBorder(
        borderRadius: index == 0
            ? const BorderRadius.horizontal(
                left: Radius.circular(20),
              )
            : index == labels.length - 1
                ? const BorderRadius.horizontal(
                    right: Radius.circular(20),
                  )
                : BorderRadius.zero,
      );

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadiusGeometry,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        width: MediaQuery.of(context).size.width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (int i = 0; i < labels.length; i++)
              Expanded(
                child: SizedBox(
                  height: height,
                  child: TextButton(
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 15,
                        color: selected == i ? colors[i] : Colors.grey[600],
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        getBorder(i),
                      ),
                      overlayColor: MaterialStateColor.resolveWith(
                        (final Set<MaterialState> states) => Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      i = i == selected ? -1 : i;
                      onChange(i);
                    },
                  ),
                ),
              ),
          ],
        ),
      );
}
