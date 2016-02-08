$gallery = $ '#gallery'

# masonryを準備
$gallery.masonry
  columnWidth: 230
  gutter: 10
  itemSelector: '.gallery-item'

$.getJSON '/data/content.json', (data) ->

  elements = []

  $.each data, (i, item) ->
    itemHTML ="""
      <li class="gallery-item is-loading">
        <a href="#{item.images.large}">
          <img src="#{item.images.thumb}" alt="#{item.title}">
        </a>
      </li>
    """
    # HTML文字列をDOM要素化し、配列に追加
    elements.push $(itemHTML).get(0)

  $gallery
    .append elements
    # 画像の読み込みが完了したらMasonryレイアウト
    .imagesLoaded ->
      $ elements
        .removeClass 'is-loading'
      $gallery.masonry 'appended', elements
