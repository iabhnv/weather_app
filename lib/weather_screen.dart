import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wheather_app/additional_items.dart';
import 'package:wheather_app/forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:wheather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$api'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                weather = getCurrentWeather();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final sky = data['list'][0]['weather'][0]['main'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '$currentTemp k',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Icon(
                            sky == 'Clouds'
                                ? Icons.cloud
                                : sky == 'Rain'
                                    ? Icons.cloudy_snowing
                                    : Icons.sunny,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "$sky",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                //
                SizedBox(
                  height: 131,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);

                        return ForecastItem(
                            icon: data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        'Cloud' ||
                                    data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            time: DateFormat.j().format(time),
                            value: data['list'][index + 1]['main']['temp']
                                .toString());
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Aditional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalItems(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: data['list'][0]['main']['humidity'].toString(),
                    ),
                    AdditionalItems(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: data['list'][0]['wind']['speed'].toString(),
                    ),
                    AdditionalItems(
                      icon: Icons.compress,
                      label: 'Pressure',
                      value: data['list'][0]['main']['pressure'].toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
