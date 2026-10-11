import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sermons_audio/resources/auth_methods.dart';
import 'package:sermons_audio/resources/global.dart';
import 'package:sermons_audio/resources/local_data.dart';
import 'package:sermons_audio/resources/pictures_upload.dart';

// circle profile picture display
class ProfilePic extends StatefulWidget {
  final double size;
  final String url;
  final String id;
  final bool allowChange;
  const ProfilePic({
    this.allowChange = true,
    required this.id,
    required this.size,
    required this.url,
    super.key,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late String currentPicUrl;

  @override
  void initState() {
    super.initState();
    if (AuthMethods().uid.isNotEmpty) {
      currentPicUrl = locator.get<LocalData>().currentProfilepicUrl.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: locator.get<LocalData>().currentProfilepicUrl,
        builder: (context, urlcurrent, __) {
          return (widget.id.contains(AuthMethods().uid) && widget.allowChange)
              ? GestureDetector(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          urlcurrent,
                          fit: BoxFit.cover,
                          width: widget.size,
                          height: widget.size,
                          loadingBuilder: (
                            BuildContext ctx,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return SizedBox(
                                width: widget.size,
                                height: widget.size,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  size: widget.size,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: widget.size * 0.45),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () => pushScreenWithoutNavBar(context,
                      const Fileupload(profileorBanner: 'profileImage')),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: urlcurrent.isNotEmpty
                      ? Image.network(
                          urlcurrent,
                          fit: BoxFit.cover,
                          width: widget.size,
                          height: widget.size,
                          loadingBuilder: (
                            BuildContext ctx,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return SizedBox(
                                width: widget.size,
                                height: widget.size,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: widget.size,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: widget.size,
                        ));
        });
  }
}

class ProfilePicSermon extends StatefulWidget {
  final double size;

  const ProfilePicSermon({
    required this.size,
    super.key,
  });

  @override
  State<ProfilePicSermon> createState() => _ProfilePicStateSermon();
}

class _ProfilePicStateSermon extends State<ProfilePicSermon> {
  late String currentPicUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          'assets/defaultpic.png',
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
          errorBuilder: (context, object, stackTrace) {
            return Icon(
              Icons.account_circle,
              size: widget.size,
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              wasSynchronouslyLoaded
                  ? child
                  : AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      child: child,
                    ),
        ));
  }
}

// circle profile picture display
class ProfilePicChat extends StatelessWidget {
  final double size;
  final String url;
  const ProfilePicChat({
    required this.size,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: size,
              height: size,
              loadingBuilder: (
                BuildContext ctx,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, object, stackTrace) {
                return Icon(
                  Icons.account_circle,
                  size: size,
                );
              },
            ),
          )
        : Icon(
            Icons.account_circle,
            size: size,
          );
  }
}
