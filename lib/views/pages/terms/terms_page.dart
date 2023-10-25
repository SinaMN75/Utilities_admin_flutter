import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/terms/terms_controller.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> with TermsController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("قوانین و مقررات")),
        body: Column(
          children: <Widget>[
            textField(text: "عنوان", controller: controllerTitle),
            textField(text: "متن", controller: controllerDescription, lines: 20),
            const Spacer(),
            button(title: "ثبت", onTap: createUpdate),
          ],
        ),
      );
}
