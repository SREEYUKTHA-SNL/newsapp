import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/article_model.dart';
import 'dart:convert';



class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  
  bool _isLoading = false;
  String _errorMessage = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String _apiKey = 'cca89ac0338f411f916a0ceadfaaf4fb'; // Replace with your News API key
  final String _apiUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=technology';

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articlesJson = data['articles'];

        _articles = articlesJson
            .map((json) => Article.fromJson(json))
            .where((article) => article.url != null)
            .toList();
      } else {
        _errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch articles. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
