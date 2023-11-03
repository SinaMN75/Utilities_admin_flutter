import 'package:flutter/material.dart';
import 'package:utilities/components/components.dart';
import 'package:utilities/data/data.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';
import 'package:utilities_admin_flutter/views/pages/orders/order_controller.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({required this.orderReadDto, super.key});

  final OrderReadDto orderReadDto;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> with OrderController{

  @override
  void initState() {
    orderReadDto=widget.orderReadDto;
    readById(orderId: orderReadDto.id!);
    super.initState();
  }
  @override
  Widget build(final BuildContext context) => scaffold(body: Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          image(
              orderReadDto.user?.media.getImage()??'',
            placeholder: AppImages.profilePlaceholder,
            borderRadius: 40, //
            width: 64,
            height: 64
              ),
          // ).onTap(() => push(ProfilePage(userId: order.orderDetails?.first.product?.user?.id ?? ''))),
          const SizedBox(width: 8),
           Text(orderReadDto.user?.fullName??'').bodyMedium(fontSize: 18),
        ],
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text(orderReadDto.orderNumber?.toString()??'00').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
             Text(orderReadDto.createdAt?.toIso8601String().toJalaliDateString()??'').bodyLarge(color: context.theme.primaryColorDark.withOpacity(0.5)),
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
      const SizedBox(height: 8),//
      _address(order: orderReadDto, address: orderReadDto.address??AddressReadDto()),
      const SizedBox(height: 8),
      const Divider(height: 1),
      const SizedBox(height: 8),
      _productInfo(order: orderReadDto),
    ],
  ));

  Widget _productInfo({required final OrderReadDto order}) {
    int totalPrice = 0;
    order.orderDetails?.forEach((final OrderDetail element) {
      final int price = element.product?.price ?? 0;
      final int discount = element.product?.discountPercent ?? 0;
      final int count = element.count ?? 1;
      final double total = (price - ((discount / 100) * price)) * count;
      totalPrice = totalPrice + total.toInt();
    });

    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          const Icon(Icons.add_circle,size: 24,),
          Text( totalPrice.toString()).bodyMedium(),
        ],)
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.orderPrice), Text("963,000 تومان")]).marginSymmetric(vertical: 8),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.shippingCost), Text("0 تومان")]).marginSymmetric(vertical: 8),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.discount), Text("14,000 تومان")]).marginSymmetric(vertical: 8),
        // _price(price: totalPrice.toString(), title: s.amountPaid, color: AppColors.green),
        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(s.totalPrice), Text("${getPrice(totalPrice.toString())} ${s.toman}")]).marginSymmetric(vertical: 8),
      ],
    );
  }
  Widget _itemOrderDetail({required final int index, required final OrderDetail orderDetail}) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: screenWidth - 50,
      child: Row(
        children: <Widget>[
          Card(
            child: image(orderDetail.product?.parent?.media.getImage(tagUseCase: TagMedia.post.number) ?? '', width: 64, height: 64),
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
          Text("${orderDetail.count} عدد ").bodyMedium(color: Colors.green),
        ],
      ),
      // child: ListTile(
      //   leading: image(orderDetail.product!.parent!.media.getImage()),
      //   title: Text(orderDetail.product?.title ?? ''),
      //   subtitle: Text('${orderDetail.count} عدد'),
      //   trailing: Text("${getPrice(totalPrice.toString())} T"),
      // ),
    );

  Widget _address({required final OrderReadDto order, required final AddressReadDto address}) => Column(
    children:<Widget>  [
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget> [
          Icon(Icons.location_pin, size: 16, color: context.theme.primaryColorDark),
          const SizedBox(width: 8),
          Container(
            child: Text(
              address.address ?? '',
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ).bodyMedium(),
          ).expanded(),
        ],
      ).marginOnly(bottom: 8),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[const Icon(Icons.location_pin, size: 16, color: Colors.transparent), Text("کد پستی: ${address.postalCode}")],
          ),
          Text("پلاک:: ${address.pelak}"),
          Text("واحد: ${address.unit}"),
        ],
      ).marginSymmetric(horizontal: 8),
      const SizedBox(height: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children:  <Widget>[
              Icon(Icons.person, size: 16, color: context.theme.primaryColorDark),
              const SizedBox(width: 8),
              const Text('آدرس گیرنده: '),
              const SizedBox(width: 8),
              Text(address.receiverFullName ?? ''),
            ],
          ).marginOnly(bottom: 8),
          Row(
            children: <Widget>[
              Icon(Icons.call, size: 16, color: context.theme.primaryColorDark),
              const SizedBox(width: 8),
              const Text('شماره تماس: '),
              const SizedBox(width: 8),
              Text(address.receiverPhoneNumber ?? ''),
            ],
          )
        ],
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text("${s.postalCode}:${order.address?.postalCode ?? ''}"),
      //     Text("${s.unit}:${order.address?.unit ?? ''}"),
      //     Text("${s.plack}:${order.address?.pelak ?? ''}"),
      //   ],
      // ),
      // const SizedBox(height: 8),
      // Row(
      //   children: [Text("${s.transferee}:${Core.userReadDto?.fullName ?? ''}")],
      // ),
    ],
  );



}
