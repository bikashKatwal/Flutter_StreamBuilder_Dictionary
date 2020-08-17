import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class FetchApiService {
  String _token = "70e9970a4ef27a31e671634f825c6a051efdfbc6";
  String _url = "https://owlbot.info/api/v4/dictionary/";

  StreamController _streamController = StreamController();

  Stream get outRespoonse => _streamController.stream;

  search(String searchText) async {
    if (searchText == null || searchText.length <= 1) {
      _streamController.add(null);
      return;
    }
    _streamController.add("waiting");
    Response response = await get(_url + searchText.trim(),
        headers: {"Authorization": 'Token $_token'});
    _streamController.add(json.decode(response.body));
  }
}
