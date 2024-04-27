import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State {
  // State variables
  double latitude = 0.0;
  double longitude = 0.0;
  Map<String, dynamic> weatherData = {};

  // Function to fetch weather data
  Future<void> fetchWeatherData(double lat, double lon) async {
    const apiKey = '{YOUR_API_KEY}';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Function to generate random latitude and longitude
  void generateRandomCoordinates() {
    final random = Random();
    setState(() {
      latitude = -90.0 + random.nextDouble() * 180.0;
      longitude = -180.0 + random.nextDouble() * 360.0;
    });
    fetchWeatherData(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: generateRandomCoordinates,
              child: const Text('Get Random Weather'),
            ),
            const SizedBox(height: 20),
            Text(
              'Latitude: ${latitude.toStringAsFixed(2)}\nLongitude: ${longitude.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: weatherData.length,
                itemBuilder: (BuildContext context, int index) {
                  final key = weatherData.keys.elementAt(index);
                  return ListTile(
                    title: Text('$key: ${weatherData[key]}'),
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
