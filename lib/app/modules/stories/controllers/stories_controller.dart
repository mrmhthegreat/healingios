import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healingapp/app/modules/stories/views/reviewmodel.dart';
import 'package:healingapp/home/views/widget/nativehelper.dart';
import 'package:story_view/story_view.dart';

class StoriesController extends GetxController {
  var myCampaignList = <StoriesModel>[].obs;
  var stories = <StoryItem>[].obs;
  var isLoading = false.obs;

  var deleteLoading = false.obs;
  final storyController = StoryController();

  setLoadingStatus(bool status) {
    isLoading.value = status;
  }

  fetchMyCampaigns() async {
    setLoadingStatus(true);

    final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection("stories")
        .orderBy('dateadd', descending: true)
        .get();
    var lit = data.docs.map((e) => StoriesModel.fromSnapshot(e)).toList();

    myCampaignList.addAll(lit);
    for (var element in myCampaignList) {
      stories.add(element.type == "text"
          ? StoryItem.text(
              title: element.text,
              backgroundColor: HexColor(element.background),
              duration: Duration(seconds: element.dur))
          : element.type == "imagetext"
              ? StoryItem.inlineImage(
                  caption: Text(element.text),
                  controller: storyController,
                  url: element.url,
                  duration: Duration(seconds: element.dur))
              : element.type == "image"
                  ? StoryItem.pageImage(
                      url: element.url,
                      controller: storyController,
                      duration: Duration(seconds: element.dur))
                  : StoryItem.pageVideo(element.url,
                      controller: storyController,
                      duration: Duration(seconds: element.dur)));
    }
    // await FirebaseFirestore.instance.collection("stories").doc().set(
    //     StoriesModel(
    //             text: "Hello World Wo2",
    //             type: "text",
    //             url: "",
    //             dur: 15,
    //             background: '#000000',
    //             userid: "My App",
    //             dateadd: DateTime.now())
    //         .toJson());
    // var lit = data.docs.map((e) => ReviewModel.fromSnapshot(e)).toList();

    // myCampaignList.addAll(lit);

    setLoadingStatus(false);
  }

  @override
  void onInit() {
    fetchMyCampaigns();
    super.onInit();
  }
}
