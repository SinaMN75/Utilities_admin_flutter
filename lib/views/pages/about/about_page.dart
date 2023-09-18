import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/about/about_controller.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with AboutController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBar(title: const Text("درباره ما")),
        body: Column(
          children: <Widget>[
            textField(text: "عنوان", controller: controllerTitle),
            textField(text: "متن", controller: controllerDescription, lines: 20),
            const Spacer(),
            button(title: "ثبت", onTap: () {}),
          ],
        ),
      );
}
