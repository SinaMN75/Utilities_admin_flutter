import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({required this.orderReadDto, super.key});

  @override
  Key? get key => Key("اطلاعات سفارش ${orderReadDto.orderNumber}");
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      constraints: const BoxConstraints(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(orderReadDto.orderNumber?.toString() ?? '00').headlineSmall(color: context.theme.primaryColorDark.withOpacity(0.5)),
              Text(orderReadDto.createdAt?.toIso8601String().toJalaliDateString() ?? '').headlineSmall(
                color: context.theme.primaryColorDark.withOpacity(0.5),
              ),
            ],
          ),
          const Divider(),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orderReadDto.orderDetails!.length,
            itemBuilder: (final BuildContext context, final int index) => _itemOrderDetail(orderDetail: orderReadDto.orderDetails![index], index: index),
          ),
          const Divider(),
          _address(order: orderReadDto, address: orderReadDto.address ?? AddressReadDto()),
          const Divider(height: 40),
          _totalPrice(order: orderReadDto),
          button(
            title: "ذخیره",
            onTap: () {
              if (Core.user.tags!.contains(TagUser.adminOrderRead.number)) {}
            },
          ).paddingSymmetric(vertical: 20),
        ],
      ),
    );
  }

  Widget _totalPrice({required final OrderReadDto order}) => Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('قیمت کل:').titleMedium(),
              Text(order.totalPrice.toTomanMoneyPersian()).titleLarge(),
            ],
          ),
        ],
      );

  Widget _itemOrderDetail({required final int index, required final OrderDetail orderDetail}) => Row(
        children: <Widget>[
          Card(child: image(orderDetail.product?.parent?.media.getImage(tag: TagMedia.post.number) ?? '', width: 64, height: 64)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(orderDetail.product?.parent?.title ?? '').bodyMedium(),
              const SizedBox(height: 8),
              Text(orderDetail.product?.price?.toString() ?? '').bodyMedium(),
            ],
          ).expanded(),
          Text("${orderDetail.count} عدد ").titleMedium(color: Colors.green).bold(),
        ],
      );

  Widget _address({required final OrderReadDto order, required final AddressReadDto address}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          iconTextHorizontal(
            leading: Icon(Icons.location_pin, color: context.theme.primaryColorDark),
            trailing: Text("آدرس: ${address.address}", maxLines: 5, overflow: TextOverflow.ellipsis).titleMedium(),
          ).paddingSymmetric(vertical: 12),
          Row(
            children: <Widget>[
              Text("کد پستی: ${address.postalCode}").titleMedium(),
              Text("پلاک: ${address.pelak}").titleMedium().paddingSymmetric(horizontal: 20),
              Text("واحد: ${address.unit}").titleMedium().paddingSymmetric(horizontal: 20),
            ],
          ).marginSymmetric(horizontal: 8),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Icon(Icons.person, color: context.theme.primaryColorDark),
              const Text('نام گیرنده: ').titleMedium().paddingSymmetric(horizontal: 8),
              Text(address.receiverFullName ?? '').titleMedium(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Icon(Icons.call, color: context.theme.primaryColorDark),
              const Text('شماره تماس: ').titleMedium().paddingSymmetric(horizontal: 8),
              Text(address.receiverPhoneNumber ?? '').titleMedium(),
            ],
          ),
        ],
      );
}
