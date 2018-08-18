class ItemsController < ApplicationController
  def new
    # 最初に初期化しておく(nilでないことを明示しておく)
    @items = []

    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })

      # 扱い易いようにItemとしてインスタンスを作成する（保存はしない）
      results.each do |result|
        item = Item.new(read(result))
        @items << item
      end
    end
  end

  private
  def read(result)
    code = result['itemCode']
    name = result['itemName']
    url  = result['itemUrl']
    # ?_ex=128x128 を空欄に置換する
    image_url = result['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')

    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
end
