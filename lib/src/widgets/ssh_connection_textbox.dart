import "package:flutter/material.dart";
import "dart:core";

enum IPType {
  wifi("10.16.90.2"),
  usb("172.22.11.2"),
  ethernet("169.254.250.182");

  const IPType(this._ipString);

  IPType increment() => this == IPType.wifi
      ? IPType.usb
      : this == IPType.usb
          ? IPType.ethernet
          : IPType.wifi;
  IconData getIcon() => this == IPType.wifi
      ? Icons.wifi
      : this == IPType.usb
          ? Icons.cable
          : Icons.settings_ethernet_rounded;
  String get ip => _ipString;
  final String _ipString;
}

class SshConnectionTextbox extends StatefulWidget {
  const SshConnectionTextbox({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function() onChanged;

  @override
  State<SshConnectionTextbox> createState() => _SshConnectionTextboxState();
}

class _SshConnectionTextboxState extends State<SshConnectionTextbox> {
  IPType ipType = IPType.wifi;

  @override
  Widget build(final BuildContext context) => Row(
        children: <Widget>[
          TextField(
            controller: widget.controller,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                ipType = ipType.increment();
                widget.controller.text = ipType.ip;
              });
            },
            icon: Icon(
              ipType.getIcon(),
            ),
          ),
        ],
      );
}
