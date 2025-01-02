import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_joystick/flutter_joystick.dart';

void main() {
  runApp(const RemoteControlApp());
}

class RemoteControlApp extends StatelessWidget {
  const RemoteControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle Remoto',
      home: QRScannerPage(),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? serverUrl;

  void _connectToServer(String url) async {
    try {
      final response = await http.post(
        Uri.parse('$url/authorize'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          serverUrl = url;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conectado ao servidor: $url')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao conectar: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
      ),
      body: serverUrl == null
          ? MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    final url = barcode.rawValue!;
                    _connectToServer(url);
                    break;
                  }
                }
              },
            )
          : RemoteControlPage(serverUrl: serverUrl!),
    );
  }
}

class RemoteControlPage extends StatefulWidget {
  final String serverUrl;

  const RemoteControlPage({required this.serverUrl});

  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  double volume = 50;

  void _sendAction(String action, Map<String, dynamic> params) async {
    try {
      final response = await http.post(
        Uri.parse('${widget.serverUrl}/$action'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(params),
      );

      if (response.statusCode != 200) {
        print('Erro: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erro ao enviar comando: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Controle Remoto'),
    ),
    body: Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Controle de Volume',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: volume,
          min: 0,
          max: 100,
          divisions: 100,
          label: volume.toStringAsFixed(0),
          onChanged: (value) {
            setState(() {
              volume = value;
            });
          },
          onChangeEnd: (value) {
            _sendAction('volume', {"action": "set", "value": value.toInt()});
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Controle do Mouse',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Joystick(
                    listener: (details) {
                      final dx = (details.x * 10).toInt();
                      final dy = (details.y * 10).toInt();
                      if (dx != 0 || dy != 0) {
                        _sendAction('mouse', {"action": "move", "x": dx, "y": dy});
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _sendAction('mouse', {"action": "click_left"});
                      },
                      child: const Text("Clique Esquerdo"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _sendAction('mouse', {"action": "click_right"});
                      },
                      child: const Text("Clique Direito"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _sendAction('mouse', {"action": "scroll", "amount": 100});
                      },
                      child: const Text("Scroll Cima"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _sendAction('mouse', {"action": "scroll", "amount": -100});
                      },
                      child: const Text("Scroll Baixo"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}

