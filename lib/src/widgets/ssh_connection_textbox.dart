import "package:flutter/material.dart";
import "dart:core";

enum IPType {
  wifi("10.16.90.2", Icons.wifi),
  usb("172.22.11.2", Icons.cable),
  ethernet("169.254.250.182", Icons.settings_ethernet_rounded);

  const IPType(
    this.ip,
    this.icon,
  );

  IPType increment() => switch (this) {
        IPType.ethernet => IPType.usb,
        IPType.usb => IPType.wifi,
        IPType.wifi => IPType.ethernet
      };
  final String ip;
  final IconData icon;
}

class IPTextbox extends StatefulWidget {
  const IPTextbox({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function([String]) onChanged;

  @override
  State<IPTextbox> createState() => _IPTextboxState();
}

class _IPTextboxState extends State<IPTextbox> {
  IPType ipType = IPType.wifi;

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                ipType = ipType.increment();
                widget.controller.text = ipType.ip;
              });
            },
            icon: Icon(
              ipType.icon,
            ),
          ),
        ],
      );
}
