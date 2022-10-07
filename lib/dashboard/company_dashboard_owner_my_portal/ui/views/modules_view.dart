import 'package:flutter/material.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/hr_performance_view.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/restaurant_performance_view.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/retail_performance_view.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../models/owner_dashboard_filters.dart';
import '../presenters/module_page_view_presenter.dart';
import 'crm_performance_view.dart';

class ModulesView extends StatefulWidget {
  final OwnerDashboardFilters _filters;

  ModulesView(this._filters);

  @override
  State<ModulesView> createState() => _ModulesViewState();
}

class _ModulesViewState extends State<ModulesView> with TickerProviderStateMixin {
  final _presenter = ModulePageViewPresenter();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: _presenter.getNumberOfModules());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.defaultColor,
            labelStyle: TextStyles.titleTextStyleBold,
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.defaultColor,
            indicatorPadding: EdgeInsets.only(right: 10),
            isScrollable: true,
            tabs: _presenter.getModuleNames().map((moduleName) => Tab(text: moduleName)).toList(),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 180,
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: TabBarView(
            clipBehavior: Clip.none,
            controller: _tabController,
            children: _presenter.getModules().map((module) {
              if (module == Module.Crm) {
                return CRMPerformanceView(widget._filters);
              } else if (module == Module.Hr) {
                return HRPerformanceView(widget._filters);
              } else if (module == Module.Restaurant) {
                return RestaurantPerformanceView(widget._filters);
              } else if (module == Module.Retail) {
                return RetailPerformanceView(widget._filters);
              }
              return Container();
            }).toList(),
          ),
        ),
      ],
    );
  }
}
