  $('#mobile-filter-search').on('click', function() {
    $('#ceramique-filters-content-mobile').css({'top':0});
    $('body').addClass('filter-opened');
  });

  $('#close-search').on('click', function() {
    $('#ceramique-filters-content-mobile').css({'top': '100vh'});
    $('body').removeClass('filter-opened');
  });
