import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escáner OBD2 / ELM327')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.bluetooth_connected),
              title: Text('Compatibilidad Bluetooth ELM327'),
              subtitle: Text(
                'Base preparada para integrar búsqueda de dispositivos Bluetooth, conexión al adaptador ELM327 y lectura de PIDs OBD2.',
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.rule_folder_outlined),
              title: Text('Siguiente paso sugerido'),
              subtitle: Text(
                'Integrar flujo de permisos Bluetooth/ubicación, listado de dispositivos, emparejamiento y lectura de códigos DTC específicos según protocolo soportado por la ECU de la moto.',
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('Nota importante'),
              subtitle: Text(
                'No todas las motos comercializadas en Colombia exponen datos OBD2 estándar. Puede requerirse validación por marca, año y tipo de ECU.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
