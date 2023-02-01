import 'package:flutter/material.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../../../../_wp_core/company_management/entities/module.dart';
import '../models/owner_dashboard_filters.dart';
import '../presenters/module_page_view_presenter.dart';
import 'hr_performance_view.dart';
import 'restaurant_performance_view.dart';
import 'retail_performance_view.dart';

class ModulesView extends StatefulWidget {
  final ModulePageViewPresenter _presenter;
  final OwnerDashboardFilters _filters;

  ModulesView(this._presenter, this._filters);

  @override
  State<ModulesView> createState() => _ModulesViewState();
}

class _ModulesViewState extends State<ModulesView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(
      vsync: this,
      length: widget._presenter.getNumberOfModules(),
      initialIndex: widget._presenter.selectedModuleIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._presenter.shouldDisplayModules()) return Container();

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
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.defaultColor,
            indicatorPadding: EdgeInsets.only(right: 10),
            isScrollable: true,
            tabs: widget._presenter.getModuleNames().map((moduleName) => Tab(text: moduleName)).toList(),
            onTap: (tabIndex) => widget._presenter.selectModuleAtIndex(tabIndex),
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 180,
          clipBehavior: Clip.none,
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: TabBarView(
            clipBehavior: Clip.none,
            controller: _tabController,
            children: widget._presenter.getModules().map((module) {
              if (module == Module.Crm) {
                return RestaurantPerformanceView(widget._filters);
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
