import 'package:flutter/material.dart';
import 'package:newsapp/viewmodel/bookmarks_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



class BookmarksPage extends StatelessWidget {
  static const routeName = '/bookmarks';

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMMM, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksProvider = Provider.of<BookmarksProvider>(context);

    final bookmarkedArticles = bookmarksProvider.bookmarkedArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: bookmarkedArticles.isEmpty
          ? const Center(
              child: Text('No bookmarks yet.'),
            )
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (ctx, i) {
                final article = bookmarkedArticles[i];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    leading: article.urlToImage != null
                        ? Image.network(
                            article.urlToImage!,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image),
                          )
                        : const Icon(Icons.image),
                    title: Text(article.title ?? 'No title'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.description != null)
                          Text(
                            article.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              article.sourceName ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              article.publishedAt != null
                                  ? _formatDate(article.publishedAt!)
                                  : '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        bookmarksProvider.toggleBookmark(article);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from bookmarks')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
