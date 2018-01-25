( function(Fork, $) {

  Fork.show_details = function(url) {
    var fork = $(event.target).parents('tr');
    var details = fork.data('details');

    $.ajax({
      type: "POST",
      url: url,
      data: {details: details}
    }).success(function(html){
      $('#details').html(html);
    });
  };

  Fork.refresh_fork = function(url, url2) {
    var fork = $(event.target).parents('tr');
    fork.addClass('disabledContent');
    $('#details table').addClass('disabledContent');

    $('button', fork).prop('disabled', true);

    var details = fork.data('details');
    var way = fork.data('way');
    var id = fork.attr('id');
    var coins = $('#coins').val();

    $.ajax({
      type: "POST",
      url: url,
      data: {details: details, id: id, way: way, coins: coins}
    }).success(function(html){
      fork.replaceWith(html);

      $.ajax({
        type: "POST",
        url: url2,
        data: {details: fork.data('details')}
      }).success(function(html){
        $('#details').html(html);
      });
    });
  };

  Fork.submit_form = function(url) {
    var form = $('#currencies');

    $('#currencies button').prop('disabled', true);
    $('#forks table').addClass('disabledContent');
    $('#details table').html('');

    var valuesToSubmit = $(form).serialize();
    $.ajax({
      type: "GET",
      url: url,
      data: valuesToSubmit
    }).success(function(html){
      $('#forks').html(html);
    }).always(function(){
      $('#currencies button').prop('disabled', false);
    });
    return false;
  };


 $(document).on('turbolinks:load', function() {

    $("#selected_currencies input").change(function() {
      var cur = $(this).val();
      var checked = $(this).prop('checked');

      $('#pairs .' + cur).prop('checked', checked);
    });

  });

})(window.Fork = window.Fork || {}, jQuery);