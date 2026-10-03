(function () {
  'use strict';

  var botao = document.querySelector('.menu-hamburguer');
  var nav = document.getElementById('nav-principal');

  if (!botao || !nav) {
    return;
  }

  function definirEstado(aberto) {
    nav.classList.toggle('aberto', aberto);
    botao.setAttribute('aria-expanded', String(aberto));
  }

  botao.addEventListener('click', function () {
    var aberto = botao.getAttribute('aria-expanded') === 'true';
    definirEstado(!aberto);
  });

  nav.addEventListener('click', function (evento) {
    if (evento.target.closest('.nav__link')) {
      definirEstado(false);
    }
  });

  document.addEventListener('keydown', function (evento) {
    if (evento.key === 'Escape' && botao.getAttribute('aria-expanded') === 'true') {
      definirEstado(false);
      botao.focus();
    }
  });
})();
