$gallery = $ '#gallery'
$loadMoreButton = $ '#load-more'
$filter = $ '#gallery-filter'
addItemCount = 16
added = 0
allData = []
filteredData = []

# masonryを準備
$gallery.masonry
  columnWidth: 230
  gutter: 10
  itemSelector: '.gallery-item'

initGallery = (data) ->
  allData = data

  # 最初はフィルタリングせず、そのまま全てのデータを渡す
  filteredData = allData

  # 最初のアイテムを表示
  addItems()

  # 追加ボタンがクリックされたら追加で表示
  $loadMoreButton.on 'click', addItems

  # フィルターのラジオボタンが変更されたらフィルタリングを実行
  $filter.on 'change', 'input[type="radio"]', filterItems

addItems = (filter) ->
  elements = []

  # 追加するデータの配列
  slicedData = filteredData.slice added, added + addItemCount

  $.each slicedData, (i, item) ->
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

      # フィルタリング時は再配置
      if filter then $gallery.masonry()
    # リンクにColorboxを設定
    .find 'a'
    .colorbox
      maxWidth: '970px'
      maxHeight: '95%'
      title: ->
        $ @
          .find '.inner'
          .html()

  # 追加済みのアイテム数の更新
  added += slicedData.length

  # JSON データがすべて追加し終わっていたら追加ボタンを消す
  if added < filteredData.length
    $loadMoreButton.show()
  else
    $loadMoreButton.hide()

filterItems = ->
  key = $(@).val()

  # 追加済みのMasonryアイテム
  masonryItems = $gallery.masonry 'getItemElements'

  # Masonryアイテムを削除
  $gallery.masonry 'remove', masonryItems

  # フィルタリング済みアイテムのデータと
  # 追加済みアイテム数をリセット
  filteredData = []
  added = 0

  if key is 'all'
    filteredData = allData
  else
    filteredData = $.grep allData, (item) ->
      item.category is key

  addItems true

$.getJSON '/data/content.json', initGallery

# ラジオボタンのカスタマイズ
$ '.filter-form input[type="radio"]'
  .button
    icons:
      primary: 'icon-radio'
