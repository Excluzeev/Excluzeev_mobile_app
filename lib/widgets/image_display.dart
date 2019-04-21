import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';
//import 'package:trenstop/pages/plugins/carousel_pro.dart';
//import 'package:trenstop/widgets/fullscreen_image.dart';
import 'package:trenstop/widgets/image_loader.dart';

class ImageDisplay extends StatelessWidget {
  final List<String> urls;
  final bool zoomable;
  final Function(int) onImageSlide;

  const ImageDisplay({Key key, this.urls, this.zoomable, this.onImageSlide})
      : assert(urls != null),
        super(key: key);

  _showFullscreen(BuildContext context, String url) =>
      Navigator.of(context).push(
        CupertinoPageRoute(
//          builder: (_) => FullscreenImage(url: url),
            ),
      );

  @override
  Widget build(BuildContext context) {
    return (urls.length == 1)
        ? Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox.expand(
                child: ImageLoaderWidget(url: urls.first),
              ),
              zoomable
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () => _showFullscreen(context, urls.first),
                          icon: Icon(
                            Icons.fullscreen,
                            color: Colors.grey[400],
                            size: 38.0,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        : Container();
//    Carousel(
//            onExpand: zoomable ? (position) => _showFullscreen(context, urls[position]) : null,
//            images: urls
//                .map<ImageProvider>((image) => AdvancedNetworkImage(image, useDiskCache: true))
//                .toList(),
//            dotBgColor: Colors.transparent,
//            dotColor: Colors.white,
//            expandColor: Colors.grey[400],
//            dotSize: 6.0,
//            dotIncreaseSize: 2.0,
//            dotSpacing: 20.0,
//            showIndicator: true,
//            autoplay: false,
//            autoplayDuration: Duration(seconds: 5),
//            onChanged: (position) {
//              if(onImageSlide != null ) {
//                onImageSlide(position);
//              }
//            },
//          );
  }
}
