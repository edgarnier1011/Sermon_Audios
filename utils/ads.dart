// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter/material.dart';

// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({super.key});

//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   late BannerAd _bannerAd;
//   bool _isAdLoaded = false;

//   @override
//   void initState() {
//     super.initState();

//     _bannerAd = BannerAd(
//       adUnitId: //'ca-app-pub-3940256099942544/6300978111', testing

//           'ca-app-pub-1303243735652356/6466486093',
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           ad.dispose();
//         },
//       ),
//     );

//     _bannerAd.load();
//   }

//   @override
//   void dispose() {
//     _bannerAd.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isAdLoaded
//         ? Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               alignment: Alignment.center,
//               width: _bannerAd.size.width.toDouble(),
//               height: _bannerAd.size.height.toDouble(),
//               child: AdWidget(ad: _bannerAd),
//             ),
//           )
//         : const SizedBox.shrink();
//   }
// }
