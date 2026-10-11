import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/about_file.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/methods_for_update_2026.dart';
import 'package:url_launcher/url_launcher.dart';

class GlassTabbedPage extends StatefulWidget {
  const GlassTabbedPage({super.key});

  @override
  State<GlassTabbedPage> createState() => _GlassTabbedPageState();
}

class _GlassTabbedPageState extends State<GlassTabbedPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool toggleValue = false;
  AboutFile? aboutFile;

  final List<Map<String, String>> posts = [
    {
      "author": "Edgar",
      "text": "This is a glass UI post card example.",
      "date": "Apr 12, 2026",
    },
    {
      "author": "Sofia",
      "text": "Second post in the list with scrollable content.",
      "date": "Apr 11, 2026",
    },
    {
      "author": "Michael",
      "text": "Tabs are now part of a fixed glass app bar.",
      "date": "Apr 10, 2026",
    },
  ];

  //List<String> likedTexts = locator.get<LocalData>().likedTexts.value;

  List<String> likedItems = locator.get<LocalData>().likedTexts.value;
  StreamController<List<String>> likedItemsStreamController =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get likedItemsStream =>
      likedItemsStreamController.stream;

  StreamSubscription<List<String>>? likedItemsSubscription;

  List<String> getLikedItems() {
    return List.unmodifiable(likedItems);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    likedItemsSubscription = likedItemsStream.listen((items) {
      setState(() {
        likedItems = items;
      });
    });
    aboutFile = locator.get<MethodsForUpdate2026>().aboutFile;
  }

  @override
  void dispose() {
    likedItemsSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // 🔥 GLASS APP BAR
  PreferredSizeWidget _buildGlassAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(22),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0.05),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Info",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.12),
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: "Favorites"),
                // Tab(text: "Toggle"),
                Tab(text: "About"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().likedTextsTitles,
        builder: (context, likedTitles, __) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            itemCount: likedTitles.length,
            itemBuilder: (context, index) {
              final title = likedTitles[index];
              return ListTile(
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );
        });
  }

  Widget _buildToggleTab() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 260,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Enable Option",
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: toggleValue,
                  onChanged: (value) {
                    setState(() => toggleValue = value);
                  },
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.14),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "About",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Current Version",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      locator
                          .get<MethodsForUpdate2026>()
                          .currentVersionOnDevice,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Version
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Latest Version Available",
                      style: TextStyle(color: Colors.white70),
                    ),
                    if (Platform.isAndroid)
                      Text(
                        aboutFile?.currentVersionAndroid ?? 'N/A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    if (Platform.isIOS)
                      Text(
                        aboutFile?.currentVersioniOS ?? 'N/A',
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Email
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Contact",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      aboutFile?.email ?? 'N/A',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Privacy Policy Button
                ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(aboutFile?.privacyPolicyLink ?? '');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.10),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text("Privacy Policy"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // 🔥 FIXED GLASS APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Info",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.12),
          ),
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: "Favorites"),
            // Tab(text: "Toggle"),
            Tab(text: "About"),
          ],
        ),
      ),
      //_buildGlassAppBar(),

      body: TabBarView(
        controller: _tabController,
        children: [_buildPostsTab(), _buildAboutTab()],
      ),
    );
  }
}
