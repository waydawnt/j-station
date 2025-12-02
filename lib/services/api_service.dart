import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:j_station/models/radio_station.dart';

class ApiService {
  static const String radioApiUrl =
      'https://de1.api.radio-browser.info/json/stations/bycountrycodeexact/JP';

  Future<List<RadioStation>> fetchStations() async {
    try {
      final response = await http.get(Uri.parse(radioApiUrl));

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);
        return jsonData
            .map((json) => RadioStation.fromJson(json))
            .where((station) => station.urlResolved.isNotEmpty)
            .take(50)
            .toList();
      } else {
        throw Exception('Failed to load radio stations');
      }
    } catch (e) {
      rethrow;
    }
  }
}
