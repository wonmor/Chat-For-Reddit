import 'package:chat_firebase/model/reddit_post.dart';
import 'package:chat_firebase/services/reddit_service.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/data.dart';
import 'package:chat_firebase/widgets/chat_item.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RedditService _redditService = RedditService();
  final TextEditingController _searchController = TextEditingController();
  List<RedditPost> _posts = [];
  bool _isLoading = true;
  String _error = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final posts = await _redditService.fetchPopularPosts(limit: 30);
    setState(() {
      _posts = posts;
      _isLoading = false;
      if (posts.isEmpty) _error = 'No posts found. Check your connection.';
    });
  }

  List<RedditPost> get _filteredPosts {
    if (_searchQuery.isEmpty) return _posts;
    final query = _searchQuery.toLowerCase();
    return _posts.where((post) =>
      post.title.toLowerCase().contains(query) ||
      post.subreddit.toLowerCase().contains(query) ||
      post.author.toLowerCase().contains(query)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildSubredditChips(),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: _loadPosts,
            icon: const Icon(Icons.refresh_rounded, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSubredditChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: defaultSubreddits.length,
        itemBuilder: (context, index) {
          final sub = defaultSubreddits[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text('r/$sub', style: const TextStyle(fontSize: 13, color: primary)),
              backgroundColor: primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide.none,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(subreddit: sub),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primary),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(_error, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadPosts,
              child: const Text('Retry', style: TextStyle(color: primary)),
            ),
          ],
        ),
      );
    }

    final posts = _filteredPosts;
    return RefreshIndicator(
      onRefresh: _loadPosts,
      color: primary,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 4),
        itemCount: posts.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 76),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
        itemBuilder: (context, index) {
          return PostItem(
            post: posts[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    subreddit: posts[index].subreddit,
                    initialPost: posts[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
