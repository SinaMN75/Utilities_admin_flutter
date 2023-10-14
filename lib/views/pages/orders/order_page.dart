import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with OrderController {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => scaffold(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        constraints: const BoxConstraints(),
        appBar: AppBar(title: const Text("سفارشات")),
        body: Obx(
          () => state.isLoaded()
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _filters(),
                      DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text("فروشنده")),
                          DataColumn(label: Text("خریدار")),
                          DataColumn(label: Text("قیمت کل")),
                        ],
                        rows: list
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
                      ).container(width: context.width),
                      Pagination(
                        numOfPages: pageCount,
                        selectedPage: pageNumber,
                        pagesVisible: pageCount,
                        onPageChanged: (final int index) {
                          pageNumber = index;
                          read();
                        },
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator().alignAtCenter(),
        ),
      );

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          textField(hintText: "عنوان", controller: controllerTitle).container(width: 200, margin: const EdgeInsets.all(10)),
          DropdownButtonFormField<int>(
            value: selectedOrderTag.value,
            items: <DropdownMenuItem<int>>[
              const DropdownMenuItem<int>(value: 0, child: Text("همه")),
              DropdownMenuItem<int>(value: TagOrder.paid.number, child: const Text("پرداخت شده")),
              DropdownMenuItem<int>(value: TagOrder.inProcess.number, child: const Text("درحال بررسی")),
              DropdownMenuItem<int>(value: TagOrder.shipping.number, child: const Text("در حال ارسال")),
              DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("تکمیل شده")),
            ],
            onChanged: selectedOrderTag,
          ).container(width: 200, margin: const EdgeInsets.all(10)),
          button(title: "فیلتر", onTap: read, width: 200),
        ],
      );
}
