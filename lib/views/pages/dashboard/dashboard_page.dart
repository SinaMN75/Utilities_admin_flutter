import 'package:utilities/data/dto/order.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/responsive.dart';
import 'package:utilities_admin_flutter/views/pages/dashboard/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with DashboardController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _header(),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    children: <Widget>[
                      _cards(),
                      const SizedBox(height: 16),
                      Obx(() => orderState.isLoaded() ? _completedOrders() : const CircularProgressIndicator().alignAtCenter()),
                      if (Responsive.isMobile()) const SizedBox(height: 16),
                      if (Responsive.isMobile()) _chart(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile()) const SizedBox(width: 16),
                if (!Responsive.isMobile()) Expanded(flex: 2, child: _chart()),
              ],
            )
          ],
        ),
      );

  Widget _header() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("داشبورد مدیریت دایرکت‌شد").titleLarge(),
          Text(Core.profile.firstName ?? "").paddingSymmetric(horizontal: 16 / 2).container(
                radius: 10,
                backgroundColor: context.theme.colorScheme.secondary.withOpacity(0.1),
                margin: const EdgeInsets.only(left: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16 / 2),
              ),
        ],
      );

  Widget _chart() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Obx(
          () => productsState.isLoaded()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("Storage Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    doughnutChart(
                      data: <DoughnutChartData>[
                        DoughnutChartData("iphone", 50),
                        DoughnutChartData("android", 30),
                        DoughnutChartData("mac", 70),
                        DoughnutChartData("windows", 120),
                      ],
                    ),
                    const Text("محصولات").headlineSmall().bold(),
                    _chartDataCard(
                      iconData: Icons.queue,
                      title: "در صف بررسی",
                      trailing: products.where((final ProductReadDto i) => i.tags!.contains(TagProduct.inQueue.number)).length.toString(),
                    ),
                    _chartDataCard(
                      iconData: Icons.done,
                      title: "منتشر شده",
                      trailing: products.where((final ProductReadDto i) => i.tags!.contains(TagProduct.released.number)).length.toString(),
                    ),
                    _chartDataCard(
                      iconData: Icons.remove,
                      title: "رد شده",
                      trailing: products.where((final ProductReadDto i) => i.tags!.contains(TagProduct.notAccepted.number)).length.toString(),
                    ),
                  ],
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );

  Widget _chartDataCard({
    required final String title,
    required final IconData iconData,
    required final String trailing,
  }) =>
      Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: context.theme.colorScheme.primary.withOpacity(0.15)),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: <Widget>[
            Icon(iconData),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis).paddingSymmetric(horizontal: 16).expanded(),
            Text(trailing),
          ],
        ),
      );

  Widget _completedOrders() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("سفارشات تکمیل شده اخیر", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 16,
                columns: const <DataColumn>[
                  DataColumn(label: Text("فروشنده")),
                  DataColumn(label: Text("خریدار")),
                  DataColumn(label: Text("قیمت کل")),
                ],
                rows: orders
                    .map(
                      (final OrderReadDto i) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(i.productOwner?.fullName ?? "").bodyMedium()),
                          DataCell(Text(i.user?.fullName ?? "").bodyMedium()),
                          DataCell(Text(i.totalPrice.toTomanMoneyPersian()).bodyMedium()),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );

  Widget _cards() => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("گزارش‌ها", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => cardsState.isLoaded()
                ? Wrap(
                    children: <Widget>[
                      _card(title: "دسته‌بندی‌ها", count: dashboardDataReadDto.categories.toString(), color: Colors.red, iconData: Icons.category_outlined),
                      _card(title: "کاربران", count: dashboardDataReadDto.users.toString(), color: Colors.blue, iconData: Icons.person_outline),
                      _card(title: "سفارشات", count: dashboardDataReadDto.orders.toString(), color: Colors.green, iconData: Icons.shopping_cart_outlined),
                      _card(title: "محصولات", count: dashboardDataReadDto.products.toString(), color: Colors.orange, iconData: Icons.dashboard_outlined),
                      _card(title: "فایل‌ها", count: dashboardDataReadDto.media.toString(), color: Colors.purple, iconData: Icons.dashboard_outlined),
                      _card(title: "تراکنش‌ها", count: dashboardDataReadDto.transactions.toString(), color: Colors.indigo, iconData: Icons.dashboard_outlined),
                      _card(title: "ریپورت‌ها", count: dashboardDataReadDto.reports.toString(), color: Colors.brown, iconData: Icons.dashboard_outlined),
                      _card(title: "آدرس‌ها", count: dashboardDataReadDto.address.toString(), color: Colors.teal, iconData: Icons.dashboard_outlined),
                    ],
                  )
                : const CircularProgressIndicator().alignAtCenter(),
          ),
        ],
      );

  Widget _card({
    required final String title,
    required final String count,
    required final Color color,
    required final IconData iconData,
  }) =>
      Container(
        width: 250,
        height: 170,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(iconData, color: color).container(padding: const EdgeInsets.all(8), backgroundColor: color.withOpacity(0.1), radius: 12),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            LinearProgressIndicator(color: color, value: 1),
            Text(count).bodySmall(color: color),
          ],
        ),
      );
}

class RecentFile {
  RecentFile({this.icon, this.title, this.date, this.size});

  final String? icon;
  final String? title;
  final String? date;
  final String? size;
}

List<RecentFile> demoRecentFiles = <RecentFile>[
  RecentFile(icon: "lib/assets/icons/xd_file.svg", title: "XD File", date: "01-03-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/Figma_file.svg", title: "Figma File", date: "27-02-2021", size: "19.0mb"),
  RecentFile(icon: "lib/assets/icons/doc_file.svg", title: "Document", date: "23-02-2021", size: "32.5mb"),
  RecentFile(icon: "lib/assets/icons/sound_file.svg", title: "Sound File", date: "21-02-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/media_file.svg", title: "Media File", date: "23-02-2021", size: "2.5gb"),
  RecentFile(icon: "lib/assets/icons/pdf_file.svg", title: "Sales PDF", date: "25-02-2021", size: "3.5mb"),
  RecentFile(icon: "lib/assets/icons/excel_file.svg", title: "Excel File", date: "25-02-2021", size: "34.5mb"),
];

class CloudStorageInfo {
  CloudStorageInfo({this.svgSrc, this.title, this.totalStorage, this.numOfFiles, this.percentage, this.color});

  final String? svgSrc;
  final String? title;
  final String? totalStorage;
  final int? percentage;
  final int? numOfFiles;
  final Color? color;
}

List<CloudStorageInfo> demoMyFiles = <CloudStorageInfo>[
  CloudStorageInfo(
    title: "Documents",
    numOfFiles: 1328,
    svgSrc: "lib/assets/icons/Documents.svg",
    totalStorage: "1.9GB",
    color: Colors.green,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Google Drive",
    numOfFiles: 1328,
    svgSrc: "lib/assets/icons/google_drive.svg",
    totalStorage: "2.9GB",
    color: const Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "One Drive",
    numOfFiles: 1328,
    svgSrc: "lib/assets/icons/one_drive.svg",
    totalStorage: "1GB",
    color: const Color(0xFFA4CDFF),
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "Documents",
    numOfFiles: 5328,
    svgSrc: "lib/assets/icons/drop_box.svg",
    totalStorage: "7.3GB",
    color: const Color(0xFF007EE5),
    percentage: 78,
  ),
];
