import 'package:flutter/material.dart';
import 'package:newsapp/model/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class BookmarksProvider with ChangeNotifier {
  List<Article> _bookmarkedArticles = [];

  List<Article> get bookmarkedArticles => _bookmarkedArticles;

  BookmarksProvider() {
    loadBookmarks();
  }

  void toggleBookmark(Article article) {
    final index = _bookmarkedArticles.indexWhere((a) => a.url == article.url);
    if (index >= 0) {
      _bookmarkedArticles.removeAt(index);
    } else {
      _bookmarkedArticles.add(article);
    }
    saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(Article article) {
    return _bookmarkedArticles.any((a) => a.url == article.url);
  }

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedArticles = _bookmarkedArticles
        .map((article) => json.encode(article.toJson()))
        .toList();
    await prefs.setStringList('bookmarks', encodedArticles);
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedArticles = prefs.getStringList('bookmarks');
    if (encodedArticles != null) {
      _bookmarkedArticles = encodedArticles
          .map((str) => Article.fromJson(json.decode(str)))
          .toList();
    }
    notifyListeners();
  }

  void removeBookmark(Article article) {
    _bookmarkedArticles.removeWhere((a) => a.url == article.url);
    saveBookmarks();
    notifyListeners();
  }
}
