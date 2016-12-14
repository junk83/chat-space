$(function(){
  //メッセージhtml生成関数
  function buildHTML(message) {
    var html = '<div class="chat-message__header">' +
    '<p class="chat-message__name">' + message.name +
    '<p class="chat-message__time">' + message.created_at +
    '</div>' +
    '<p class="chat-message__body">' + message.body;

    //画像が投稿されている場合はhtmlを追記
    if(message.image_url){
      html += '<br><img src=' + message.image_url + '>';
    }

    return $('<li class="chat-message">').append(html);
  }

  //アラートのフラッシュメッセージhtml生成関数
  function buildALERT(alert) {
    var html = $('.chat').before('<p class="layout-alert">' + alert + '</p>');
  }

  // メッセージ送信クロージャ
  var messageSubmit = function(e){
      e.preventDefault();
      $('.layout-alert').remove();
      var form = $('.new_message').get(0);
      var formData = new FormData(form);
      var url = $('.new_message').attr('action');
      $.ajax({
        type: 'POST',
        url: url + '.json',
        data: formData,
        processData: false,
        contentType: false,
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
        //フォームを空にする
        form.reset();
        //ボタンを有効化する
        $(".chat-footer__btn").prop("disabled", false);
      })
      .fail(function() {
        buildALERT("通信エラーが発生しました。");
        $(".chat-footer__btn").prop("disabled", false);
      });
  };

  // Sendボタンが押された場合の処理
  $(document).on('submit', '.new_message', messageSubmit);
  // ファイルが選択された場合の処理
  $(document).on('change', '#message_image', messageSubmit);

});
