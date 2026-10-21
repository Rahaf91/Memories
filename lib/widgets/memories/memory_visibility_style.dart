import 'package:flutter/material.dart';

import '../../models/memory.dart';

extension MemoryVisibilityStyle on MemoryVisibility {
  IconData get icon => switch (this) {
    MemoryVisibility.private => Icons.lock_outline_rounded,
    MemoryVisibility.friends => Icons.groups_outlined,
    MemoryVisibility.shared => Icons.people_outline_rounded,
    MemoryVisibility.capsule => Icons.inventory_2_outlined,
  };
}
