import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/banners/banners_controller.dart';

class BannersPage extends StatefulWidget {
  const BannersPage({super.key});

  @override
  State<BannersPage> createState() => _BannersPageState();
}

class _BannersPageState extends State<BannersPage> with BannersController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.all(20),
        appBar: AppBar(title: const Text("بنر‌ها")),
        body: ListView(
          children: <Widget>[
            const Text("بنر ۱"),
            image(Sample.loremPicsum, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20),
            const Text("بنر ۲"),
            image(Sample.loremPicsum, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20),
            const Text("بنرک ۱"),
            image(Sample.loremPicsum, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20),
            const Text("بنرک ۲"),
            image(Sample.loremPicsum, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20),
          ],
        ),
      );
}
