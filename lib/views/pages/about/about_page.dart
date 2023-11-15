import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_controller.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  Key? get key => const Key("درباره ما");

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with AboutController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      appBar: AppBar(),
      body: Obx(
        () => state.isLoaded()
            ? Column(
                children: <Widget>[
                  textField(text: "عنوان", controller: controllerTitle),
                  textField(text: "اینستاگرام", controller: controllerInstagram),
                  textField(text: "تلگرام", controller: controllerTelegram),
                  textField(text: "واتساپ", controller: controllerWhatsapp),
                  textField(text: "شماره تماس", controller: controllerPhoneNumber),
                  textField(text: "متن", controller: controllerDescription, lines: 20, contentPadding: const EdgeInsets.all(20)),
                  button(title: "ثبت", onTap: createUpdate).paddingSymmetric(vertical: 20),
                ],
              ).scrollable()
            : const CircularProgressIndicator(),
      ),
    );
  }
}
