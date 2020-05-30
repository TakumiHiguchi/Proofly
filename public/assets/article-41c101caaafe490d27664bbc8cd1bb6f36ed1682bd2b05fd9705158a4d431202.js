//
//
//  カテゴリー
//
//
$(function(){
    $('.catem').css('display','none');
    $('.open-cate').on('click',function(){
        $('.catem').fadeIn();
        
        return false;
    });
    $('.close-cate').on('click',function(){
        $('.catem').fadeOut();
        
        return false;
    });
});

$(function () {
  $('.ca').click(function() {
    var checked_length = $('.ca:checked').length;

    // 選択上限は3つまで
    if (checked_length >= 3) {
      $('.ca:not(:checked)').prop('disabled', true);
    } else {
      $('.ca:not(:checked)').prop('disabled', false);
    }
  });
});
//
//
//  タグ
//
//
$(function(){
    $('.tagm').css('display','none');
    $('.open-tag').on('click',function(){
        $('.tagm').fadeIn();
        
        return false;
    });
    $('.close-tag').on('click',function(){
        $('.tagm').fadeOut();
        
        return false;
    });
});
//
//
//  sale
//
//
$(function(){
    //入力時有料部分保存
    $('.salem').css('display','none');
    $('.open-sale').on('click',function(){
        $('.salem').fadeIn();
        if($('input[name="sale"]:checked').val() == 1){
            if($('.fr-element div.paid').length && $('.fr-element div.paid-end').length){
                $('.ifpaid').fadeIn();
                
                var paid = $('.fr-element').html().match(/<div class="paid">ここから有料部分<\/div>(.*?)<div class="paid-end">ここまで有料部分<\/div>/)[0].replace(/<div class="paid">ここから有料部分<\/div>/g, '').replace(/<div class="paid-end">ここまで有料部分<\/div>/g, '');
                $('.def').html(paid);
            }
        }
        return false;
    });
    $('.close-sale').on('click',function(){
        $('.salem').fadeOut();
        $('.ec').fadeOut();
        return false;
    });
    
    //ラジオボタン
    $( 'input[name="sale"]:radio' ).change( function() {
        if($(this).val() == 0){
            $('.ifpaid').fadeOut();
            $('.ec').fadeOut();
        }else if($(this).val() == 1){
            if($('.fr-element div.paid').length && $('.fr-element div.paid-end').length){
                $('.ifpaid').fadeIn();
            }else{
                $('.ec').fadeIn();
            }
        }
    });
    //金額入力部分
    $('#nuyu').keyup(function() {
        if (parseInt($('#nuyu').val()) < 100 || parseInt($('#nuyu').val()) >999999){
            $('.ifo').fadeIn();
            $('.n3co').fadeOut();
        }else{
            $('.ifo').fadeOut();
            $('.n3co').fadeIn();
            var afec = Math.floor(parseInt($('#nuyu').val()) * 0.9 * parseInt($('#idop').val()) * 0.01);
            var payc = Math.floor(parseInt($('#nuyu').val()) * 0.9 - afec);
            $('.afec').text(afec.toString());
            $('.payc').text(payc.toString());
        }
    });
    //アフィリ入力部分
    $('#idop').keyup(function() {
        if (parseInt($('#idop').val()) < 0 || parseInt($('#idop').val()) >100){
            $('.ifop').fadeIn();
            $('.n4co').fadeOut();
        }else{
            $('.ifop').fadeOut();
            $('.n4co').fadeIn();
            var afec = Math.floor(parseInt($('#nuyu').val()) * 0.9 * parseInt($('#idop').val()) * 0.01);
            var payc = Math.floor(parseInt($('#nuyu').val()) * 0.9 - afec);
            $('.afec').text(afec.toString());
            $('.payc').text(payc.toString());
            
            var paid = $('.fr-element').html().match(/<div class="paid">ここから有料部分<\/div>(.*?)<div class="paid-end">ここまで有料部分<\/div>/)[0].replace(/<div class="paid">ここから有料部分<\/div>/g, '').replace(/<div class="paid-end">ここまで有料部分<\/div>/g, '');
            $('.def').html(paid);
            
        }
    });
    
});

    FroalaEditor.DefineIcon('addPaid', {NAME: 'addPaid', SVG_KEY: 'add'});
    FroalaEditor.RegisterCommand('addPaid', {
      title: '有料部分の追加',
      focus: false,
      undo: true,
      refreshAfterCallback: true,
      callback: function () {
        this.html.insert('<div class="paid">ここから有料部分</div>');
        this.html.insert('<p>ここに有料部分のテキストや画像を追加（有料部分は1記事に1つまでしか反映されません）</p>');
        this.html.insert('<div class="paid-end">ここまで有料部分</div>');
        this.html.insert('<p>');
        this.events.focus();
        
      }
    });
    
    

    // Define custom buttons.
    FroalaEditor.DefineIcon('h2', {NAME: '<strong>H2</strong>', template: 'text'});
    FroalaEditor.DefineIcon('h3', {NAME: '<strong>H3</strong>', template: 'text'});
    FroalaEditor.RegisterCommand('h2', {
      title: 'Heading 1',
      callback: function () {
        this.html.insert('<h2>　</h2>');
    }
    });

    FroalaEditor.RegisterCommand('h3', {
      title: 'Heading 2',
      callback: function () {
        this.html.insert('<h3>　</h3>');
      }
    });
    
    
    
    
    
  new FroalaEditor('#froala-editor', {
     // Set custom buttons.
     toolbarButtons: {
     // Key represents the more button from the toolbar.
     moreText: {
       // List of buttons used in the  group.
       buttons: ['bold', 'italic', 'underline','h2','h3', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', 'textColor', 'backgroundColor', 'inlineClass', 'inlineStyle', 'clearFormatting' ],

       // Alignment of the group in the toolbar.
       align: 'left',

       // By default, 3 buttons are shown in the main toolbar. The rest of them are available when using the more button.
       buttonsVisible: 5
     },


     moreParagraph: {
       buttons: ['alignLeft', 'alignCenter', 'formatOLSimple', 'alignRight', 'alignJustify', 'formatOL', 'formatUL', 'paragraphFormat', 'paragraphStyle', 'lineHeight', 'outdent', 'indent', 'quote'],
       align: 'left',
       buttonsVisible: 3
     },

     moreRich: {
       buttons: ['insertLink', 'insertImage', 'insertVideo', 'insertTable', 'emoticons', 'fontAwesome', 'specialCharacters', 'embedly', 'insertFile', 'insertHR'],
       align: 'left',
       buttonsVisible: 3
     },

     moreMisc: {
       buttons: ['undo', 'redo', 'addPaid','fullscreen', 'print', 'getPDF', 'spellChecker', 'selectAll', 'html', 'help'],
       align: 'right',
       buttonsVisible: 3
     }
     
   },language: 'ja'
   })
   
   
;
