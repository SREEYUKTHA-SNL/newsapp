// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:newsapp/model/article_model.dart';
// import 'package:newsapp/view/webview_page.dart';


// class ArticleCard extends StatelessWidget {
//   final Article article;
//   final bool isBookmarked;
//   final VoidCallback onBookmarkToggle;

//   const ArticleCard({
//     required this.article,
//     required this.isBookmarked,
//     required this.onBookmarkToggle,
//     Key? key,
//   }) : super(key: key);

//   String formatDate(String dateStr) {
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat('d MMMM, yyyy').format(date);
//     } catch (_) {
//       return dateStr;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => WebViewPage(url: article.url)),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (article.urlToImage != null)
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   article.urlToImage!,
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     article.title ?? 'No Title',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     article.description ?? 'No description available.',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         article.sourceName ?? '',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                       Text(
//                         formatDate(article.publishedAt ?? ''),
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                       icon: Icon(
//                         isBookmarked ? Icons.bookmark : Icons.bookmark_border,
//                         color: Colors.blue,
//                       ),
//                       onPressed: onBookmarkToggle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
