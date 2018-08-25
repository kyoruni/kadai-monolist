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
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end
    end
  end

  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
  end
end
