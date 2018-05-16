class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    if params[:back]
      # Feedテーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
      # Feed.newではなくFeed.new(feed_params)にする。
      @feed = Feed.new

      # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
      # newに戻る際も、createと同様に復元処理が必要となる。
      @feed.image.retrieve_from_cache! params[:cache][:image]
    else
      @feed = Feed.new
    end
  end

  def edit
  end

  def create
    # Feedテーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
    # Feed.newではなくFeed.new(feed_params)にする。
    @feed = Feed.new

    # 画像保存（create）の際に、キャッシュから画像を復元してから保存する
    @feed.image.retrieve_from_cache! params[:cache][:image]

    if @feed.save
      redirect_to @feed, notice: 'Feed was successfully created.'
    else
      render :new
    end
  end

  def confirm
    @feed = Feed.new(feed_params)
    render "new" if @feed.invalid?
  end

  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:image, :image_cache)
    end
end
