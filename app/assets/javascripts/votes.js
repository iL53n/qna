$(document).on('turbolinks:load', function(){

  $('.question').on('ajax:success', function(e) {
    var object = e.detail[0];
    $('.rating').html('<p>' + object['rating'] + '</p>')
  })

  $('.answers').on('ajax:success', function(e) {
    var object = e.detail[0]
    var answer = $('.answer_' + object['id'])
    answer.find('.rating').html('<p>' + object['rating'] + '</p>')
  })
});
