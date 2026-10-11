import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sermons_audio/models/sermon_model.dart';
import 'package:sermons_audio/pages/HomePage/home_text_fragment.dart';
import 'package:sermons_audio/resources/firestore_path.dart';
import 'package:sermons_audio/resources/firestore_services.dart';

class SearchTextByTitle extends StatefulWidget {
  final String givenNameAuthor;
  const SearchTextByTitle({super.key, this.givenNameAuthor = ""});

  @override
  State<SearchTextByTitle> createState() => _SearchTextByTitleState();
}

class _SearchTextByTitleState extends State<SearchTextByTitle> {
  //bool? _byFilters = false;
  String _textSearch = "";
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search by title',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // 🔥 Glass gradient (dark)
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          // subtle border
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),

          // soft glow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          children: [
            buildSearchBar(),
            SizedBox(
              height: 20,
            ),
            _textSearch.isEmpty
                ? const Center(
                    child: Text(
                      'Please enter a search term to find sermons by title.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Expanded(
                    child: FirestoreListView(
                      shrinkWrap: true,
                      query: FirestoreService.instance.collectionQuery(
                          path: FirestorePath.addText(),
                          queryBuilder: (query) {
                            return query.where('sermonName',
                                isGreaterThanOrEqualTo: _textSearch);
                          }),
                      itemBuilder: (context, snapshot) {
                        final data = snapshot.data() as Map<String, dynamic>;
                        return TextDataDisplayHomePage(
                            modelData: DocumentParagraphs.fromSnap(data));
                      },
                      emptyBuilder: (context) =>
                          const Center(child: Text('No results found')),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.person_search,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: _searchTextEditingController,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _textSearch = value.toUpperCase();
                    //  _byFilters = false;
                  });
                } else {
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: widget.givenNameAuthor.isNotEmpty
                    ? widget.givenNameAuthor
                    : 'Search here ...',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
