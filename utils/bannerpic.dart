import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/pictures_upload.dart';

// circle profile picture display
class BannerPic extends StatefulWidget {
  final double size;
  final String url;
  final String id;
  const BannerPic({
    required this.id,
    required this.size,
    required this.url,
    super.key,
  });

  @override
  State<BannerPic> createState() => _BannerPicState();
}

class _BannerPicState extends State<BannerPic> {
  late String currentPicUrl;

  @override
  void initState() {
    super.initState();
    currentPicUrl = locator.get<LocalData>().currentProfilepicUrl.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().currentBannerpicUrl,
        builder: (context, urlcurrent, __) {
          return (widget.id.contains(AuthMethods().uid))
              ? GestureDetector(
                  child: Stack(
                    children: [
                      Image.network(
                        urlcurrent,
                        fit: BoxFit.fill,
                        width: widget.size,
                        loadingBuilder: (
                          BuildContext ctx,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator(
                              color: Colors.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          }
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return Center(
                              child:
                                  Image.asset('assets/DefaultImageforapp.jpg'));
                        },
                      ),
                    ],
                  ),
                  onTap: () => pushScreenWithoutNavBar(context,
                      const Fileupload(profileorBanner: 'bannerImage')),
                )
              : urlcurrent.isNotEmpty
                  ? Image.network(
                      urlcurrent,
                      fit: BoxFit.cover,
                      loadingBuilder: (
                        BuildContext ctx,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CircularProgressIndicator(
                            color: Colors.grey,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Image.asset('assets/DefaultImageforapp.jpg');
                      },
                    )
                  : Image.asset('assets/DefaultImageforapp.jpg');
        });
  }
}

// circle profile picture display
class BannerPicSermon extends StatefulWidget {
  final double size;
  final String url;
  final String id;
  const BannerPicSermon({
    required this.id,
    required this.size,
    required this.url,
    super.key,
  });

  @override
  State<BannerPicSermon> createState() => _BannerPicStateSermon();
}

class _BannerPicStateSermon extends State<BannerPicSermon> {
  late String currentPicUrl;

  @override
  void initState() {
    super.initState();
    currentPicUrl = locator.get<LocalData>().currentProfilepicUrl.value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.url.isNotEmpty
        ? Image.network(
            widget.url,
            fit: BoxFit.fill,
            loadingBuilder: (
              BuildContext ctx,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
                return child;
              } else {
                return CircularProgressIndicator(
                  color: Colors.grey,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                );
              }
            },
            errorBuilder: (context, object, stackTrace) {
              return Image.asset('assets/DefaultImageforapp.jpg');
            },
          )
        : Image.asset('assets/DefaultImageforapp.jpg');
  }
}
