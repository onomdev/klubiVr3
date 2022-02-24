import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "https://klubiprogramimit.herokuapp.com";
  var log = Logger();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Future get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    // /user/register
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);

      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {
    url = formater(url);
    String? token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }

  CachedNetworkImageProvider getImage(String imageName) {
    String url = formater("/uploads/$imageName.jpg");
    Future<String?> token = storage.read(key: "token");
    // http.get(
    //   Uri.parse(url),
    //   headers: {"Authorization": "Bearer $token"},
    // );
    return CachedNetworkImageProvider(url,
        headers: {"Authorization": "Bearer $token"});
  }

  // Future getComments(String url) async {
  //   String? token = await storage.read(key: "token");
  //   url = baseurl + '/blog';
  //   // /user/register
  //   var response = await http.get(
  //     Uri.parse(url),
  //     headers: {"Authorization": "Bearer $token"},
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     log.i(response.body);

  //     return json.decode(response.body);
  //   }
  //   log.i(response.body);
  //   log.i(response.statusCode);
  // }

  // Future getBlogImage(String imageName) async {
  //   String? token = await storage.read(key: "token");
  //   String url = formater("/uploads/$imageName.jpg");
  //   var response = await http.get(
  //     Uri.parse(url),
  //     headers: {"Authorization": "Bearer $token"},
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     log.i(response.body);

  //     return json.decode(response.body);
  //   }
  //   log.i(response.body);
  //   log.i(response.statusCode);
  // }
}
