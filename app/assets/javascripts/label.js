$(document).ready(function(){
  $(document).on('turbolinks:load', function() {
    // Taskのedit画面でそのTaskの持っているラベルをあらかじめ選択状態にする
    for(let i=0,l=label_ids.length;i<l;i++){
      $(`#task_label_ids_${label_ids[i]}`).click()
    }
  });
});