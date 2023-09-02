import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healingapp/app/modules/audios/views/playpage.dart';
import 'package:healingapp/app/modules/stories/views/reviewmodel.dart';
import 'package:healingapp/home/controllers/home_controller.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';

class SleepMusicCard extends StatelessWidget {
  final AudiosModel music;

  const SleepMusicCard({Key? key, required this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCardClicked(context);
      },
      child: Card(
        // width: 177,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: HexColor("#597D85").withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: "${music.id}+image",
                child: CachedNetworkImage(
                  imageUrl: music.thumimage,
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white60,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const Center(
                      child: SizedBox(
                          width: 30, child: LinearProgressIndicator())),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText.normalText(
                music.title,
                fontSize: 18,
                textAlign: TextAlign.start,

                isBold: true,
                // color: const Color(0xffE6E7F2),
                color: const Color(0xffE6E7F2),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "By ${music.des}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: "Mulish",
                        color: Color(0xff98A1BD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${music.dateadd!.day}-${music.dateadd!.month}-${music.dateadd!.year}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: "Mulish",
                        color: Color(0xff98A1BD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void onCardClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlayerPage(
                model: music,
              )),
    );
  }
}

class AppText {
  static Widget normalText(
    String text, {
    double fontSize = 18,
    Color color = const Color(0xff3F414E),
    bool isBold = false,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: textAlign,
    );
  }
}
