part of compose;

enum ItemMutationOption {
  focus,
  select,
  create,
  remove,
  refresh,
}

class ItemMutation {
  final ItemMutationOption option;
  final CustomAnimatedContainer? currentCoordinateMapItem;

  const ItemMutation({
    required this.option,
    this.currentCoordinateMapItem,
  });

  const ItemMutation.coordinateMapItem({
    required this.option,
    required this.currentCoordinateMapItem,
  }) : assert(currentCoordinateMapItem != null);
}
