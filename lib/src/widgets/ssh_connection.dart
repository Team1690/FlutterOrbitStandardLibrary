import "dart:io";
import "package:flutter/material.dart";
import "dart:core";

class SshConnection extends StatefulWidget {
  @override
  State<SshConnection> createState() => _SshConnectionState();
}

class _SshConnectionState extends State<SshConnection> {
  @override
  Widget build(final BuildContext context) {
    String ip = "10.16.90.2";
    int changeToCable = 0;
    String filePath = "./CSV-Files/Log.csv";
    String errorMessage = "";
    bool overwriteFile = true;
    final TextEditingController ipController = TextEditingController(text: ip);
    final TextEditingController filePathController =
        TextEditingController(text: filePath);
    bool loading = false;
    return StatefulBuilder(
      builder: (
        final BuildContext context,
        final void Function(void Function()) setState,
      ) =>
          AlertDialog(
        title: const Text("CSV file from robot"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (loading) {
                return;
              }
              setState(() {
                loading = true;
              });
              if (!overwriteFile && await File(filePath).exists()) {
                setState(() {
                  errorMessage = "That file already exists";
                  loading = false;
                });
                return;
              }
              try {
                Uri.parseIPv4Address(ip);
                setState(() {
                  errorMessage = "";
                });
              } on FormatException {
                setState(() {
                  errorMessage = "Invalid ip";
                  loading = false;
                });
                return;
              }

              if (!filePath.endsWith(".csv")) {
                setState(() {
                  filePath = "$filePath.csv";
                });
              } /*
              final Directory directoryOfFile = Directory(dirname(filePath));
              if (!(await directoryOfFile.exists())) {
                await directoryOfFile.create(recursive: true);
              }*/
              final ProcessResult res = await Process.run(
                "scp",
                <String>[
                  "-o",
                  "ConnectTimeout=5",
                  "-o",
                  "StrictHostKeyChecking=no",
                  "lvuser@$ip:~/CSV-Logs/Log.csv",
                  filePath,
                ],
              );
              if (res.exitCode != 0) {
                if (context.mounted) {
                  setState(() {
                    errorMessage = res.stderr.toString();
                    loading = false;
                  });
                }
                return;
              } /*
              Navigator.of(context).pop(
                parseCsv(
                  await readCsvFile(filePath),
                  basename(filePath),
                ),
              );*/
            },
            child: const Text("Copy from robot"),
          ),
        ],
        content: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: ipController,
                        onChanged: (final String newIp) {
                          setState(() {
                            ip = newIp;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          changeToCable = ++changeToCable % 3;
                          ip = changeToCable == 0
                              ? "10.16.90.2"
                              : changeToCable == 1
                                  ? "172.22.11.2"
                                  : "?";
                        });
                        ipController.text = ip;
                      },
                      icon: Icon(
                        changeToCable == 0
                            ? Icons.cable
                            : changeToCable == 1
                                ? Icons.wifi
                                : Icons.question_mark_sharp,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: filePathController,
                  decoration:
                      const InputDecoration(hintText: "Output directory"),
                  onChanged: (final String text) {
                    filePath = text;
                  },
                ),
                if (errorMessage.isNotEmpty)
                  Row(
                    children: <Widget>[
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            errorMessage = "";
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                Row(
                  children: <Widget>[
                    const Text("Overwrite file:"),
                    Switch(
                      value: overwriteFile,
                      onChanged: (final bool value) {
                        setState(() {
                          overwriteFile = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
