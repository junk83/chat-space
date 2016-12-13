$(function(){
  var preName;
  var preFunc;

  // 検索ユーザーリスト生成関数
  function buildUserList(users) {
    var html = '';
    $.each(users, function(index, user) {
      html += '<div class="chat-group-user clearfix">' +
      '<p class="chat-group-user__name">' + user.name + '</p>' +
      '<a class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id="' + user.id + '" data-user-name="' + user.name + '">追加</a></div>';

    });

    return html;
  }

  // 追加チャットメンバー生成関数
  function buildMemberList(id, name){
    var html = '<div class="chat-group-user clearfix" id="chat-group-user-' + id + '">' +
    '<input type="hidden" name="group[user_ids][]" value="' + id + '">' +
    '<p class="chat-group-user__name">' + name + '</p>' +
    '<a class="user-search-remove chat-group-user__btn chat-group-user__btn--remove" data-user-id="' + id + '">削除</a></div>';

    return html;
  }

  // ユーザー検索(インクリメンタルサーチ)
  $(document).on('keyup', '.chat-group-form__input',
  function() {
    var name = $(this).val();
    // ajax通信をクロージャ化して定義
    var ajaxSearch = function(){
      $.ajax({
        type: 'GET',
        url: '/users/search.json',
        data: {
          keyword: name
        },
        dataType: 'json',
      })
      .done(function(data) {
        var html = buildUserList(data);
        $('#user-search-result').html(html);
      })
      .fail(function() {
        alert("通信エラーが発生しました。");
      });
    };

    if (name != preName && name.length !== 0){
      clearTimeout(preFunc);
      preFunc = setTimeout(ajaxSearch, 500);
    }
    preName = name;
  });

  // チャットメンバー追加ボタン押下時の処理
  $(document).on('click', '.user-search-add', function(){
    var id = $(this).attr('data-user-id');
    var name = $(this).attr('data-user-name');
    $(this).parent().hide();
    var html = buildMemberList(id, name);
    $('#chat-group-users').append(html);
  });

  // チャットメンバー削除ボタン押下時の処理
  $(document).on('click', '.user-search-remove', function(){
    var id = $(this).attr('data-user-id');
    $('.user-search-add[data-user-id=' + id + ']').parent().show();
    $(this).parent().remove();
  });
});
