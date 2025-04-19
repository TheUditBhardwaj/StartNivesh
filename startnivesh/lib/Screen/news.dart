import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// App theme for consistent styling
class AppTheme {
  // Main colors
  static const Color primaryBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFF4A80F0);
  static const Color accentColorLight = Color(0xFF6E9AFF);
  static const Color errorColor = Color(0xFFE57373);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color dividerColor = Color(0xFF323232);

  // Text styles
  static const TextStyle headingLarge = TextStyle(
    color: textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    color: textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: textPrimary,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: textSecondary,
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    color: textSecondary,
    fontSize: 12,
  );

  static const TextStyle sourceTag = TextStyle(
    color: textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  final String _apiKey = 'f3e11f0539c64cb0909e3733cc56b37e';
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String _query = 'startup OR "business funding" OR "startup investment"';

  List<dynamic> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final DateTime now = DateTime.now();
      final DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final String fromDate = DateFormat('yyyy-MM-dd').format(thirtyDaysAgo);

      final response = await http.get(
        Uri.parse('$_baseUrl?q=$_query&from=$fromDate&sortBy=publishedAt&language=en&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _articles = data['articles'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load news: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching news: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Startup News', style: AppTheme.headingMedium),
        backgroundColor: AppTheme.primaryBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentColor),
            onPressed: _fetchNews,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading latest startup news...',
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
      );
    } else if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppTheme.errorColor,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: AppTheme.errorColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchNews,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              color: AppTheme.textSecondary,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No startup news found',
              style: AppTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting search criteria or check back later',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNews,
      color: AppTheme.accentColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          _buildNewsHeader(),
          const SizedBox(height: 16),
          ..._articles.map(_buildNewsItem).toList(),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildNewsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Startup Industry News',
                  style: AppTheme.headingMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Latest updates on startups, funding rounds, and investments from around the world',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.accentColorLight,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Pull down to refresh',
                style: TextStyle(
                  color: AppTheme.accentColorLight,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(dynamic article) {
    DateTime? publishedAt;
    try {
      publishedAt = DateTime.parse(article['publishedAt']);
    } catch (e) {
      publishedAt = DateTime.now();
    }

    final formattedDate = DateFormat('MMM d, yyyy').format(publishedAt);
    final source = article['source'] != null ? article['source']['name'] : 'Unknown';

    return GestureDetector(
      onTap: () => _viewArticleDetails(article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // This helps with the image overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            if (article['urlToImage'] != null && article['urlToImage'].toString().isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    article['urlToImage'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white.withOpacity(0.6),
                          size: 40,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        source,
                        style: AppTheme.sourceTag,
                      ),
                    ),
                  ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? 'No title',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (article['description'] != null)
                    Text(
                      article['description'],
                      style: AppTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (article['author'] != null)
                        Expanded(
                          child: Text(
                            'By ${article['author']}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: () => _viewArticleDetails(article),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Read'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewArticleDetails(dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? publishedAt;
    try {
      publishedAt = DateTime.parse(article['publishedAt']);
    } catch (e) {
      publishedAt = DateTime.now();
    }

    final formattedDate = DateFormat('MMMM d, yyyy • h:mm a').format(publishedAt);
    final String source = article['source'] != null ? article['source']['name'] : 'Unknown';

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderImage(),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBackground.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share),
                  color: Colors.white,
                  onPressed: () => _shareArticle(article),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentColor, width: 1),
                    ),
                    child: Text(
                      source,
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    article['title'] ?? 'No title',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author and date
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      if (article['author'] != null)
                        Expanded(
                          child: Text(
                            article['author'],
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const Divider(color: AppTheme.dividerColor, height: 32),

                  // Description
                  if (article['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        article['description'],
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),

                  // Content
                  if (article['content'] != null)
                    Text(
                      _cleanContent(article['content']),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Call to action
                  if (article['url'] != null)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(article['url']),
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Read Full Article'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onPressed: () => _shareArticle(article),
                      ),
                      _buildActionButton(
                        icon: Icons.bookmark_border,
                        label: 'Save',
                        onPressed: () => _saveArticle(article),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    if (article['urlToImage'] != null && article['urlToImage'].toString().isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            article['urlToImage'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              );
            },
          ),
          // Gradient overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: AppTheme.cardBackground,
        child: const Center(
          child: Icon(
            Icons.article,
            color: Colors.white24,
            size: 80,
          ),
        ),
      );
    }
  }

  String _cleanContent(String content) {
    final regex = RegExp(r'\[\+\d+ chars\]$');
    return content.replaceAll(regex, '').trim();
  }

  void _launchURL(String url) {
    print('Opening URL: $url');
    // In a real app, you would use url_launcher package:
    // https://pub.dev/packages/url_launcher
  }

  void _shareArticle(dynamic article) {
    print('Sharing article: ${article['title']}');
    // In a real app, you would use share package:
    // https://pub.dev/packages/share
  }

  void _saveArticle(dynamic article) {
    print('Saving article: ${article['title']}');
    // In a real app, you would save to local storage or cloud
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppTheme.accentColorLight, size: 20),
      label: Text(
        label,
        style: TextStyle(color: AppTheme.accentColorLight),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: AppTheme.accentColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppTheme.accentColor.withOpacity(0.3), width: 1),
        ),
      ),
    );
  }
}