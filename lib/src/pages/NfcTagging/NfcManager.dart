import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart' as nfc;

class NfcSendingManager extends ChangeNotifier {
  String message = '';
  bool isSending = false;

  void setMessage(String message) {
    this.message = message;
    notifyListeners();
  }

  void setIsSending(bool isSending) {
    this.isSending = isSending;
    notifyListeners();
  }

  void _ndefWrite(String token) {
    nfc.NfcManager.instance.startSession(onDiscovered: (nfc.NfcTag tag) async {
      var result;
      var ndef = nfc.Ndef.from(tag);

      if (ndef == null || !ndef.isWritable) {
        result = 'Tag is not ndef writable';
        nfc.NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      nfc.NdefMessage message =
          nfc.NdefMessage([nfc.NdefRecord.createText(token)]);

      try {
        await ndef.write(message);
        result = 'Success to "Ndef Write"';
        nfc.NfcManager.instance.stopSession();
      } catch (e) {
        result = e;
        nfc.NfcManager.instance.stopSession(errorMessage: result.toString());
        return;
      }
    });
  }
}
