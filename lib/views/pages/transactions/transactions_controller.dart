import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/core/core.dart';

mixin TransactionsController {
  Rx<PageState> state = PageState.initial.obs;
  late String? userId;
  DateTime dateTimeStart = DateTime(2000);
  DateTime dateTimeEnd = DateTime(2030);
  final RxInt selectedTransactionTag = TagProduct.all.number.obs;
  final RxList<TransactionReadDto> list = <TransactionReadDto>[].obs;

  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerStartDate = TextEditingController();
  final TextEditingController controllerEndDate = TextEditingController();
  final TransactionDataSource _transactionDataSource = TransactionDataSource(baseUrl: AppConstants.baseUrl);

  void init() {
    if (list.isEmpty)
      filter();
    else
      state.loaded();
  }

  void filter() {
    state.loading();
    _transactionDataSource.filter(
      dto: TransactionFilterDto(
        buyerId: userId,
        sellerId: userId,
        dateTimeStart: dateTimeStart.toUtc().toIso8601String(),
        dateTimeEnd: dateTimeEnd.toUtc().toIso8601String(),
      ),
      onResponse: (final GenericResponse<TransactionReadDto> response) {
        list(response.resultList);
        state.loaded();
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void generateReport() {
    _transactionDataSource.generateReport(
      dto: TransactionFilterDto(
        buyerId: userId,
        sellerId: userId,
        dateTimeStart: dateTimeStart.toUtc().toIso8601String(),
        dateTimeEnd: dateTimeEnd.toUtc().toIso8601String(),
      ),
      onResponse: (final GenericResponse<MediaReadDto> response) {
        response.resultList?.forEach((final MediaReadDto i) {
          launchURL(i.url, mode: LaunchMode.externalApplication);
        });
      },
      onError: (final GenericResponse<dynamic> response) {},
    );
  }

  void create({required final VoidCallback action, final String? userId}) {
    final TextEditingController controllerAmount = TextEditingController();
    final TextEditingController controllerDescription = TextEditingController();
    final TextEditingController controllerRefId = TextEditingController();
    final TextEditingController controllerCardNumber = TextEditingController();
    final TextEditingController controllerUser = TextEditingController();
    final Rx<UserReadDto> selectUser = UserReadDto(id: '', jsonDetail: UserJsonDetail(), tags: <int>[]).obs;
    final UserDataSource userDataSource = UserDataSource(baseUrl: AppConstants.baseUrl);
    bottomSheet(
      child: column(
        mainAxisSize: MainAxisSize.min,
        height: 500,
        children: <Widget>[
          textField(text: "مقدار", controller: controllerAmount),
          textField(text: "توضیحات", controller: controllerDescription),
          textField(text: "کد معرف", controller: controllerRefId),
          textField(text: "شماره کارت", controller: controllerCardNumber),
          textFieldTypeAhead<UserReadDto>(
            hint: "شماره همراه کاربر",
            controller: controllerUser,
            itemBuilder: (final BuildContext context, final UserReadDto value) => Text("${value.fullName ?? ""} - ${value.appPhoneNumber}").paddingAll(16),
            suggestionsCallback: (final String value) async {
              List<UserReadDto> list = <UserReadDto>[];
              await userDataSource.filter(
                dto: UserFilterDto(query: controllerUser.text),
                onResponse: (final GenericResponse<UserReadDto> response) {
                  list = response.resultList!;
                },
                onError: (final GenericResponse<dynamic> errorResponse) {},
              );

              return list;
            },
            onSuggestionSelected: (final UserReadDto value) {
              selectUser(value);
              controllerUser.text = value.fullName!;
            },
          ).paddingSymmetric(vertical: 8),
          button(
            width: 400,
            title: "ثبت",
            onTap: () {
              showEasyLoading();
              _transactionDataSource.create(
                dto: TransactionCreateDto(
                  userId: userId ?? selectUser.value.id,
                  amount: controllerAmount.text.toInt(),
                  cardNumber: controllerCardNumber.text,
                  refId: controllerRefId.text,
                  descriptions: controllerDescription.text,
                ),
                onResponse: (final GenericResponse<TransactionReadDto> response) {
                  dismissEasyLoading();
                  back();
                  action();
                },
                onError: (final GenericResponse<dynamic> response) {
                  dismissEasyLoading();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
