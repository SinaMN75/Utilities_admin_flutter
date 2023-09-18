import 'package:utilities/utilities.dart';
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
  Widget build(final BuildContext context) => scaffold(
        constraints: const BoxConstraints(),
        appBar: AppBar(title: const Text("Welcome back!")),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _card(title: "title", count: "count", subtitle: "subtitle", icon: const Icon(Icons.add), color: Colors.red).expanded(),
                              _card(title: "title", count: "count", subtitle: "subtitle", icon: const Icon(Icons.add), color: Colors.red).expanded(),
                            ],
                          ),
                          _chart(),
                        ],
                      ).expanded(),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text("hello")),
                          DataColumn(label: Text("hello")),
                        ],
                        rows: const <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("hello")),
                              DataCell(Text("hello")),
                            ],
                          ),
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text("hello")),
                              DataCell(Text("hello")),
                            ],
                          ),
                        ],
                      ).expanded(),
                    ],
                  ),
                ],
              ),
              _products().container(width: context.width),
            ],
          ),
        ),
      );

  Widget _card({
    required final String title,
    required final String count,
    required final String subtitle,
    required final Widget icon,
    required final Color color,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title).paddingAll(8),
          Row(
            children: <Widget>[
              icon.paddingAll(8),
              Text(count).paddingAll(8),
              Text(subtitle).paddingAll(8),
            ],
          ),
        ],
      )
          .container(
            backgroundColor: color,
            radius: 12,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          );

  Widget _chart() => Container(
        child: doughnutChart(
          data: <DoughnutChartData>[
            DoughnutChartData("hello", 20),
            DoughnutChartData("hilo", 25),
            DoughnutChartData("fuck", 40),
            DoughnutChartData("apple", 100),
          ],
        ),
      ).container(borderWidth: 2);


  Widget _products() => DataTable(
    columns: const <DataColumn>[
      DataColumn(label: Text("hello")),
      DataColumn(label: Text("hello")),
    ],
    rows: const <DataRow>[
      DataRow(
        cells: <DataCell>[
          DataCell(Text("hello")),
          DataCell(Text("hello")),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(Text("hello")),
          DataCell(Text("hello")),
        ],
      ),
    ],
  );
}
