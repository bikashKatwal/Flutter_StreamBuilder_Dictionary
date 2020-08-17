import 'dart:async';

import 'package:dictionary_stream_example/services/fetch_api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _fetchApiService = FetchApiService();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
  }

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            48.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _fetchApiService.search(text);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => _fetchApiService.search(_controller.text),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _fetchApiService.outRespoonse,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter a search word"),
              );
            }

            if (["waiting"].contains(snapshot.data)) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (context, index) {
                  var response = snapshot.data["definitions"][index];
                  print(response);
                  return ListBody(
                    children: [
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: response["image_url"] == null
                              ? null
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(response["image_url"]),
                                ),
                          title: Text(response["type"] != null
                              ? _controller.text + " (" + response["type"] + ")"
                              : _controller.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(response["definition"]),
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
