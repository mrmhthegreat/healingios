class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Healing",
    image: "assets/images/1687841143896.png",
    desc:
        "Balance your mind, body, and spirit by discovering new ways of healing.",
  ),
  OnboardingContents(
    title: "Spirituality",
    image: "assets/images/1687841187292.png",
    desc:
        "The world is full of miracles, and you are part of that miraculous unfolding.",
  ),
  OnboardingContents(
    title: "Meditations",
    image: "assets/images/1687841161293.png",
    desc:
        "A series of spiritual exercises filled with wisdom, practical guidance, and profound understanding of human behavior.",
  ),
  // OnboardingContents(
  //   title: "Get notified when work happens",
  //   image: "assets/images/Spirlogo-1.png",
  //   desc:
  //       "Take control of notifications, collaborate live or on your own time.",
  // ),
];
