(function () {
  'use strict';

  var formulario = document.querySelector('.busca');
  var campo = document.getElementById('campo-busca');
  var grade = document.querySelector('.grade-produtos');
  var status = document.getElementById('status-busca');
  var vazio = document.getElementById('busca-vazia');
  var limpar = document.getElementById('limpar-busca');

  if (!formulario || !campo || !grade) {
    return;
  }

  var itens = Array.prototype.map.call(grade.children, function (item) {
    var titulo = item.querySelector('.card__titulo');
    var texto = item.querySelector('.card__texto');
    return {
      elemento: item,
      conteudo: normalizar((titulo ? titulo.textContent : '') + ' ' + (texto ? texto.textContent : ''))
    };
  });

  function normalizar(valor) {
    return valor
      .toLowerCase()
      .normalize('NFD')
      .replace(/\p{Diacritic}/gu, '')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function filtrar() {
    var termo = normalizar(campo.value);
    var encontrados = 0;

    itens.forEach(function (item) {
      var combina = termo === '' || item.conteudo.indexOf(termo) !== -1;
      item.elemento.hidden = !combina;
      if (combina) {
        encontrados++;
      }
    });

    vazio.hidden = !(termo !== '' && encontrados === 0);

    if (termo === '') {
      status.hidden = true;
      status.textContent = '';
      return;
    }

    status.hidden = false;
    status.textContent = encontrados === 1
      ? '1 produto encontrado para "' + campo.value.trim() + '".'
      : encontrados + ' produtos encontrados para "' + campo.value.trim() + '".';
  }

  campo.addEventListener('input', filtrar);

  formulario.addEventListener('submit', function (evento) {
    evento.preventDefault();
    filtrar();
    document.getElementById('catalogo').scrollIntoView({ behavior: 'smooth', block: 'start' });
  });

  if (limpar) {
    limpar.addEventListener('click', function () {
      campo.value = '';
      filtrar();
      campo.focus();
    });
  }

  filtrar();
})();
