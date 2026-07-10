import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../data/models/property.dart';

/// Opens the correct detail screen for a list item: a project (dự án) goes to
/// the project-detail flow (`project_details.json` by project_code), a normal
/// listing goes to the BĐS property detail. Mirrors v1's item_project vs
/// item_product split.
/// [owned] = the listing belongs to the current agent (opened from "Kho tin của
/// tôi") → the detail screen hits the agent endpoint and shows agent actions.
void openProperty(BuildContext context, Property p, {bool owned = false}) {
  if (p.isProject) {
    context.push('/project-detail/${Uri.encodeComponent(p.projectCode!)}');
  } else {
    context.push('/property/${p.id}${owned ? '?owned=true' : ''}');
  }
}
