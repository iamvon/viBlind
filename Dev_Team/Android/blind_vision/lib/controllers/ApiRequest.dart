import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

String baseURL = 'http://52.163.230.167:6000';
String image_to_text_API = '/v1/api/predict';