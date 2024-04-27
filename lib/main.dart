import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaginaClima(),
    );
  }
}

class PaginaClima extends StatefulWidget {
  const PaginaClima({super.key});

  @override
  EstadoPaginaClima createState() => EstadoPaginaClima();
}

class EstadoPaginaClima extends State {
  double latitud = 0.0;
  double longitud = 0.0;
  Map<String, dynamic> datosClima = {};

  Future<void> obtenerDatosClima(double lat, double lon) async {
    const apiKey =
        ''; //Se omite la clave API generada para esta actividad por motivos de seguridad
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      setState(() {
        datosClima = jsonDecode(respuesta.body);
      });
    } else {
      throw Exception('Error al cargar los datos climáticos');
    }
  }

  void generarCoordenadasAleatorias() {
    final random = Random();
    setState(() {
      latitud = -90.0 + random.nextDouble() * 180.0;
      longitud = -180.0 + random.nextDouble() * 360.0;
    });
    obtenerDatosClima(latitud, longitud);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicación del Clima'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: generarCoordenadasAleatorias,
              child: const Text('Obtener Clima Aleatorio'),
            ),
            const SizedBox(height: 20),
            Text(
              'Latitud: ${latitud.toStringAsFixed(2)}\nLongitud: ${longitud.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: datosClima.length,
                itemBuilder: (BuildContext context, int index) {
                  final key = datosClima.keys.elementAt(index);
                  return ListTile(
                    title: Text('$key: ${datosClima[key]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
