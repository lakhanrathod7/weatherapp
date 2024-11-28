import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Additional_info.dart';
import 'wforcast.dart';

class Homepage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const Homepage(
      {super.key, required this.toggleTheme, required bool isDarkMode});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<Map<String, dynamic>> futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureWeatherData = getWeatherForecast();
  }

  Future<Map<String, dynamic>> getWeatherForecast() async {
    try {
      final res = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=375a6b9120875f9bad855cad616bee9f"));
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'Error occurred: ${data['message']}';
      }

      return data;
    } catch (e) {
      print('Error: $e');
      throw e.toString();
    }
  }

  void refreshWeather() {
    setState(() {
      futureWeatherData = getWeatherForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: widget.toggleTheme, // Toggle theme when pressed
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: refreshWeather,
              icon: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: futureWeatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final forecastList = data['list'];
          final currentWeatherData = forecastList[0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindspeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(19.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemp.toString()}',
                                style: TextStyle(
                                    fontSize: 45, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 68,
                              ),
                              SizedBox(height: 16),
                              Text(
                                '$currentSky',
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(5, (index) {
                      final forecast = forecastList[index];
                      final time = DateTime.fromMillisecondsSinceEpoch(
                          forecast['dt'] * 1000);
                      final temp = forecast['main']['temp'];
                      final sky = forecast['weather'][0]['main'];

                      return Forcast(
                        icon: sky == 'Clouds' ? Icons.cloud : Icons.sunny,
                        temp: temp.toString(),
                        time: '${time.hour}:${time.minute}',
                      );
                    }),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Information(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "$currentHumidity",
                    ),
                    Information(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$currentWindspeed",
                    ),
                    Information(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "$currentPressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
