/// Vietnamese text helpers.
library;

const _vietnamese =
    'aàảãáạăằẳẵắặâầẩẫấậeèẻẽéẹêềểễếệiìỉĩíịoòỏõóọôồổỗốộơờởỡớợuùủũúụưừửữứựyỳỷỹýỵdđ';
const _noSign =
    'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiioooooooooooooooooouuuuuuuuuuuyyyyydd';

/// Lowercases [input] and strips Vietnamese diacritics, so accent-insensitive
/// search matches (e.g. "Đặt cọc" ↔ "dat coc"). Ported from v1.
String removeDiacritics(String input) {
  if (input.isEmpty) return input;
  var result = input.toLowerCase();
  for (var i = 0; i < _vietnamese.length; i++) {
    result = result.replaceAll(_vietnamese[i], _noSign[i]);
  }
  return result;
}
