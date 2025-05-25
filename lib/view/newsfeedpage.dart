import 'package:flutter/material.dart';
import 'package:newsapp/view/webview_page.dart';
import 'package:newsapp/viewmodel/bookmarks_provider.dart';
import 'package:newsapp/viewmodel/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsFeedPage extends StatefulWidget {
  static const routeName = '/news';

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late NewsProvider _newsProvider;

  @override
  void initState() {
    super.initState();
    _newsProvider = Provider.of<NewsProvider>(context, listen: false);
    _newsProvider.fetchArticles();
  }

  Future<void> _refreshArticles() async {
    await _newsProvider.fetchArticles();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  void _openArticleWebView(BuildContext context, String? url) {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article URL is not available')),
      );
      return;
    }

    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 News Feed'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProv, _) {
          if (newsProv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (newsProv.errorMessage.isNotEmpty) {
            return Center(child: Text(newsProv.errorMessage));
          }
          if (newsProv.articles.isEmpty) {
            return const Center(child: Text('No articles available.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshArticles,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: newsProv.articles.length,
              itemBuilder: (ctx, i) {
                final article = newsProv.articles[i];

              return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (article.url.toString().isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  webview_page(url: article.url.toString()),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid Url')));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: article.urlToImage != null
                                ? Image.network(
                                    article.urlToImage!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey.shade300,
                                      height: 100,
                                      width: 100,
                                      child: const Icon(Icons.broken_image,
                                          size: 40),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title ?? 'No title',
                                  // style: theme.textTheme.subtitle1?.copyWith(
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                ),
                                const SizedBox(height: 6),
                                if (article.description != null)
                                  Text(
                                    article.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    //  style: theme.textTheme.bodyText2,
                                  ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article.sourceName ?? '',
                                      // style: theme.textTheme.caption?.copyWith(
                                      //   fontWeight: FontWeight.w600,
                                      // ),
                                    ),
                                    Text(
                                      article.publishedAt != null
                                          ? _formatDate(article.publishedAt!)
                                          : '',
                                      // style: theme.textTheme.caption?.copyWith(
                                      //   color: Colors.grey,
                                      // ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Consumer<BookmarksProvider>(
                            builder: (context, bookmarksProvider, _) {
                              final isBookmarked =
                                  bookmarksProvider.isBookmarked(article);
                              return IconButton(
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  color:
                                      isBookmarked ? Colors.blue : Colors.grey,
                                ),
                                onPressed: () =>
                                    bookmarksProvider.toggleBookmark(article),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
class NewsSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search news...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final results = newsProvider.articles
        .where((article) => article.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        return ListTile(
          title: Text(article.title!),
          subtitle: Text(article.description ?? ''),
          onTap: () {
            // Navigate to article detail page if implemented
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final suggestions = newsProvider.articles
        .where((article) => article.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        return ListTile(
          title: Text(article.title!),
          onTap: () {
            query = article.title!;
            showResults(context);
          },
        );
      },
    );
  }
}
