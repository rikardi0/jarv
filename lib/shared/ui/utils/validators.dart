const String emptyMessage = 'vacio';
const String shortMessage = 'corto';
const String wrongEmailMessage = 'nose';

String? emptyValidator(String value) {
  if (value.isEmpty) {
    return emptyMessage;
  }
  return null;
}