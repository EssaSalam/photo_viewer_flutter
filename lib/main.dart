import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class Image {
  String remoteUrl;
  String localUrl;

  Image({required this.remoteUrl, required this.localUrl});
}

List<Image> images = [
  Image(
      remoteUrl:
      'https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg',
      localUrl: 'assets/imsages/a.png'),
  Image(
      remoteUrl:
      'https://docs.microsoft.com/en-us/windows/apps/design/controls/images/image-licorice.jpg',
      localUrl: 'assets/images/b.png'),
  Image(
      remoteUrl:
      'https://www.publicdomainpictures.net/pictures/320000/velka/background-image.png',
      localUrl: 'assets/images/c.png'),
  Image(
      remoteUrl: 'https://cdn.wallpapersafari.com/78/8/nRNy24.jpg',
      localUrl: 'assets/images/d.png'),
  Image(
      remoteUrl:
      'https://d5nunyagcicgy.cloudfront.net/external_assets/hero_examples/hair_beach_v391182663/original.jpeg',
      localUrl: 'assets/images/e.png'),
  Image(
      remoteUrl:
      'https://www.inpixio.com/remove-background/images/main-before.jpg',
      localUrl: 'assets/images/f.png'),
  Image(
      remoteUrl:
      'https://www.inpixio.com/remove-background/images/main-before.jpg',
      localUrl: 'assets/images/g.png'),
  Image(
      remoteUrl:
      'https://www.inpixio.com/remove-background/images/main-before.jpg',
      localUrl: 'assets/images/h.png'),
  Image(
      remoteUrl:
      'https://www.inpixio.com/remove-background/images/main-before.jpg',
      localUrl: 'assets/images/i.png'),
  Image(
      remoteUrl:
      'https://www.inpixio.com/remove-background/images/main-before.jpg',
      localUrl: 'assets/images/l.png'),
];

/// example app demonstrating thumbnailer plugin
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CarouselSlider(
                items: images
                    .map((e) => Dismissible(
                  direction: DismissDirection.down,
                  key: Key(e.localUrl.toString()),
                  onDismissed: (DismissDirection dir) => setState(() {
                    images.removeAt(images.indexOf(e));
                  }),
                  child: Card(
                    child: DefaultBoxImage(element: e),
                  ),
                ))
                    .toList(),
                options: CarouselOptions(
                  height: 220,
                  // enlargeCenterPage: true,
                  initialPage: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultBoxImage extends StatefulWidget {
  const DefaultBoxImage({Key? key, required this.element}) : super(key: key);
  final Image element;

  @override
  _DefaultBoxImageState createState() => _DefaultBoxImageState();
}

class _DefaultBoxImageState extends State<DefaultBoxImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.element.remoteUrl.isNotEmpty)
          Container()
        else
          Center(
            child: ElevatedButton(
              onPressed: () {
                images[images.indexOf(widget.element)].remoteUrl = 'dddddddddd';
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: Colors.white.withOpacity(0.5),
                  minimumSize: Size(50, 50)),
              child: Icon(
                Icons.download,
                color: Colors.black,
              ),
            ),
          ),
        if (widget.element.remoteUrl.isNotEmpty)
          Builder(
              builder: (ctx) => InkWell(
                onTap: () {
                  Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (_) => DefaultInteractiveImage(
                            images: images,
                            currentIndex:
                            images.indexOf(widget.element),
                          )));
                },
                child: PhotoView(
                  disableGestures: true,
                  imageProvider: AssetImage(widget.element.localUrl),
                  initialScale: PhotoViewComputedScale.covered,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            images[images.indexOf(widget.element)]
                                .localUrl = 'assets/images/a.png';
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Colors.white.withOpacity(0.5),
                              minimumSize: Size(50, 50)),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  loadingBuilder: (context, event) => Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                      ),
                    ),
                  ),
                ),
              ))
        else
          Container(),
      ],
    );
  }
}

class DefaultInteractiveImage extends StatefulWidget {
  const DefaultInteractiveImage(
      {Key? key, required this.images, this.currentIndex = 0})
      : super(key: key);
  final List<Image> images;
  final int currentIndex;

  @override
  State<DefaultInteractiveImage> createState() =>
      _DefaultInteractiveImageState();
}

class _DefaultInteractiveImageState extends State<DefaultInteractiveImage> {
  int index = 0;
  bool _isVisible = true;

  @override
  void initState() {
    this.index = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PageView(
                        scrollDirection: Axis.horizontal,
                        children: widget.images.map((e) => PhotoView(
                          imageProvider: AssetImage(e.localUrl),
                          initialScale: PhotoViewComputedScale.contained,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    images[images.indexOf(e)]
                                        .localUrl = 'assets/images/a.png';
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: Colors.white.withOpacity(0.5),
                                      minimumSize: Size(50, 50)),
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                          loadingBuilder: (context, event) => Center(
                            child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                    event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                          onTapDown: (context, details, controllerValue) {
                            _isVisible=!_isVisible;
                            setState(() {});
                          },
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.covered * 2.0,
                        ),).toList(),
                        allowImplicitScrolling: true,
                      ),
                      AnimatedContainer(
                        height: _isVisible ? 56.0 : 0.0,
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 350),
                        child: AppBar(
                          backgroundColor: Colors.black54,
                          title: Text(
                            "${index + 1} of ${widget.images.length}",
                          ),
                          centerTitle: true,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          height: _isVisible ? 56.0 : 0.0,
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 350),
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share, color: Colors.white),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
