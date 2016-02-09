$gallery = $ '#gallery'
$loadMoreButton = $ '#load-more'
addItemCount = 16
added = 0
allData = []

# masonryを準備
$gallery.masonry
  columnWidth: 230
  gutter: 10
  itemSelector: '.gallery-item'

initGallery =  (data) ->
  allData = data

  # 最初のアイテムを表示
  addItems()

  # 追加ボタンがクリックされたら追加で表示
  $loadMoreButton.on 'click', addItems

addItems = ->
  elements = []

  # 追加するデータの配列
  sliceData = allData.slice added, added + addItemCount

  $.each sliceData, (i, item) ->
    itemHTML ="""
      <li class="gallery-item is-loading">
        <a href="#{item.images.large}">
          <img src="#{item.images.thumb}" alt="#{item.title}">
          <span class="caption">
            <span class="inner">
              <b clas="title">#{item.title}</b>
              <time class="date" datetime="#{item.date}">
                #{item.date.replace(/-0?/g, '/')}
              </time>
            </span>
          </span>
        </a>
      </li>
    """
    # HTML文字列をDOM要素化し、配列に追加
    elements.push $(itemHTML).get(0)

  # DOM要素の配列をギャラリーに挿入し、Masonryレイアウトを実行
  $gallery
    .append elements
    .imagesLoaded ->
      $ elements
        .removeClass 'is-loading'
      $gallery.masonry 'appended', elements

  # 柄済みのアイテム数の更新
  added += sliceData.length

  # JSON データがすべて追加し終わっていたら追加ボタンを消す
  if added < allData.length
    $loadMoreButton.show()
  else
    $loadMoreButton.hide()

$.getJSON '/data/content.json', initGallery
