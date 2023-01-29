

import 'dart:ui';

import 'package:accordion/controllers.dart';
import 'package:iconsax/iconsax.dart';
import 'package:red_leaf/Controllers/Home/home_controller.dart';
import 'package:red_leaf/Models/data_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Plugins/neu/flutter_neumorphic.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/view_utils.dart';
import '../../Widgets/my_app_bar.dart';
import 'package:accordion/accordion.dart';

class FaqScreen extends StatelessWidget {
  final MainGetxController controller = Get.put(MainGetxController());
  final bool mainPage;
  Widget? orderId;

  FaqScreen({
    Key? key,
    this.mainPage = false,
    this.orderId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: buildBody(),
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorUtils.white,
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildBackGround(),
        SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Iconsax.user,
                color: Colors.red,
              ),
              SizedBox(width: 8.0,),

              Text(
                "سوالات متداول",
                style: TextStyle(
                    color: ColorUtils.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),




            ],
          ),
        ),

        FAQs(),
      ],
    );
  }
   Widget FAQs() {
     return Obx(() => Expanded(

       child: AnimatedSwitcher(
         duration: const Duration(milliseconds: 150),
         child: controller.dataIsLoading.isTrue
             ? Center(
           child: CircularProgressIndicator(),
         )
             :
         controller.DrawerData!.faqs.faqs.length > 0 ?
         ListView.builder(
           scrollDirection: Axis.vertical,
           itemCount: controller.DrawerData!.faqs.faqs.length,
           itemBuilder: (BuildContext context, int index) {
             return faq(index);
           },
         )
             :  Center(child: Text('سفارشی برای نمایش وجود ندارد')),
       ),
     ),
     );
   }
    Widget faq(int index) {
       var dModel = controller.DrawerData?.faqs.faqs[index];
      return Container(
        child: Accordion(
          paddingListBottom: 0,
          paddingListTop: 0,
          maxOpenSections: 1,
          headerBackgroundColor: ColorUtils.red,
          scaleWhenAnimating: false,
          openAndCloseAnimation: true,
          headerPadding:
          const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(
              contentBorderColor: ColorUtils.red,
                header: Text(dModel!.question, style: TextStyle(color: ColorUtils.white),),
                content: Text(dModel!.answer))
          ]
          ,),
      );
  }
  Widget buildBackGround() {
    return Container(
      height: Get.height / 6,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageUtils.banner,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Column(
            children: [
              buildAppBar(),
              ViewUtils.sizedBox(56),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return MyAppBar(
      title: 'سوالات متداول',
      inner: true,
    );
  }





}