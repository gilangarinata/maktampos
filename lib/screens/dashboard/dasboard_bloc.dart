import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pos_admin/screens/dashboard/dasboard_event.dart';
import 'package:pos_admin/services/responses/product_response.dart';
import 'package:pos_admin/services/responses/summary_response.dart';
import 'package:pos_admin/services/repository/dashboard_repository.dart';

import 'dashboard_state.dart';


class DashboardBloc extends Bloc<DasboardEvent, DashboardState> {
  DashboardRepository repository;

  DashboardBloc(this.repository) : super(InitialState());

  @override
  Stream<DashboardState> mapEventToState(DasboardEvent event) async* {
    if (event is GetSummary) {
      try {
        yield GetSummaryLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        SummaryResponse? items = await repository.getSummary(formattedDate);
        yield GetSummarySuccess(items: items);
      } catch (e) {
        yield FailedState("GetSummary Failed: ",0);
      }
    }

    if (event is GetSelling) {
      try {
        yield GetSellingLoading();
        var formattedDate = DateFormat("yyyy-MM-dd").format(event.date);
        List<ProductItem> items = await repository.getSellings(formattedDate);
        yield GetSellingSuccess(items: items);
      } catch (e) {
        yield FailedState("GetSummary Failed: ${e.toString()} ",0);
      }
    }
  }
}
