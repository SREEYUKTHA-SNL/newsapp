import 'package:flutter/material.dart';
import 'package:newsapp/view/bookmarkpage.dart';
import 'package:newsapp/view/loginpage.dart';
import 'package:newsapp/view/newsfeedpage.dart';
import 'package:newsapp/viewmodel/auth_provider.dart';
import 'package:newsapp/viewmodel/bookmarks_provider.dart';
import 'package:newsapp/viewmodel/darkmode_provider.dart';
import 'package:newsapp/viewmodel/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebViewPlatform.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarksProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // add this
      ],
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, auth, theme, _) {
          return MaterialApp(
            title: 'Flutter News App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
            themeMode: theme.currentTheme, // switch between light and dark
            home: auth.isLoggedIn ? HomePage() : LoginPage(),
          );
        },
      ),
    );
  }
}

// HomePage with TabBar
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final pages = [NewsFeedPage(), BookmarksPage()];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBody: true,
appBar: AppBar(
  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
  elevation: 2,
  centerTitle: true,
  title: _index == 0
      ? Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            readOnly: true,
            onTap: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(),
              );
            },
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Theme.of(context).hintColor),
              hintText: 'Search news...',
              border: InputBorder.none,
            ),
          ),
        )
      : const Text('Bookmarks'),
  actions: [
    IconButton(
      icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () => themeProvider.toggleTheme(),
    ),
  ],
),


      body: pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: NavigationBar(
          height: 70,
          selectedIndex: _index,
          onDestinationSelected: (index) => setState(() => _index = index),
          indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article),
              label: 'News',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
          ],
        ),
      ),
    );
  }
}
