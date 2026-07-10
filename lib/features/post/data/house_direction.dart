/// The 8 fixed compass directions used for house / balcony / land direction
/// pickers (matches v1's HouseDirection). [label] is the value sent to the API.
enum HouseDirection {
  dong('Đông'),
  tay('Tây'),
  nam('Nam'),
  bac('Bắc'),
  dongBac('Đông Bắc'),
  dongNam('Đông Nam'),
  tayBac('Tây Bắc'),
  tayNam('Tây Nam');

  const HouseDirection(this.label);
  final String label;
}
