import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherCard extends StatefulWidget {
  WeatherCard({
    Key key,
  }) : super(key: key);
  // getting weather data from pages.Home.dart
  // final List<Weather> data;
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

// Capitalizing Weather update String
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

// Showing Greeting
greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return Text(
      'Good Morning',
      style: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
  if (hour < 17) {
    return Text(
      'Good Afternoon',
      style: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
  return Text(
    'Good Evening',
    style: GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  );
}

class _WeatherCardState extends State<WeatherCard> {
  Position _currentPosition;
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double lat;
  double lon;
  bool _progressController = true;
  void initState() {
    super.initState();
    // _determinePosition();
    ws = new WeatherFactory(key);

    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Json1Services.getData().then((ws) {
    //     setState(() {
    //       json1 = data;
    //       isLoading = false;
    //     });
    //   });
    // });
    _getCurrentLocation();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });
// get 5 days forecast data
    List<Weather> forecasts = await ws.fiveDayForecastByLocation(
        _currentPosition.latitude, _currentPosition.longitude);

    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

// get location (lat & long)
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print("/////////////////////////////// $position");
      setState(() {
        _currentPosition = position;
        queryWeather(_currentPosition.latitude, _currentPosition.longitude);
      });
    }).catchError((e) {
      print('aaaaaaaaaa$e');
    });
  }

// geting weather (parameter is latitude and longitude)
  void queryWeather(lati, long) async {
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });
    try {
      await ws
          .currentWeatherByLocation(
              _currentPosition.latitude, _currentPosition.longitude)
          .then((weather) {
        setState(() {
          _data = [weather];
          _state = AppState.FINISHED_DOWNLOADING;
        });
      });
    } catch (e) {
      print('aaaaaaaaaa$e');
    }

    // weather.cloudiness;
    // weather.humidity;
    // weather.rainLast3Hours;
    // weather.sunrise;
    // weather.tempMax;
    // weather.tempMin;
    // weather.temperature;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == AppState.FINISHED_DOWNLOADING) {
      return Container(
          child: InkWell(
              child: Card(
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.network(
                                    "http://openweathermap.org/img/wn/${_data[0].weatherIcon}@2x.png",
                                    color: Colors.lightBlue,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "${_data[0].weatherDescription.capitalize()}",
                                    style: GoogleFonts.lato(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[greeting()],
                              ),
                            ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "${_data[0].temperature.celsius.round()}\u00B0",
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 75,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Feels Like ${_data[0].tempFeelsLike.celsius.round()} \u00B0",
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ))));
    } else {
      return CircularProgressIndicator();
    }
  }
}

//     // weather.cloudiness;
//     // weather.humidity;
//     // weather.rainLast3Hours;
//     // weather.sunrise;
//     // weather.tempMax;
//     // weather.tempMin;
//     // weather.temperature;
//   }
