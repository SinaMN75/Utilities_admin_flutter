import 'package:utilities/components/pagination.dart';
import 'package:utilities/data/dto/order.dart';
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          textField(hintText: "عنوان", controller: controllerTitle).paddingAll(12).expanded(),
                          DropdownButton<int>(
                            underline: const SizedBox(),
                            value: selectedProductTag.value,
                            items: <DropdownMenuItem<int>>[
                              const DropdownMenuItem<int>(value: 0, child: Text("همه")),
                              DropdownMenuItem<int>(value: TagOrder.paid.number, child: const Text("پرداخت شده")),
                              DropdownMenuItem<int>(value: TagOrder.inProcess.number, child: const Text("درحال بررسی")),
                              DropdownMenuItem<int>(value: TagOrder.shipping.number, child: const Text("در حال ارسال")),
                              DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("تکمیل شده")),
                            ],
                            onChanged: selectedProductTag,
                          ).paddingAll(12).expanded(),
                        ],
                      ),
                      button(title: "فیلتر", onTap: read),
                      const SizedBox(height: 20),
                      DataTable(
                        columnSpacing: 16,
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
}
