import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_detail_page.dart';

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
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        appBar: AppBar(title: const Text("سفارشات")),
        body: Obx(
          () => state.isLoaded()
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _filters(),
                      DataTable(
                        //
                        columns: const <DataColumn>[
                          DataColumn(label: Text("شماره سفارش")),
                          DataColumn(label: Text("فروشنده")),
                          DataColumn(label: Text("خریدار")),
                          DataColumn(label: Text("قیمت کل")),
                          DataColumn(label: Text("وضعیت")),
                        ],
                        rows: list.map(
                          (final OrderReadDto i) {
                            final Rx<TagOrder> orderTag = TagOrder.inQueue.obs;
                            // orderTag(TagOrder.values.where((final TagOrder element) => i.tags!.contains(element.number)).toList().firstOrDefault(defaultValue:TagOrder.inQueue.obs ));
                            if (i.tags!.contains(TagOrder.inQueue.number)) orderTag(TagOrder.inQueue);
                            if (i.tags!.contains(TagOrder.paid.number)) orderTag(TagOrder.paid);
                            if (i.tags!.contains(TagOrder.inProcess.number)) orderTag(TagOrder.inProcess);
                            if (i.tags!.contains(TagOrder.shipping.number)) orderTag(TagOrder.shipping);
                            if (i.tags!.contains(TagOrder.sent.number)) orderTag(TagOrder.sent);
                            if (i.tags!.contains(TagOrder.complete.number)) orderTag(TagOrder.complete);
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text((i.orderNumber?? 0).toString()).bodyMedium()),
                                DataCell(Text(i.productOwner?.fullName ?? "").bodyMedium()),
                                DataCell(Text(i.user?.fullName ?? "").bodyMedium().onTap(() {

                                  mainWidget(OrderDetailPage(orderReadDto: i).container());
                                })),
                                DataCell(Text(i.totalPrice?.toString().getPrice() ?? "").bodyLarge()),
                                DataCell(
                                  SizedBox(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 200,
                                          child: DropdownButtonFormField<TagOrder>(
                                            value: orderTag.value,
                                            items: <DropdownMenuItem<TagOrder>>[
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.inQueue,
                                                child: Text(TagOrder.inQueue.title),
                                              ),
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.paid,
                                                child: Text(TagOrder.paid.title),
                                              ),
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.inProcess,
                                                child: Text(TagOrder.inProcess.title),
                                              ),
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.shipping,
                                                child: Text(TagOrder.shipping.title),
                                              ),
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.sent,
                                                child: Text(TagOrder.sent.title),
                                              ),
                                              DropdownMenuItem<TagOrder>(
                                                value: TagOrder.complete,
                                                child: Text(TagOrder.complete.title),
                                              ),
                                            ],
                                            onChanged: (final TagOrder? value) {
                                              orderTag(value);
                                              update(dto: OrderCreateUpdateDto(id: i.id, tags: <int>[value!.number]));
                                            },
                                          ).container(width: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
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
          DropdownButtonFormField<int>(
            value: selectedOrderTag.value,
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(value: TagOrder.all.number, child: const Text("همه")),
              DropdownMenuItem<int>(value: TagOrder.paid.number, child: const Text("پرداخت شده")),
              DropdownMenuItem<int>(value: TagOrder.inProcess.number, child: const Text("درحال بررسی")),
              DropdownMenuItem<int>(value: TagOrder.shipping.number, child: const Text("در حال ارسال")),
              DropdownMenuItem<int>(value: TagOrder.sent.number, child: const Text("ارسال شده")),
              DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("تکمیل شده")),
            ],
            onChanged: selectedOrderTag,
          ).container(width: 200, margin: const EdgeInsets.all(10)),
          button(title: "فیلتر", onTap: read, width: 200),
        ],
      );

  // ignore: prefer_expression_function_bodies
  Widget dropDownWidget(final OrderReadDto i) {
    return DropdownButtonFormField<int>(
      value: selectedOrderTag.value,
      items: <DropdownMenuItem<int>>[
        const DropdownMenuItem<int>(value: 0, child: Text("همه")),
        DropdownMenuItem<int>(value: TagOrder.paid.number, child: const Text("پرداخت شده")),
        DropdownMenuItem<int>(value: TagOrder.inProcess.number, child: const Text("درحال بررسی")),
        DropdownMenuItem<int>(value: TagOrder.shipping.number, child: const Text("در حال ارسال")),
        DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("تحویل شده")),
        DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("اختلاف")),
      ],
      onChanged: selectedOrderTag,
    ).container(width: 200, margin: const EdgeInsets.all(10));
  }
}
