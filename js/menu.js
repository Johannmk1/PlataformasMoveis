/*
 * Menu hambúrguer.
 * O CSS já esconde a navegação no mobile; aqui só alternamos a classe .aberto
 * e mantemos o aria-expanded do botão em sincronia com o que está na tela.
 */
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

  // Fecha ao escolher um link (útil no mobile, onde o menu cobre o conteúdo).
  nav.addEventListener('click', function (evento) {
    if (evento.target.closest('.nav__link')) {
      definirEstado(false);
    }
  });

  // Fecha com Esc e devolve o foco para o botão.
  document.addEventListener('keydown', function (evento) {
    if (evento.key === 'Escape' && botao.getAttribute('aria-expanded') === 'true') {
      definirEstado(false);
      botao.focus();
    }
  });
})();
