function buildHTML(message) {
  var html = '<div class="chat-message__header">' +
  '<p class="chat-message__name">' + message.name +
  '<p class="chat-message__time">' + message.created_at +
  '</div>' +
  '<p class="chat-message__body">' + message.body;

  return $('<li class="chat-message">').append(html);
}

function buildALERT(alert) {
  var html = $('.chat').before('<p class="layout-alert">' + alert + '</p>');
}

$(document).on('submit', '.new_message', function(e) {
  e.preventDefault();
  $('.layout-alert').remove();
  var textField = $('#message_body');
  var message = textField.val();
  var url = $(this).attr('action');
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
    if(data.status == 200){
      // 投稿メッセージのhtmlを生成し、画面上に表示する
      var html = buildHTML(data);
      $('.chat-messages').append(html);
      // サイドメニューの最新メッセージを更新する
      $('.chat-group__link[href = "' + url + '"]').find('p.chat-group__message').text(data.body);
    }else{
      //バリデーションエラー時のアラートメッセージを画面上に表示する
      buildALERT(data.alert);
    }
    textField.val('');
    $(".chat-footer__btn").prop("disabled", false);
  })
  .fail(function() {
    buildALERT("通信エラーが発生しました。");
    $(".chat-footer__btn").prop("disabled", false);
  });
});
