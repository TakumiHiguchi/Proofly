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

