/* ================================================================
   QCM Universitaire — JavaScript global
   ================================================================ */
'use strict';

/* ── THÈME ── */
(function(){
  const dark = localStorage.getItem('qcm-dark')==='1';
  if (dark) document.body.classList.add('dark');
})();

function toggleTheme() {
  const d = document.body.classList.toggle('dark');
  localStorage.setItem('qcm-dark', d ? '1' : '0');
}

/* ── CHRONOMÈTRE (page examen) ──
   startTime et duration viennent du serveur via data-attributes.
   On stocke le temps restant en localStorage pour survivre aux F5.
*/
function initTimer(startTimeMs, durationMs) {
  const display  = document.getElementById('timer');
  const formId   = 'exam-form';
  if (!display) return;

  function tick() {
    const elapsed  = Date.now() - startTimeMs;
    const remaining = Math.max(0, Math.floor((durationMs - elapsed) / 1000));
    const m = Math.floor(remaining / 60);
    const s = remaining % 60;
    display.textContent = String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
    display.className   = 'timer' + (remaining<=300?' warn':'') + (remaining<=60?' crit':'');

    if (remaining <= 0) {
      clearInterval(tid);
      document.getElementById(formId)?.submit();
    }
  }
  tick();
  const tid = setInterval(tick, 1000);
}

/* ── PROGRESSION EXAMEN ── */
function initProgress(total) {
  const fill  = document.getElementById('prog-fill');
  const label = document.getElementById('q-prog');
  if (!fill || !label) return;

  function update() {
    let answered = 0;
    for (let i = 0; i < total; i++) {
      if (document.querySelector(`input[name="q${i}"]:checked`)) answered++;
      // Marquer la carte
      const card = document.getElementById(`qc-${i}`);
      if (card) card.classList.toggle('done', !!document.querySelector(`input[name="q${i}"]:checked`));
    }
    fill.style.width  = (answered / total * 100) + '%';
    label.textContent = answered + ' / ' + total + ' répondu' + (answered>1?'s':'');
  }

  // Écouter tous les radios
  document.querySelectorAll('input[type=radio]').forEach(r => r.addEventListener('change', update));
  update();
}

/* ── CONFIRM SOUMISSION ── */
function confirmSubmit(total) {
  let answered = 0;
  for (let i = 0; i < total; i++) {
    if (document.querySelector(`input[name="q${i}"]:checked`)) answered++;
  }
  if (answered < total) {
    return confirm(`Vous n'avez répondu qu'à ${answered}/${total} questions.\nSoumettre quand même ?`);
  }
  return true;
}

/* ── FILTRE SELECT AUTO-SUBMIT ── */
function filterSubmit(formId) {
  document.getElementById(formId)?.submit();
}
