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
          // メッセージ画面を一番下までスクロールする
            $('.chat-body').animate({ scrollTop: $('.chat-body')[0].scrollHeight}, 'normal');
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

  // メッセージ自動更新クロージャ
  var automaticLoad = function(){
    //urlが/groups/group_id/messagesのときのみ作動する
    if(location.pathname.match(/groups\/\d+\/messages/)){
      // 現在画面に表示されているメッセージ件数
      var messageCount = $('.chat-message').length;
      $.ajax({
        type: 'GET',
        url: location.pathname + '.json',
        dataType: 'json'
      })
      .done(function(data){
        // APIから取得したメッセージ件数が、現在画面に表示されているメッセージ件数より多い場合、htmlを生成する
        if(data.messages.length > messageCount){
          //追加されたメッセージのみループ処理する
          for (var i = messageCount; i < data.messages.length; i++) {
            var html = buildHTML(data.messages[i]);
            //メッセージを画面に表示する
            $('.chat-messages').append(html);
            // サイドメニューの最新メッセージを更新する
            $('.chat-group__link[href = "' + location.pathname + '"]').find('p.chat-group__message').text(data.messages[i].body);
          }
          // メッセージ画面を一番下までスクロールする
          $('.chat-body').animate({ scrollTop: $('.chat-body')[0].scrollHeight}, 'normal');
        }
      })
      .fail(function(){
        console.log('自動更新失敗');
      });
    }
  };

  // Sendボタンが押された場合の処理
  $(document).on('submit', '.new_message', messageSubmit);
  // ファイルが選択された場合の処理
  $(document).on('change', '#message_image', messageSubmit);

  // 自動更新処理
  setInterval(automaticLoad, 10000);

});
