( function(Fork, $) {

  Fork.show_details = function() {
    var fork = $(event.target).parents('tr');
    var details = fork.data('details');

    $.ajax({
      type: "POST",
      url: '/exmo/show_details',
      data: {details: details}
    }).success(function(html){
      $('#details').html(html);
    });
  };


  Fork.refresh_fork = function() {
    var fork = $(event.target).parents('tr');
    fork.addClass('disabledContent');
    $('#details table').addClass('disabledContent');

    $('button', fork).data('disabled', true);

    var details = fork.data('details');
    var id = fork.attr('id');

    $.ajax({
      type: "POST",
      url: '/exmo/refresh_fork',
      data: {details: details, id: id}
    }).success(function(html){
      fork.replaceWith(html);

      $.ajax({
        type: "POST",
        url: '/exmo/show_details',
        data: {details: fork.data('details')}
      }).success(function(html){
        $('#details').html(html);
      });
    });
  };


  $(function() {
    $('#currencies').submit(function() {
      $('#currencies button').prop('disabled', true);
      $('#forks table').addClass('disabledContent');
      $('#details table').html('');

      var valuesToSubmit = $(this).serialize();
      $.ajax({
        type: "GET",
        url: '/exmo/find_forks',
        data: valuesToSubmit
      }).success(function(html){
        $('#forks').html(html);
      }).always(function(){
        $('#currencies button').prop('disabled', false);
      });
      return false;
    });


    $("#selected_currencies input").change(function() {
      var cur = $(this).val();
      var checked = $(this).prop('checked');

      $('#pairs .' + cur).prop('checked', checked);
    });


  });

})(window.Fork = window.Fork || {}, jQuery);