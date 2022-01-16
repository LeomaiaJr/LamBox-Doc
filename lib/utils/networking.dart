import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = "11ebb933a8d3463a9259571160f1a19a";

class NetWorkHelper {
  Future getMyData(String address) async {
    String street = address.replaceAll(RegExp(' +'), '+');
    http.Response response = await http.get(
        "https://api.opencagedata.com/geocode/v1/json?q=$street&key=$apiKey&pretty=1&countrycode=br");

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
