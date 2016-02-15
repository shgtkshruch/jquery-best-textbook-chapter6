(function() {
  var $filter, $gallery, $loadMoreButton, addItemCount, addItems, added, allData, filterItems, filteredData, getMouseDirection, hoverDirection, initGallery;

  $gallery = $('#gallery');

  $loadMoreButton = $('#load-more');

  $filter = $('#gallery-filter');

  addItemCount = 16;

  added = 0;

  allData = [];

  filteredData = [];

  $gallery.masonry({
    columnWidth: 230,
    gutter: 10,
    itemSelector: '.gallery-item'
  });

  initGallery = function(data) {
    allData = data;
    filteredData = allData;
    addItems();
    $loadMoreButton.on('click', addItems);
    $filter.on('change', 'input[type="radio"]', filterItems);
    return $gallery.on('mouseenter mouseleave', '.gallery-item a', hoverDirection);
  };

  addItems = function(filter) {
    var elements, slicedData;
    elements = [];
    slicedData = filteredData.slice(added, added + addItemCount);
    $.each(slicedData, function(i, item) {
      var itemHTML;
      itemHTML = "<li class=\"gallery-item is-loading\">\n  <a href=\"" + item.images.large + "\">\n    <img src=\"" + item.images.thumb + "\" alt=\"" + item.title + "\">\n    <span class=\"caption\">\n      <span class=\"inner\">\n        <b class=\"title\">" + item.title + "</b>\n        <time class=\"date\" datetime=\"" + item.date + "\">\n          " + (item.date.replace(/-0?/g, '/')) + "\n        </time>\n      </span>\n    </span>\n  </a>\n</li>";
      return elements.push($(itemHTML).get(0));
    });
    $gallery.append(elements).imagesLoaded(function() {
      $(elements).removeClass('is-loading');
      $gallery.masonry('appended', elements);
      if (filter) {
        return $gallery.masonry();
      }
    }).find('a').colorbox({
      maxWidth: '970px',
      maxHeight: '95%',
      title: function() {
        return $(this).find('.inner').html();
      }
    });
    added += slicedData.length;
    if (added < filteredData.length) {
      return $loadMoreButton.show();
    } else {
      return $loadMoreButton.hide();
    }
  };

  filterItems = function() {
    var key, masonryItems;
    key = $(this).val();
    masonryItems = $gallery.masonry('getItemElements');
    $gallery.masonry('remove', masonryItems);
    filteredData = [];
    added = 0;
    if (key === 'all') {
      filteredData = allData;
    } else {
      filteredData = $.grep(allData, function(item) {
        return item.category === key;
      });
    }
    return addItems(true);
  };

  hoverDirection = function(event) {
    var $overlay, animateTo, positionIn, positionOut, side;
    $overlay = $(this).find('.caption');
    side = getMouseDirection(event);
    animateTo;
    positionIn = {
      top: '0%',
      left: '0%'
    };
    positionOut = (function() {
      switch (side) {
        case 0:
          return {
            top: '-100%',
            left: '0%'
          };
        case 1:
          return {
            top: '0%',
            left: '100%'
          };
        case 2:
          return {
            top: '100%',
            left: '0%'
          };
        case 3:
          return {
            top: '0%',
            left: '-100%'
          };
      }
    })();
    if (event.type === 'mouseenter') {
      animateTo = positionIn;
      $overlay.css(positionOut);
    } else {
      animateTo = positionOut;
    }
    return $overlay.stop(true).animate(animateTo, 250, 'easeOutExpo');
  };

  getMouseDirection = function(event) {
    var $el, direction, h, offset, w, x, y;
    $el = $(event.currentTarget);
    offset = $el.offset();
    w = $el.outerWidth();
    h = $el.outerHeight();
    x = (event.pageX - offset.left - w / 2) * (w > h ? h / w : 1);
    y = (event.pageY - offset.top - h / 2) * (h > w ? w / h : 1);
    direction = Math.round((Math.atan2(y, x) * (180 / Math.PI) + 180) / 90 + 3) % 4;
    return direction;
  };

  $.getJSON('data/content.json', initGallery);

  $('.filter-form input[type="radio"]').button({
    icons: {
      primary: 'icon-radio'
    }
  });

}).call(this);
