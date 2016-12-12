function buildHTML(message) {
  var html = '<div class="chat-message__header">' +
  '<p class="chat-message__name">' + message.name +
  '<p class="chat-message__time">' + message.created_at +
  '</div>' +
  '<p class="chat-message__body">' + message.body;

  return $('<li class="chat-message">').append(html);
}

function buildALERT() {
  var html = $('.chat').before('<p class="layout-alert">メッセージを入力してください。</p>');
}

$(document).on('submit', '.new_message', function(e) {
  e.preventDefault();
  // $('.layout-alert').remove();
  var textField = $('#message_body');
  var message = textField.val();
  var url = $('.new_message').attr('action');
  $.ajax({
    type: 'POST',
    url: url + '.json',
    data: {
      message: {
        body: message
      }
    },
    dataType: 'json',
  })
  .done(function(data) {
    // メッセージの表示
    console.log(data);
    var html = buildHTML(data);
    $('.chat-messages').append(html);
    // サイドメニューのメッセージ更新処理
    $('.chat-group__link[href = "' + url + '"]').find('p.chat-group__message').text(data.body);
    textField.val('');
    $(".chat-footer__btn").prop("disabled", false);
  })
  .fail(function() {
    alert('メッセージを入力してください。');
    // buildALERT();
    $(".chat-footer__btn").prop("disabled", false);
  });
});
