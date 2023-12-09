import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({required this.orderReadDto, super.key});

  @override
  Key? get key => const Key("اطلاعات سفارش ها");
  final OrderReadDto orderReadDto;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> with OrderController, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    orderReadDto = widget.orderReadDto;
    readById(orderId: orderReadDto.id!);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return scaffold(
        bottomNavigationBar: button(
          title: "ذخیره",
          onTap: () {
            if (Core.user.tags!.contains(TagUser.adminOrderRead.number)) {}
          },
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                image(orderReadDto.user?.media.getImage() ?? '', placeholder: AppImages.profilePlaceholder, borderRadius: 40, width: 64, height: 64),
              const SizedBox(width: 8),
              Text(orderReadDto.user?.fullName ?? '').headlineLarge(fontSize: 18),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(orderReadDto.orderNumber?.toString() ?? '00').headlineSmall(color: context.theme.primaryColorDark.withOpacity(0.5)),
                Text(orderReadDto.createdAt?.toIso8601String().toJalaliDateString() ?? '').headlineSmall(color: context.theme.primaryColorDark.withOpacity(0.5)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orderReadDto.orderDetails!.length,
            itemBuilder: (final BuildContext context, final int index) => _itemOrderDetail(orderDetail: orderReadDto.orderDetails![index], index: index),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _address(order: orderReadDto, address: orderReadDto.address ?? AddressReadDto()),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _productInfo(order: orderReadDto),
        ],
      ));
  }

  Widget _productInfo({required final OrderReadDto order}) {
    final int totalPrice = order.totalPrice ?? 0;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('قیمت کل:').titleMedium().bold(),
            Text('${totalPrice.toString().getPrice()} تومان').titleLarge().bold(),
          ],
        ),
      ],
    );
  }

  Widget _itemOrderDetail({required final int index, required final OrderDetail orderDetail}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: screenWidth - 50,
        child: Row(
          children: <Widget>[
            Card(
              child: image(orderDetail.product?.parent?.media.getImage(tag: TagMedia.post.number) ?? '', width: 64, height: 64),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(orderDetail.product?.parent?.title ?? '').bodyMedium(),
                  const SizedBox(height: 8),
                  Text(orderDetail.product?.price?.toString() ?? '').bodyMedium(),
                ],
              ),
            ),
            Text("${orderDetail.count} عدد ").titleMedium(color: Colors.green).bold(),
          ],
        ),
      );

  Widget _address({required final OrderReadDto order, required final AddressReadDto address}) => Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.location_pin, size: 16, color: context.theme.primaryColorDark),
              const SizedBox(width: 8),
              Container(
                child: Text(
                  address.address ?? '',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ).titleMedium().bold(),
              ).expanded(),
            ],
          ).marginOnly(bottom: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.location_pin, size: 16, color: Colors.transparent),
                  Text("کد پستی: ${address.postalCode}").titleMedium().bold(),
                ],
              ),
              Text("پلاک:: ${address.pelak}").titleMedium().bold(),
              Text("واحد: ${address.unit}").titleMedium().bold(),
            ],
          ).marginSymmetric(horizontal: 8),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.person, size: 32, color: context.theme.primaryColorDark),
                  const SizedBox(width: 8),
                  const Text('نام گیرنده: ').titleMedium().bold(),
                  const SizedBox(width: 8),
                  Text(address.receiverFullName ?? '').titleSmall().bold(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Icon(Icons.call, size: 32, color: context.theme.primaryColorDark),
                  const SizedBox(width: 8),
                  const Text('شماره تماس: ').titleMedium().bold(),
                  const SizedBox(width: 8),
                  Text(address.receiverPhoneNumber ?? '').titleSmall().bold(),
                ],
              )
            ],
          ),
        ],
      );
}
