class MedpardyBoardCellModel {
  final int points;
  bool isSelected;
  bool permanentSelected;

  MedpardyBoardCellModel({
    required this.points,
    this.isSelected = false,
    this.permanentSelected = false,
  });
}


class MedpardySelectedCell {
  final int col;
  final int row;

  MedpardySelectedCell({
    required this.col,
    required this.row,
  });

  // Factory method to create instance from Map<String, dynamic>
  factory MedpardySelectedCell.fromMap(Map<String, dynamic> map) {
    return MedpardySelectedCell(
      col: map['col'] as int,
      row: map['row'] as int,
    );
  }

  // Convert to Map (optional, if you want to serialize)
  Map<String, dynamic> toMap() {
    return {
      'col': col,
      'row': row,
    };
  }
}

