
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
enum QuestionCount { five, ten }

class GmGroupPlayController extends GetxController{
  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

// if(AuthData().musicONOFF) {
  await audioPlayer.play(AssetSource(sound));
// }

  }


  List<Category> categories = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null){
      categories = Get.arguments['categories'];
    }
  }

  List<int> selectedCategories = [];

  List<int> pickRandomCategoryIds(int count) {
    // Filter only free categories (paidstatus == 0)
    List<Category> tempList = categories.where((cat) => cat.paidStatus == 0).toList();
    tempList.shuffle();
    return tempList
        .take(count)
        .map((cat) => cat.id)
        .whereType<int>() // Ensures only non-null ints
        .toList();
  }

  QuestionCount selectedCount = QuestionCount.five; // default
  bool showExplanation = true;
  bool winnerTakes = false;
  bool randomMix = false;

 /* List<String> selectedCategories = ['Lub Dub Nation', 'Plastic Perception', 'Medical Pop Culture', 'Skin Deep', 'Snooze Control'];

  final List<Map<String, dynamic>> categories = [
    {'title': 'Lub Dub Nation', 'subtitle': 'Heart Health', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':false},
    {'title': 'Plastic Perception', 'subtitle': 'Beauty Meets Medicine', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800),'isLock':false},
    {'title': 'Medical Pop Culture', 'subtitle': 'Medical Scenes in Movies/Media', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373),'isLock':false},
    {'title': 'Skin Deep', 'subtitle': 'Skin, Hair & Nails', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC),'isLock':false},
    {'title': 'Snooze Control', 'subtitle': 'Sleep, Pain & Recovery', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A),'isLock':false},
    {'title': 'Mind Matters', 'subtitle': 'Mental & Emotional Health', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292),'isLock':true},

    {'title': 'Apollo Spotlight', 'subtitle': 'Shining Light on Trending Topics', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':true},
    {'title': 'Gut Feelings', 'subtitle': 'Digestive Tract & Gut Health', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800),'isLock':true},
    {'title': 'Meds & Miracles', 'subtitle': 'Cures: Past to Present', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373),'isLock':true},
    {'title': 'Globetrotters', 'subtitle': 'Staying Healthy During Travel', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC),'isLock':true},
    {'title': 'Ouch or A-Okay?', 'subtitle': 'Health Dos & Don’ts', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A),'isLock':true},
    {'title': 'EpiCenter', 'subtitle': 'From Detection to Prevention', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292),'isLock':true},

    {'title': 'Primary Focus', 'subtitle': 'Simple Health Basics', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':true},
    {'title': 'Myth vs. Fact', 'subtitle': 'Fact Check: Health Edition', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800),'isLock':true},
    {'title': 'Little Bodies', 'subtitle': 'Child Health Essentials', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373),'isLock':true},
    {'title': 'Women\'s Health', 'subtitle': 'Women\'s Wellness Guide', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC),'isLock':true},
    {'title': 'Men\'s Health', 'subtitle': 'Men\'s Wellness Guide', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A),'isLock':true},
    {'title': 'Sore Winners', 'subtitle': 'Sports Safety & Recovery', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292),'isLock':true},

    {'title': 'Neuro Nexus', 'subtitle': 'Brain Health', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':true},
    {'title': 'Infectious Intel', 'subtitle': 'All About Bugs & Vaccines', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800),'isLock':true},
    {'title': 'Gland Masters', 'subtitle': 'Hormones at Work', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373),'isLock':true},
    {'title': 'Rapid Response', 'subtitle': 'Quick Life-Saving Skills', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC),'isLock':true},
    {'title': 'Tumor Terminators', 'subtitle': 'Understanding Cancer Topics', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A),'isLock':true},
    {'title': 'Kidney Korner', 'subtitle': 'Kidney Function & Disorders', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292),'isLock':true},

    {'title': 'Golden Years', 'subtitle': 'Health in Older Adulthood', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':true},
    {'title': 'Breathe Easy', 'subtitle': 'Lung Health', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800),'isLock':true},
    {'title': 'Bone Zone', 'subtitle': 'Bone Health & Mobility', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373),'isLock':true},
    {'title': 'Joint Forces', 'subtitle': 'Joint & Immune Issues', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC),'isLock':true},
    {'title': 'Suture Society', 'subtitle': 'All About Surgeries', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A),'isLock':true},
    {'title': 'Lens Legends', 'subtitle': 'Eyesight & Eye Care', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292),'isLock':true},

    {'title': 'Rare & Remarkable', 'subtitle': 'Strange But True Cases', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3),'isLock':true},


  ];*/

}