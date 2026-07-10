import 'dart:convert';
import 'dart:typed_data';

/// JavaScript builders for the in-contract signature panel (v1 parity).
///
/// The panel renders two columns inside the contract WebView — Bên A (with the
/// representative's signature image) and Bên B (a dashed slot the agent taps to
/// sign). Tapping the Bên B slot posts `open-sign` over the `ContractBridge`
/// channel so Flutter can open the signature dialog.
class ContractSignaturePanelJs {
  const ContractSignaturePanelJs._();

  /// Injects the panel styles + markup and wires the Bên B tap → bridge.
  static String build({
    required String repAName,
    required String repASignUrl,
    required String agentName,
  }) {
    final repA = _esc(repAName);
    final agentB = _esc(agentName);
    final signA = _esc(repASignUrl);

    return """
    (function(){
      const style = document.createElement('style');
      style.innerHTML = `
        :root{ --sig-w: 180px; --sig-h: 80px; }
        @media (max-width: 680px){ :root{ --sig-w: 150px; --sig-h: 70px; } }
        .contract-sign-panel{ background:transparent; box-sizing:border-box; margin:24px 0 12px 0; padding:16px; font-family:inherit; }
        .sp-row{ display:flex; flex-direction:row; align-items:flex-start; gap:24px; flex-wrap:nowrap; width:100%; }
        .sp-col{ flex:0 0 50%; min-width:0; text-align:center; }
        .sp-title{ font-weight:700; font-size:14px; margin:0 0 8px; }
        .sp-name{ font-weight:700; font-size:14px; margin:8px 0 0; }
        .sp-slot--A{ width:var(--sig-w); height:var(--sig-h); margin:0 auto; display:flex; align-items:center; justify-content:center; }
        .sp-slot--A img{ max-width:100%; max-height:100%; object-fit:contain; }
        .sp-slot--B{ width:var(--sig-w); height:var(--sig-h); margin:0 auto; display:flex; align-items:center; justify-content:center; border:2px dashed #ff7a37; border-radius:14px; padding:6px; background:#fafafa; cursor:pointer; user-select:none; -webkit-user-select:none; }
        .sp-slot--B img{ max-width:100%; max-height:100%; object-fit:contain; display:none; }
        .sp-placeholder{ color:#ff7a37; font-size:13px; }
      `;
      document.head.appendChild(style);

      const wrap = document.createElement('div');
      wrap.className = 'contract-sign-panel';
      wrap.innerHTML = `
        <div class="sp-row">
          <div class="sp-col">
            <div class="sp-title">ĐẠI DIỆN BÊN A</div>
            <div class="sp-slot sp-slot--A">${signA.isNotEmpty ? "<img src='$signA' alt='sign A' />" : ""}</div>
            <p class="sp-name">$repA</p>
          </div>
          <div class="sp-col">
            <div class="sp-title">ĐẠI DIỆN BÊN B</div>
            <div class="sp-slot sp-slot--B" id="__sig_b_slot">
              <img id="__sig_b_img" alt="" />
              <div id="__sig_b_empty" class="sp-placeholder">Thêm chữ ký</div>
            </div>
            <p class="sp-name" id="__sig_b_name">$agentB</p>
          </div>
        </div>`;
      document.body.appendChild(wrap);

      const pad = parseInt(getComputedStyle(document.body).paddingBottom||'0',10) || 0;
      document.body.style.paddingBottom = Math.max(pad, 24) + 'px';

      const slot = document.getElementById('__sig_b_slot');
      if (slot && window.ContractBridge && ContractBridge.postMessage) {
        slot.addEventListener('click', () => ContractBridge.postMessage('open-sign'));
      }
    })();
    """;
  }

  /// Injects the captured signature PNG into the Bên B slot and freezes it.
  static String attachSignature(Uint8List png) {
    final b64 = base64Encode(png);
    return """
    (function(){
      const img = document.getElementById('__sig_b_img');
      const empty = document.getElementById('__sig_b_empty');
      const slot = document.getElementById('__sig_b_slot');
      if (img){ img.src = 'data:image/png;base64,$b64'; img.style.display = 'block'; }
      if (empty){ empty.remove(); }
      if (slot){ slot.style.border='none'; slot.style.background='transparent'; slot.style.padding='0'; slot.style.cursor='default'; slot.style.pointerEvents='none'; }
    })();
    """;
  }

  static String _esc(String s) => s.replaceAll("'", r"\'");
}
