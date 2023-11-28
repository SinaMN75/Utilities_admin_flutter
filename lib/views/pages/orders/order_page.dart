import 'package:utilities/components/pagination.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_detail_page.dart';
import 'package:utilities_admin_flutter/views/pages/users/user_create_update/user_create_update_page.dart';
import 'package:utilities_admin_flutter/views/widget/widgets.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({this.userId, super.key});

  final String? userId;

  @override
  Key? get key => const Key("سفارشات");

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with OrderController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<DataColumn> columns = <DataColumn>[
    DataColumn(label: const Text("شماره سفارش").bodyMedium().bold()),
    DataColumn(label: const Text("فروشنده").bodyMedium().bold()),
    DataColumn(label: const Text("همراه فروشنده").bodyMedium().bold()),
    DataColumn(label: const Text("خریدار").bodyMedium().bold()),
    DataColumn(label: const Text("همراه خریدار").bodyMedium().bold()),
    DataColumn(label: const Text("قیمت کل").bodyMedium().bold()),
    DataColumn(label: const Text("عملیات ها").bodyMedium().bold()),
  ];

  @override
  void initState() {
    userId = widget.userId;
    if (Core.user.tags!.contains(TagUser.adminOrderRead.number)) {
      columns.add(const DataColumn(label: Text("وضعیت")));
    }
    init();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
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
                      columns: columns,
                      rows: list.map(
                        (final OrderReadDto i) {
                          final Rx<TagOrder> orderTag = TagOrder.inProcess.obs;
                          if (i.tags!.contains(TagOrder.paid.number)) orderTag(TagOrder.paid);
                          if (i.tags!.contains(TagOrder.inProcess.number)) orderTag(TagOrder.inProcess);
                          if (i.tags!.contains(TagOrder.shipping.number)) orderTag(TagOrder.shipping);
                          if (i.tags!.contains(TagOrder.complete.number)) orderTag(TagOrder.complete);
                          if (i.tags!.contains(TagOrder.conflict.number)) orderTag(TagOrder.conflict);
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text((i.orderNumber ?? 0).toString())),
                              DataCell(Text(i.productOwner?.fullName ?? "").onTap(() => tabWidget.insert(0, UserCreateUpdatePage(dto: i.productOwner)))),
                              DataCell(Text(i.productOwner?.phoneNumber ?? "").onTap(() => tabWidget.insert(0, UserCreateUpdatePage(dto: i.productOwner)))),
                              DataCell(Text(i.user?.fullName ?? "").onTap(() => tabWidget.insert(0, UserCreateUpdatePage(dto: i.user)))),
                              DataCell(Text(i.user?.phoneNumber ?? "").onTap(() => tabWidget.insert(0, UserCreateUpdatePage(dto: i.user)))),
                              DataCell(Text(i.totalPrice?.toString().getPrice() ?? "")),
                              if (Core.user.tags!.contains(TagUser.adminOrderRead.number))
                                DataCell(
                                  SizedBox(
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 200,
                                          child: DropdownButtonFormField<TagOrder>(
                                            value: orderTag.value,
                                            items: <DropdownMenuItem<TagOrder>>[
                                              DropdownMenuItem<TagOrder>(value: TagOrder.inProcess, child: Text(TagOrder.inProcess.title)),
                                              DropdownMenuItem<TagOrder>(value: TagOrder.paid, child: Text(TagOrder.paid.title)),
                                              DropdownMenuItem<TagOrder>(value: TagOrder.shipping, child: Text(TagOrder.shipping.title)),
                                              DropdownMenuItem<TagOrder>(value: TagOrder.complete, child: Text(TagOrder.complete.title)),
                                              DropdownMenuItem<TagOrder>(value: TagOrder.conflict, child: Text(TagOrder.conflict.title))
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
                              DataCell(
                                Row(
                                  children: <Widget>[
                                    if (Core.user.tags!.contains(TagUser.adminOrderRead.number))
                                      IconButton(
                                        onPressed: () => delete(dto: i),
                                        icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                                      ).paddingSymmetric(horizontal: 8),
                                    IconButton(
                                      onPressed: () => tabWidget.insert(0, OrderDetailPage(orderReadDto: i)),
                                      icon: Icon(Icons.edit, color: context.theme.colorScheme.primary),
                                    ).paddingSymmetric(horizontal: 8),
                                  ],
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
  }

  Widget _filters() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          textField(keyboardType: TextInputType.number, hintText: "شماره پرداخت", controller: payNumberController).container(width: 200),
          textFieldUser(onUserSelected: (final UserReadDto dto) => userId = dto.id),
          DropdownButtonFormField<int>(
            value: selectedOrderTag.value,
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(value: TagOrder.all.number, child: const Text("همه")),
              DropdownMenuItem<int>(value: TagOrder.paid.number, child: const Text("پرداخت شده")),
              DropdownMenuItem<int>(value: TagOrder.inProcess.number, child: const Text("درحال بررسی")),
              DropdownMenuItem<int>(value: TagOrder.shipping.number, child: const Text("در حال ارسال")),
              DropdownMenuItem<int>(value: TagOrder.complete.number, child: const Text("تکمیل شده")),
              DropdownMenuItem<int>(value: TagOrder.conflict.number, child: const Text("اختلاف")),
            ],
            onChanged: selectedOrderTag,
          ).container(width: 200, margin: const EdgeInsets.all(10)),
          button(title: "فیلتر", onTap: read, width: 200),
        ],
      );

  Widget dropDownWidget(final OrderReadDto i) => DropdownButtonFormField<int>(
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
