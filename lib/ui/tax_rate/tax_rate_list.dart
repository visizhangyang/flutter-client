import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/entities/entity_actions_dialog.dart';
import 'package:invoiceninja_flutter/ui/app/lists/list_divider.dart';
import 'package:invoiceninja_flutter/ui/app/loading_indicator.dart';
import 'package:invoiceninja_flutter/ui/app/help_text.dart';
import 'package:invoiceninja_flutter/ui/tax_rate/tax_rate_list_item.dart';
import 'package:invoiceninja_flutter/ui/tax_rate/tax_rate_list_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class TaxRateList extends StatelessWidget {
  const TaxRateList({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final TaxRateListVM viewModel;

  @override
  Widget build(BuildContext context) {
    /*
    final localization = AppLocalization.of(context);
    final listState = viewModel.listState;
    final filteredClientId = listState.filterEntityId;
    final filteredClient =
        filteredClientId != null ? viewModel.clientMap[filteredClientId] : null;
    */
    final store = StoreProvider.of<AppState>(context);
    final listUIState = store.state.uiState.taxRateUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();

    return Column(
      children: <Widget>[
        Expanded(
          child: !viewModel.isLoaded
              ? (viewModel.isLoading ? LoadingIndicator() : SizedBox())
              : RefreshIndicator(
                  onRefresh: () => viewModel.onRefreshed(context),
                  child: viewModel.taxRateList.isEmpty
                      ? HelpText(AppLocalization.of(context).noRecordsFound)
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => ListDivider(),
                          itemCount: viewModel.taxRateList.length,
                          itemBuilder: (BuildContext context, index) {
                            final taxRateId = viewModel.taxRateList[index];
                            final taxRate = viewModel.taxRateMap[taxRateId];
                            final userCompany = viewModel.userCompany;

                            void showDialog() => showEntityActionsDialog(
                                userCompany: userCompany,
                                entities: [taxRate],
                                context: context,
                                onEntityAction: viewModel.onEntityAction);

                            return TaxRateListItem(
                              user: viewModel.userCompany.user,
                              filter: viewModel.filter,
                              taxRate: taxRate,
                              onTap: () =>
                                  viewModel.onTaxRateTap(context, taxRate),
                              onEntityAction: (EntityAction action) {
                                if (action == EntityAction.more) {
                                  showDialog();
                                } else {
                                  viewModel.onEntityAction(
                                      context, [taxRate], action);
                                }
                              },
                              onLongPress: () async {
                                final longPressIsSelection = store.state.uiState
                                        .longPressSelectionIsDefault ??
                                    true;
                                if (longPressIsSelection && !isInMultiselect) {
                                  viewModel.onEntityAction(context, [taxRate],
                                      EntityAction.toggleMultiselect);
                                } else {
                                  showDialog();
                                }
                              },
                              isChecked: isInMultiselect &&
                                  listUIState.isSelected(taxRate.id),
                            );
                          },
                        ),
                ),
        ),

        /*
        filteredClient != null
            ? Material(
                color: Colors.orangeAccent,
                elevation: 6.0,
                child: InkWell(
                  onTap: () => viewModel.onViewEntityFilterPressed(context),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Text(
                          '${localization.filteredBy} ${filteredClient.listDisplayName}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => viewModel.onClearEntityFilterPressed(),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        Expanded(
          child: !viewModel.isLoaded
              ? LoadingIndicator()
              : RefreshIndicator(
                  onRefresh: () => viewModel.onRefreshed(context),
                  child: viewModel.taxRateList.isEmpty
                      ? HelpText(AppLocalization.of(context).noRecordsFound)
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => ListDivider(),
                          itemCount: viewModel.taxRateList.length,
                          itemBuilder: (BuildContext context, index) {
                            final user = viewModel.user;
                            final taxRateId = viewModel.taxRateList[index];
                            final taxRate = viewModel.taxRateMap[taxRateId];
                            final client =
                                viewModel.clientMap[taxRate.clientId] ??
                                    ClientEntity();


                              void showDialog() => showEntityActionsDialog(
                                  entity: taxRate,
                                  context: context,
                                  user: user,
                                  onEntityAction: viewModel.onEntityAction);



                            return TaxRateListItem(
                                 user: viewModel.user,
                                 filter: viewModel.filter,
                                 taxRate: taxRate,
                                 client:
                                     viewModel.clientMap[taxRate.clientId] ??
                                         ClientEntity(),
                                 onTap: () =>
                                     viewModel.onTaxRateTap(context, taxRate),
                                 onEntityAction: (EntityAction action) {
                                   if (action == EntityAction.more) {
                                     showDialog();
                                   } else {
                                     viewModel.onEntityAction(
                                         context, taxRate, action);
                                   }
                                 },
                                 onLongPress: () =>
                                    showDialog(),
                               );
                          },
                        ),
                ),
        ),*/
      ],
    );
  }
}