import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
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
        body: Obx(
          () => state.isLoaded() ? ListView(
            children: <Widget>[
              const Text("بنر ۱"),
              image(homeBanner1?.media.imagesUrl()?.first ?? AppImages.logo, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20).onTap(createUpdateHomeBanner1),
              const Text("بنر ۲"),
              image(homeBanner2?.media.imagesUrl()?.first ?? AppImages.logo, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20).onTap(createUpdateHomeBanner2),
              const Text("بنرک ۱"),
              image(homeBannerSmall1?.media.imagesUrl()?.first ?? AppImages.logo, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20).onTap(createUpdateHomeBannerSmall1),
              const Text("بنرک ۲"),
              image(homeBannerSmall2?.media.imagesUrl()?.first ?? AppImages.logo, height: 200, fit: BoxFit.cover).paddingSymmetric(vertical: 20).onTap(createUpdateHomeBannerSmall2),
            ],
          ) : const CircularProgressIndicator(),
        ),
      );
}
